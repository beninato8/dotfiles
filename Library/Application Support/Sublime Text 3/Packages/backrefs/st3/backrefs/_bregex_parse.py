"""
Backrefs Regex parser.

Licensed under MIT
Copyright (c) 2011 - 2020 Isaac Muse <isaacmuse@gmail.com>
"""
import unicodedata as _unicodedata
import copyreg as _copyreg
from . import util as _util
import regex as _regex

try:  # pragma: no cover
    from regex import __version__ as _regex_version
except ImportError:  # pragma: no cover
    from regex.regex import __version__ as _regex_version

try:  # pragma: no cover
    from regex import _compile_replacement_helper
except ImportError:  # pragma: no cover
    from regex.regex import _compile_replacement_helper

_REGEX_COMMENT_FIX = tuple([int(x) for x in _regex_version.split('.')]) > (2, 4, 136)

_ASCII_LETTERS = frozenset(
    (
        'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
        'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
        'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
    )
)
_DIGIT = frozenset(('0', '1', '2', '3', '4', '5', '6', '7', '8', '9'))
_OCTAL = frozenset(('0', '1', '2', '3', '4', '5', '6', '7'))
_HEX = frozenset(('a', 'b', 'c', 'd', 'e', 'f', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'))
_LETTERS_UNDERSCORE = _ASCII_LETTERS | frozenset(('_',))
_WORD = _LETTERS_UNDERSCORE | _DIGIT
_STANDARD_ESCAPES = frozenset(('a', 'b', 'f', 'n', 'r', 't', 'v'))
_CURLY_BRACKETS = frozenset(('{', '}'))
_PROPERTY_STRIP = frozenset((' ', '-', '_'))
_PROPERTY = _WORD | _DIGIT | _PROPERTY_STRIP
_GLOBAL_FLAGS = frozenset(('L', 'a', 'b', 'e', 'r', 'u', 'p'))
_SCOPED_FLAGS = frozenset(('i', 'm', 's', 'f', 'w', 'x'))
_VERSIONS = frozenset(('0', '1'))

_CURLY_BRACKETS_ORD = frozenset((0x7b, 0x7d))

# Case upper or lower
_UPPER = 1
_LOWER = 2

# Format Constants
_BACK_SLASH_TRANSLATION = {
    "\\a": '\a',
    "\\b": '\b',
    "\\f": '\f',
    "\\r": '\r',
    "\\t": '\t',
    "\\n": '\n',
    "\\v": '\v',
    "\\\\": '\\'
}

_FMT_CONV_TYPE = ('a', 'r', 's')


class LoopException(Exception):
    """Loop exception."""


class GlobalRetryException(Exception):
    """Global retry exception."""


class _SearchParser(object):
    """Search Template."""

    _new_refs = ("e", "R", "Q", "E")
    _re_escape = r"\x1b"
    _line_break = r'(?>\r\n|[\n\v\f\r\x85\u2028\u2029])'
    _bytes_line_break = r'(?>\r\n|[\n\v\f\r\x85])'

    def __init__(self, search, re_verbose=False, re_version=0):
        """Initialize."""

        if isinstance(search, bytes):
            self.is_bytes = True
        else:
            self.is_bytes = False

        if self.is_bytes:
            self._re_line_break = self._bytes_line_break
        else:
            self._re_line_break = self._line_break
        self.re_verbose = re_verbose
        self.re_version = re_version
        self.search = search

    def process_quotes(self, text):
        """Process quotes."""

        escaped = False
        in_quotes = False
        current = []
        quoted = []
        i = _util.StringIter(text)

        for t in i:
            if not escaped and t == "\\":
                escaped = True
            elif escaped:
                escaped = False
                if t == "E":
                    if in_quotes:
                        current.append(_regex.escape("".join(quoted)))
                        quoted = []
                        in_quotes = False
                elif t == "Q" and not in_quotes:
                    in_quotes = True
                elif in_quotes:
                    quoted.extend(["\\", t])
                else:
                    current.extend(["\\", t])
            elif in_quotes:
                quoted.extend(t)
            else:
                current.append(t)

        if in_quotes and escaped:
            quoted.append("\\")
        elif escaped:
            current.append("\\")

        if quoted:
            current.append(_regex.escape("".join(quoted)))

        return "".join(current)

    def verbose_comment(self, t, i):
        """Handle verbose comments."""

        current = []
        escaped = False

        try:
            while t != "\n":
                if not escaped and t == "\\":
                    escaped = True
                    current.append(t)
                elif escaped:
                    escaped = False
                    if t in self._new_refs:
                        current.append("\\")
                    current.append(t)
                else:
                    current.append(t)
                t = next(i)
        except StopIteration:
            pass

        if t == "\n":
            current.append(t)
        return current

    def flags(self, text, scoped=False):
        """Analyze flags."""

        global_retry = False
        if (self.version == _regex.V1 or scoped) and '-x' in text and self.verbose:
            self.verbose = False
        elif 'x' in text and not self.verbose:
            self.verbose = True
            if not scoped and self.version == _regex.V0:
                self.temp_global_flag_swap['verbose'] = True
                global_retry = True
        if 'V0' in text and self.version == _regex.V1:  # pragma: no cover
            # Default is V0 if none is selected,
            # so it is unlikely that this will be selected.
            self.temp_global_flag_swap['version'] = True
            self.version = _regex.V0
            global_retry = True
        elif "V1" in text and self.version == _regex.V0:
            self.temp_global_flag_swap['version'] = True
            self.version = _regex.V1
            global_retry = True
        if global_retry:
            raise GlobalRetryException('Global Retry')

    def reference(self, t, i, in_group=False):
        """Handle references."""

        current = []

        if not in_group and t == "R":
            current.append(self._re_line_break)
        elif t == 'e':
            _util.warn_deprecated(R"The \e reference has been deprecated, please use \x1b instead")
            current.extend(self._re_escape)
        else:
            current.extend(["\\", t])
        return current

    def get_posix(self, i):
        """Get POSIX."""

        index = i.index
        value = ['[']
        try:
            c = next(i)
            if c != ':':
                raise ValueError('Not a valid property!')
            else:
                value.append(c)
                c = next(i)
                if c == '^':
                    value.append(c)
                    c = next(i)
                while c != ':':
                    if c not in _PROPERTY:
                        raise ValueError('Not a valid property!')
                    if c not in _PROPERTY_STRIP:
                        value.append(c)
                    c = next(i)
                value.append(c)
                c = next(i)
                if c != ']' or not value:
                    raise ValueError('Unmatched ]')
                value.append(c)
        except Exception:
            i.rewind(i.index - index)
            value = []
        return ''.join(value) if value else None

    def get_comments(self, i):
        """Get comments."""

        index = i.index
        value = ['(']
        escaped = False
        try:
            c = next(i)
            if c != '?':
                i.rewind(1)
                return None
            value.append(c)
            c = next(i)
            if c != '#':
                i.rewind(2)
                return None
            value.append(c)
            c = next(i)
            while c != ')' or escaped is True:
                if _REGEX_COMMENT_FIX:
                    if escaped:
                        escaped = False
                    elif c == '\\':
                        escaped = True
                value.append(c)
                c = next(i)
            value.append(c)
        except StopIteration:
            raise SyntaxError("Unmatched '(' at {}!".format(index - 1))

        return ''.join(value) if value else None

    def get_flags(self, i, version0, scoped=False):
        """Get flags."""

        index = i.index
        value = ['(']
        version = False
        toggle = False
        end = ':' if scoped else ')'
        try:
            c = next(i)
            if c != '?':
                i.rewind(1)
                return None
            value.append(c)
            c = next(i)
            while c != end:
                if toggle:
                    if c not in _SCOPED_FLAGS:
                        raise ValueError('Bad scope')
                    toggle = False
                elif (not version0 or scoped) and c == '-':
                    toggle = True
                elif version:
                    if c not in _VERSIONS:
                        raise ValueError('Bad version')
                    version = False
                elif c == 'V':
                    version = True
                elif c not in _GLOBAL_FLAGS and c not in _SCOPED_FLAGS:
                    raise ValueError("Bad flag")
                value.append(c)
                c = next(i)
            value.append(c)
        except Exception:
            i.rewind(i.index - index)
            value = []

        return ''.join(value) if value else None

    def subgroup(self, t, i):
        """Handle parenthesis."""

        # (?flags)
        flags = self.get_flags(i, self.version == _regex.V0)
        if flags:
            self.flags(flags[2:-1])
            return [flags]

        # (?#comment)
        comments = self.get_comments(i)
        if comments:
            return [comments]

        verbose = self.verbose

        # (?flags:pattern)
        flags = self.get_flags(i, (self.version == _regex.V0), True)
        if flags:
            t = flags
            self.flags(flags[2:-1], scoped=True)

        current = []
        try:
            while t != ')':
                if not current:
                    current.append(t)
                else:
                    current.extend(self.normal(t, i))

                t = next(i)
        except StopIteration:
            pass
        self.verbose = verbose

        if t == ")":
            current.append(t)
        return current

    def char_groups(self, t, i):
        """Handle character groups."""

        current = []
        pos = i.index - 1
        found = 0
        sub_first = 0
        escaped = False
        first = 0

        try:
            while True:
                if not escaped and t == "\\":
                    escaped = True
                elif escaped:
                    escaped = False
                    current.extend(self.reference(t, i, True))
                elif t == "[" and not found:
                    found += 1
                    first = pos
                    current.append(t)
                elif t == "[" and found and self.version == _regex.V1:
                    # Start of sub char set found
                    posix = None if self.is_bytes else self.get_posix(i)
                    if posix:
                        current.append(posix)
                        pos = i.index - 2
                    else:
                        found += 1
                        sub_first = pos
                        current.append(t)
                elif t == "[":
                    posix = None if self.is_bytes else self.get_posix(i)
                    if posix:
                        current.append(posix)
                        pos = i.index - 2
                    else:
                        current.append(t)
                elif t == "^" and found == 1 and (pos == first + 1):
                    # Found ^ at start of first char set; adjust 1st char position
                    current.append(t)
                    first = pos
                elif self.version == _regex.V1 and t == "^" and found > 1 and (pos == sub_first + 1):
                    # Found ^ at start of sub char set; adjust 1st char sub position
                    current.append(t)
                    sub_first = pos
                elif t == "]" and found == 1 and (pos != first + 1):
                    # First char set closed; log range
                    current.append(t)
                    found = 0
                    break
                elif self.version == _regex.V1 and t == "]" and found > 1 and (pos != sub_first + 1):
                    # Sub char set closed; decrement depth counter
                    found -= 1
                    current.append(t)
                else:
                    current.append(t)
                pos += 1
                t = next(i)
        except StopIteration:
            pass

        if escaped:
            current.append(t)
        return current

    def normal(self, t, i):
        """Handle normal chars."""

        current = []

        if t == "\\":
            try:
                t = next(i)
                current.extend(self.reference(t, i))
            except StopIteration:
                current.append(t)
        elif t == "(":
            current.extend(self.subgroup(t, i))
        elif self.verbose and t == "#":
            current.extend(self.verbose_comment(t, i))
        elif t == "[":
            current.extend(self.char_groups(t, i))
        else:
            current.append(t)
        return current

    def main_group(self, i):
        """The main group: group 0."""

        current = []
        while True:
            try:
                t = next(i)
                current.extend(self.normal(t, i))
            except StopIteration:
                break
        return current

    def _parse(self, search):
        """Begin parsing."""

        self.verbose = bool(self.re_verbose)
        self.version = self.re_version if self.re_version else _regex.DEFAULT_VERSION
        self.global_flag_swap = {
            "version": self.re_version != 0,
            "verbose": False
        }
        self.temp_global_flag_swap = {
            "version": False,
            "verbose": False
        }

        new_pattern = []
        i = _util.StringIter(self.process_quotes(search))

        retry = True
        while retry:
            retry = False
            try:
                new_pattern = self.main_group(i)
            except GlobalRetryException:
                # Prevent a loop of retry over and over for a pattern like ((?V0)(?V1))
                # or on V0 (?-x:(?x))
                if self.temp_global_flag_swap['version']:
                    if self.global_flag_swap['version']:
                        raise LoopException('Global version flag recursion.')
                    else:
                        self.global_flag_swap["version"] = True
                if self.temp_global_flag_swap['verbose']:
                    if self.global_flag_swap['verbose']:
                        raise LoopException('Global verbose flag recursion.')
                    else:
                        self.global_flag_swap['verbose'] = True
                self.temp_global_flag_swap = {
                    "version": False,
                    "verbose": False
                }
                i.rewind(i.index)
                retry = True
        return "".join(new_pattern)

    def parse(self):
        """Apply search template."""

        if isinstance(self.search, bytes):
            return self._parse(self.search.decode('latin-1')).encode('latin-1')
        else:
            return self._parse(self.search)


class _ReplaceParser(object):
    """Pre-replace template."""

    def __init__(self, pattern, template, use_format=False):
        """Initialize."""

        self.pattern = pattern
        self._original = template
        self._template = template
        self.use_format = use_format
        self.end_found = False
        self.group_slots = []
        self.literal_slots = []
        self.result = []
        self.span_stack = []
        self.single_stack = []
        self.literals = []
        self.groups = []
        self.slot = 0
        self.manual = False
        self.auto = False
        self.auto_index = 0
        self.is_bytes = isinstance(self._original, bytes)

    def parse_format_index(self, text):
        """Parse format index."""

        base = 10
        prefix = text[1:3] if text[0] == "-" else text[:2]
        if prefix[0:1] == "0":
            char = prefix[-1]
            if char == "b":
                base = 2
            elif char == "o":
                base = 8
            elif char == "x":
                base = 16
        try:
            idx = int(text, base)
        except Exception:
            idx = text
        return idx

    def get_format(self, c, i):
        """Get format group."""

        index = i.index
        field = ''
        value = []

        try:
            if c == '}':
                value.append((_util.FMT_FIELD, ''))
                value.append((_util.FMT_INDEX, None))
            else:
                # Field
                temp = []
                if c in _LETTERS_UNDERSCORE:
                    # Handle name
                    temp.append(c)
                    c = self.format_next(i)
                    while c in _WORD:
                        temp.append(c)
                        c = self.format_next(i)
                elif c in _DIGIT:
                    # Handle group number
                    temp.append(c)
                    c = self.format_next(i)
                    while c in _DIGIT:
                        temp.append(c)
                        c = self.format_next(i)

                # Try and covert to integer index
                field = ''.join(temp).strip()
                try:
                    value = [(_util.FMT_FIELD, str(int(field, 10)))]
                except ValueError:
                    value = [(_util.FMT_FIELD, field)]
                    pass

                if c != '[':
                    value.append((_util.FMT_INDEX, None))

                # Attributes and indexes
                while c in ('[', '.'):
                    if c == '[':
                        findex = []
                        sindex = i.index - 1
                        c = self.format_next(i)
                        try:
                            while c != ']':
                                findex.append(c)
                                c = self.format_next(i)
                        except StopIteration:
                            raise SyntaxError("Unmatched '[' at {}".format(sindex - 1))
                        idx = self.parse_format_index(''.join(findex))
                        value.append((_util.FMT_INDEX, idx))
                        c = self.format_next(i)
                    else:
                        findex = []
                        c = self.format_next(i)
                        while c in _WORD:
                            findex.append(c)
                            c = self.format_next(i)
                        value.append((_util.FMT_ATTR, ''.join(findex)))

                # Conversion
                if c == '!':
                    c = self.format_next(i)
                    if c not in _FMT_CONV_TYPE:
                        raise SyntaxError("Invalid conversion type at {}!".format(i.index - 1))
                    value.append((_util.FMT_CONV, c))
                    c = self.format_next(i)

                # Format spec
                if c == ':':
                    fill = None
                    width = []
                    align = None
                    convert = None
                    c = self.format_next(i)

                    if c in ('<', '>', '^'):
                        # Get fill and alignment
                        align = c
                        c = self.format_next(i)
                        if c in ('<', '>', '^'):
                            fill = align
                            align = c
                            c = self.format_next(i)
                    elif c in _DIGIT:
                        # Get Width
                        fill = c
                        c = self.format_next(i)
                        if c in ('<', '>', '^'):
                            align = c
                            c = self.format_next(i)
                        else:
                            width.append(fill)
                            fill = None
                    else:
                        fill = c
                        c = self.format_next(i)
                        if fill == 's' and c == '}':
                            convert = fill
                            fill = None
                        if fill is not None:
                            if c not in ('<', '>', '^'):
                                raise SyntaxError('Invalid format spec char at {}!'.format(i.index - 1))
                            align = c
                            c = self.format_next(i)

                    while c in _DIGIT:
                        width.append(c)
                        c = self.format_next(i)

                    if not align and len(width) and width[0] == '0':
                        raise ValueError("'=' alignment is not supported!")
                    if align and not fill and len(width) and width[0] == '0':
                        fill = '0'

                    if c == 's':
                        convert = c
                        c = self.format_next(i)

                    if not fill:
                        fill = ' '

                    value.append(
                        (
                            _util.FMT_SPEC,
                            (
                                fill.encode('latin-1') if self.is_bytes else fill,
                                align,
                                (int(''.join(width)) if width else 0),
                                convert
                            )
                        )
                    )

            if c != '}':
                raise SyntaxError("Unmatched '{{' at {}".format(index - 1))
        except StopIteration:
            raise SyntaxError("Unmatched '{{' at {}!".format(index - 1))

        return field, value

    def handle_format(self, t, i):
        """Handle format."""

        if t == '{':
            t = self.format_next(i)
            if t == '{':
                self.get_single_stack()
                self.result.append(t)
            else:
                field, text = self.get_format(t, i)
                self.handle_format_group(field, text)
        else:
            t = self.format_next(i)
            if t == '}':
                self.get_single_stack()
                self.result.append(t)
            else:
                raise SyntaxError("Unmatched '}}' at {}!".format(i.index - 2))

    def get_octal(self, c, i):
        """Get octal."""

        index = i.index
        value = []
        zero_count = 0
        try:
            if c == '0':
                for x in range(3):
                    if c != '0':
                        break
                    value.append(c)
                    c = next(i)
            zero_count = len(value)
            if zero_count < 3:
                for x in range(3 - zero_count):
                    if c not in _OCTAL:
                        break
                    value.append(c)
                    c = next(i)
            i.rewind(1)
        except StopIteration:
            pass

        octal_count = len(value)
        if not (self.use_format and octal_count) and not (zero_count and octal_count < 3) and octal_count != 3:
            i.rewind(i.index - index)
            value = []

        return ''.join(value) if value else None

    def parse_octal(self, text, i):
        """Parse octal value."""

        value = int(text, 8)
        if value > 0xFF and self.is_bytes:
            # Re fails on octal greater than `0o377` or `0xFF`
            raise ValueError("octal escape value outside of range 0-0o377!")
        else:
            single = self.get_single_stack()
            if self.span_stack:
                text = self.convert_case(chr(value), self.span_stack[-1])
                value = ord(self.convert_case(text, single)) if single is not None else ord(text)
            elif single:
                value = ord(self.convert_case(chr(value), single))
            if self.use_format and value in _CURLY_BRACKETS_ORD:
                self.handle_format(chr(value), i)
            elif value <= 0xFF:
                self.result.append('\\{:03o}'.format(value))
            else:
                self.result.append(chr(value))

    def get_named_unicode(self, i):
        """Get named Unicode."""

        index = i.index
        value = []
        try:
            if next(i) != '{':
                raise SyntaxError("Named Unicode missing '{{' at {}!".format(i.index - 1))
            c = next(i)
            while c != '}':
                value.append(c)
                c = next(i)
        except StopIteration:
            raise SyntaxError("Unmatched '{{' at {}!".format(index))

        return ''.join(value)

    def parse_named_unicode(self, i):
        """Parse named Unicode."""

        value = ord(_unicodedata.lookup(self.get_named_unicode(i)))
        single = self.get_single_stack()
        if self.span_stack:
            text = self.convert_case(chr(value), self.span_stack[-1])
            value = ord(self.convert_case(text, single)) if single is not None else ord(text)
        elif single:
            value = ord(self.convert_case(chr(value), single))
        if self.use_format and value in _CURLY_BRACKETS_ORD:
            self.handle_format(chr(value), i)
        elif value <= 0xFF:
            self.result.append('\\{:03o}'.format(value))
        else:
            self.result.append(chr(value))

    def get_wide_unicode(self, i):
        """Get narrow Unicode."""

        value = []
        for x in range(3):
            c = next(i)
            if c == '0':
                value.append(c)
            else:  # pragma: no cover
                raise SyntaxError('Invalid wide Unicode character at {}!'.format(i.index - 1))

        c = next(i)
        if c in ('0', '1'):
            value.append(c)
        else:  # pragma: no cover
            raise SyntaxError('Invalid wide Unicode character at {}!'.format(i.index - 1))

        for x in range(4):
            c = next(i)
            if c.lower() in _HEX:
                value.append(c)
            else:  # pragma: no cover
                raise SyntaxError('Invalid wide Unicode character at {}!'.format(i.index - 1))
        return ''.join(value)

    def get_narrow_unicode(self, i):
        """Get narrow Unicode."""

        value = []
        for x in range(4):
            c = next(i)
            if c.lower() in _HEX:
                value.append(c)
            else:  # pragma: no cover
                raise SyntaxError('Invalid Unicode character at {}!'.format(i.index - 1))
        return ''.join(value)

    def parse_unicode(self, i, wide=False):
        """Parse Unicode."""

        text = self.get_wide_unicode(i) if wide else self.get_narrow_unicode(i)
        value = int(text, 16)
        single = self.get_single_stack()
        if self.span_stack:
            text = self.convert_case(chr(value), self.span_stack[-1])
            value = ord(self.convert_case(text, single)) if single is not None else ord(text)
        elif single:
            value = ord(self.convert_case(chr(value), single))
        if self.use_format and value in _CURLY_BRACKETS_ORD:
            self.handle_format(chr(value), i)
        elif value <= 0xFF:
            self.result.append('\\{:03o}'.format(value))
        else:
            self.result.append(chr(value))

    def get_byte(self, i):
        """Get byte."""

        value = []
        for x in range(2):
            c = next(i)
            if c.lower() in _HEX:
                value.append(c)
            else:  # pragma: no cover
                raise SyntaxError('Invalid byte character at {}!'.format(i.index - 1))
        return ''.join(value)

    def parse_bytes(self, i):
        """Parse byte."""

        value = int(self.get_byte(i), 16)
        single = self.get_single_stack()
        if self.span_stack:
            text = self.convert_case(chr(value), self.span_stack[-1])
            value = ord(self.convert_case(text, single)) if single is not None else ord(text)
        elif single:
            value = ord(self.convert_case(chr(value), single))
        if self.use_format and value in _CURLY_BRACKETS_ORD:
            self.handle_format(chr(value), i)
        else:
            self.result.append('\\{:03o}'.format(value))

    def get_named_group(self, t, i):
        """Get group number."""

        index = i.index
        value = [t]
        try:
            c = next(i)
            if c != "<":
                raise SyntaxError("Group missing '<' at {}!".format(i.index - 1))
            value.append(c)
            c = next(i)
            if c in _DIGIT:
                value.append(c)
                c = next(i)
                while c != '>':
                    if c in _DIGIT:
                        value.append(c)
                    c = next(i)
                value.append(c)
            elif c in _LETTERS_UNDERSCORE:
                value.append(c)
                c = next(i)
                while c != '>':
                    if c in _WORD:
                        value.append(c)
                    c = next(i)
                value.append(c)
            else:
                raise SyntaxError("Invalid group character at {}!".format(i.index - 1))
        except StopIteration:
            raise SyntaxError("Unmatched '<' at {}!".format(index))

        return ''.join(value)

    def get_group(self, t, i):
        """Get group number."""

        value = []
        try:
            if t in _DIGIT and t != '0':
                value.append(t)
                t = next(i)
                if t in _DIGIT:
                    value.append(t)
                else:
                    i.rewind(1)
        except StopIteration:
            pass
        return ''.join(value) if value else None

    def format_next(self, i):
        """Get next format char."""

        c = next(i)
        return self.format_references(next(i), i) if c == '\\' else c

    def format_references(self, t, i):
        """Handle format references."""

        octal = self.get_octal(t, i)
        if octal:
            o = int(octal, 8)
            if o > 0xFF and self.is_bytes:
                # Re fails on octal greater than `0o377` or `0xFF`
                raise ValueError("octal escape value outside of range 0-0o377!")
            value = chr(o)
        elif t in _STANDARD_ESCAPES or t == '\\':
            value = _BACK_SLASH_TRANSLATION['\\' + t]
        elif not self.is_bytes and t == "U":
            value = chr(int(self.get_wide_unicode(i), 16))
        elif not self.is_bytes and t == "u":
            value = chr(int(self.get_narrow_unicode(i), 16))
        elif not self.is_bytes and t == "N":
            value = _unicodedata.lookup(self.get_named_unicode(i))
        elif t == "x":
            value = chr(int(self.get_byte(i), 16))
        else:
            i.rewind(1)
            value = '\\'
        return value

    def reference(self, t, i):
        """Handle references."""
        octal = self.get_octal(t, i)
        if t in _OCTAL and octal:
            self.parse_octal(octal, i)
        elif (t in _DIGIT or t == 'g') and not self.use_format:
            group = self.get_group(t, i)
            if not group:
                group = self.get_named_group(t, i)
            self.handle_group('\\' + group)
        elif t in _STANDARD_ESCAPES:
            self.get_single_stack()
            self.result.append('\\' + t)
        elif t == "l":
            self.single_case(i, _LOWER)
        elif t == "L":
            self.span_case(i, _LOWER)
        elif t == "c":
            self.single_case(i, _UPPER)
        elif t == "C":
            self.span_case(i, _UPPER)
        elif t == "E":
            self.end_found = True
        elif not self.is_bytes and t == "U":
            self.parse_unicode(i, True)
        elif not self.is_bytes and t == "u":
            self.parse_unicode(i)
        elif not self.is_bytes and t == "N":
            self.parse_named_unicode(i)
        elif t == "x":
            self.parse_bytes(i)
        elif self.use_format and t in _CURLY_BRACKETS:
            self.result.append('\\\\')
            self.handle_format(t, i)
        elif self.use_format and t == 'g':
            self.result.append('\\\\')
            self.result.append(t)
        else:
            value = '\\' + t
            self.get_single_stack()
            if self.span_stack:
                value = self.convert_case(value, self.span_stack[-1])
            self.result.append(value)

    def _parse_template(self, template):
        """Parse template."""

        self.result = [""]

        i = _util.StringIter(template)

        while True:
            try:
                t = next(i)
                if self.use_format and t in _CURLY_BRACKETS:
                    self.handle_format(t, i)
                elif t == '\\':
                    try:
                        t = next(i)
                        self.reference(t, i)
                    except StopIteration:
                        self.result.append(t)
                        raise
                else:
                    self.result.append(t)

            except StopIteration:
                break

        if len(self.result) > 1:
            self.literal_slots.append("".join(self.result))
            del self.result[:]
            self.result.append("")
            self.slot += 1

        return "".join(self.literal_slots)

    def parse_template(self):
        """Parse template."""

        if isinstance(self._original, bytes):
            self._template = self._parse_template(self._original.decode('latin-1')).encode('latin-1')
        else:
            self._template = self._parse_template(self._original)

        count = 0
        for part in _compile_replacement_helper(self.pattern, self._template):
            if isinstance(part, int):
                self.literals.append(None)
                self.groups.append((count, part))
            else:
                self.literals.append(part)
            count += 1

    def span_case(self, i, case):
        """Uppercase or lowercase the next range of characters until end marker is found."""

        # A new \L, \C or \E should pop the last in the stack.
        if self.span_stack:
            self.span_stack.pop()
        if self.single_stack:
            self.single_stack.pop()
        self.span_stack.append(case)
        count = len(self.span_stack)
        self.end_found = False
        try:
            while not self.end_found:
                t = next(i)
                if self.use_format and t in _CURLY_BRACKETS:
                    self.handle_format(t, i)
                elif t == '\\':
                    try:
                        t = next(i)
                        self.reference(t, i)
                    except StopIteration:
                        self.result.append(t)
                        raise
                else:
                    self.result.append(self.convert_case(t, case))
                if self.end_found or count > len(self.span_stack):
                    self.end_found = False
                    break
        except StopIteration:
            pass
        if count == len(self.span_stack):
            self.span_stack.pop()

    def convert_case(self, value, case):
        """Convert case."""

        if self.is_bytes:
            cased = []
            for c in value:
                if c in _ASCII_LETTERS:
                    cased.append(c.lower() if case == _LOWER else c.upper())
                else:
                    cased.append(c)
            return "".join(cased)
        else:
            return value.lower() if case == _LOWER else value.upper()

    def single_case(self, i, case):
        """Uppercase or lowercase the next character."""

        # Pop a previous case if we have consecutive ones.
        if self.single_stack:
            self.single_stack.pop()
        self.single_stack.append(case)
        try:
            t = next(i)
            if self.use_format and t in _CURLY_BRACKETS:
                self.handle_format(t, i)
            elif t == '\\':
                try:
                    t = next(i)
                    self.reference(t, i)
                except StopIteration:
                    self.result.append(t)
                    raise
            else:
                this_case = self.get_single_stack()
                if this_case is not None:
                    self.result.append(self.convert_case(t, this_case))
        except StopIteration:
            pass

    def get_single_stack(self):
        """Get the correct single stack item to use."""

        single = None
        while self.single_stack:
            single = self.single_stack.pop()
        return single

    def handle_format_group(self, field, text):
        """Handle format group."""

        # Handle auto incrementing group indexes
        if field == '':
            if self.auto:
                field = str(self.auto_index)
                text[0] = (_util.FMT_FIELD, field)
                self.auto_index += 1
            elif not self.manual and not self.auto:
                self.auto = True
                field = str(self.auto_index)
                text[0] = (_util.FMT_FIELD, field)
                self.auto_index += 1
            else:
                raise ValueError("Cannot switch to auto format during manual format!")
        elif not self.manual and not self.auto:
            self.manual = True
        elif not self.manual:
            raise ValueError("Cannot switch to manual format during auto format!")

        self.handle_group(field, tuple(text), True)

    def handle_group(self, text, capture=None, is_format=False):
        """Handle groups."""

        if len(self.result) > 1:
            self.literal_slots.append("".join(self.result))
            if is_format:
                self.literal_slots.extend(["\\g<", text, ">"])
            else:
                self.literal_slots.append(text)
            del self.result[:]
            self.result.append("")
            self.slot += 1
        elif is_format:
            self.literal_slots.extend(["\\g<", text, ">"])
        else:
            self.literal_slots.append(text)

        self.group_slots.append(
            (
                self.slot,
                (
                    (self.span_stack[-1] if self.span_stack else None),
                    self.get_single_stack(),
                    (tuple() if self.is_bytes else '') if capture is None else capture
                )
            )
        )
        self.slot += 1

    def get_base_template(self):
        """Return the unmodified template before expansion."""

        return self._original

    def parse(self):
        """Parse template."""

        if not isinstance(self.pattern.pattern, type(self._original)):
            raise TypeError('Pattern string type must match replace template string type!')

        self.parse_template()

        return ReplaceTemplate(
            tuple(self.groups),
            tuple(self.group_slots),
            tuple(self.literals),
            hash(self.pattern),
            self.use_format,
            self.is_bytes
        )


class ReplaceTemplate(_util.Immutable):
    """Replacement template expander."""

    __slots__ = ("groups", "group_slots", "literals", "pattern_hash", "use_format", "_hash", "_bytes")

    def __init__(self, groups, group_slots, literals, pattern_hash, use_format, is_bytes):
        """Initialize."""

        super(ReplaceTemplate, self).__init__(
            use_format=use_format,
            groups=groups,
            group_slots=group_slots,
            literals=literals,
            pattern_hash=pattern_hash,
            _bytes=is_bytes,
            _hash=hash(
                (
                    type(self),
                    groups, group_slots, literals,
                    pattern_hash, use_format, is_bytes
                )
            )
        )

    def __call__(self, m):
        """Call."""

        return self.expand(m)

    def __hash__(self):
        """Hash."""

        return self._hash

    def __eq__(self, other):
        """Equal."""

        return (
            isinstance(other, ReplaceTemplate) and
            self.groups == other.groups and
            self.group_slots == other.group_slots and
            self.literals == other.literals and
            self.pattern_hash == other.pattern_hash and
            self.use_format == other.use_format and
            self._bytes == other._bytes
        )

    def __ne__(self, other):
        """Equal."""

        return (
            not isinstance(other, ReplaceTemplate) or
            self.groups != other.groups or
            self.group_slots != other.group_slots or
            self.literals != other.literals or
            self.pattern_hash != other.pattern_hash or
            self.use_format != other.use_format or
            self._bytes != other._bytes
        )

    def __repr__(self):  # pragma: no cover
        """Representation."""

        return "{}.{}({!r}, {!r}, {!r}, {!r}, {!r})".format(
            self.__module__, self.__class__.__name__,
            self.groups, self.group_slots, self.literals,
            self.pattern_hash, self.use_format
        )

    def _get_group_index(self, index):
        """Find and return the appropriate group index."""

        g_index = 0
        for group in self.groups:
            if group[0] == index:
                g_index = group[1]
                break
        return g_index

    def _get_group_attributes(self, index):
        """Find and return the appropriate group case."""

        g_case = (None, None, -1)
        for group in self.group_slots:
            if group[0] == index:
                g_case = group[1]
                break
        return g_case

    def expand(self, m):
        """Using the template, expand the string."""

        if m is None:
            raise ValueError("Match is None!")

        sep = m.re.pattern[:0]
        if isinstance(sep, bytes) != self._bytes:
            raise TypeError('Match string type does not match expander string type!')
        text = []
        # Expand string
        for index in range(0, len(self.literals)):
            l = self.literals[index]
            if l is None:
                g_index = self._get_group_index(index)
                span_case, single_case, capture = self._get_group_attributes(index)
                if not self.use_format:
                    # Non format replace
                    try:
                        l = m.group(g_index)
                        if l is None:
                            l = sep
                    except IndexError:  # pragma: no cover
                        raise IndexError("'{}' is out of range!".format(g_index))
                else:
                    # String format replace
                    try:
                        obj = m.captures(g_index)
                    except IndexError:  # pragma: no cover
                        raise IndexError("'{}' is out of range!".format(g_index))
                    l = _util.format_captures(
                        obj,
                        capture,
                        _util._to_bstr if isinstance(sep, bytes) else _util._to_str,
                        sep
                    )
                if span_case is not None:
                    if span_case == _LOWER:
                        l = l.lower()
                    else:
                        l = l.upper()
                if single_case is not None:
                    if single_case == _LOWER:
                        l = l[0:1].lower() + l[1:]
                    else:
                        l = l[0:1].upper() + l[1:]
            text.append(l)

        return sep.join(text)


def _pickle(r):
    """Pickle."""

    return ReplaceTemplate, (r.groups, r.group_slots, r.literals, r.pattern_hash, r.use_format, r._bytes)


_copyreg.pickle(ReplaceTemplate, _pickle)
