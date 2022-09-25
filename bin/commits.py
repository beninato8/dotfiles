#!/usr/local/bin/python3

import requests
from datetime import datetime
from bs4 import BeautifulSoup as bs4
try:
    txt = requests.get('https://github.com/beninato8').text
    d = datetime.now().strftime('%Y-%m-%d')
    # print(bs4(txt, 'html.parser').find('rect'))
    b = bs4(txt, 'html.parser').find('rect', {'class':'ContributionCalendar-day', 'data-date':d})['data-count']
    print(b)
except Exception as e:
    pass