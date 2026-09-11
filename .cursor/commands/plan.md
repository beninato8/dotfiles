# Plan

This command is used to develop, audit, or iterate on a plan for a given task. There are a few key principles to follow when developing a plan.
- Precise Context
- Best Practices
- No Ambiguity
- Asking for Clarification

## Precise Context

The plan itself should contain sufficient context to be implemented. This means that a user or agent could be given the plan, with no additional context like prior chat messages, logs, error messages, tickets, or architectural decisions, and be able to implement the plan. Once a user is given a plan and told to implement, they should be able to build and test without needing to do additional research.

The plan should not contain instructions like "go to developer.example.com and research the documentation". Instead, you should do the research yourself while creating the plan, and only include the information that is necessary to implement the plan.

However, we should not be overly broad with the context. Extraneous information should be omitted to avoid polluting the plan with unnecessary details.

## Best Practices

When writing a plan, our implementation should follow best practices. This means that architectural decisions should be designed to follow industry best practices. We always want to aim for long term maintainability and scalability, rather than a short term fix. We should try to find the most elegant, efficient, and simple solution, rather than complexity for the sake of complexity.

Code is read and ran so much more than it is written, so we should always strive to write code that is easy to understand and maintain.

## No Ambiguity

Plans should not be ambiguous. Please make sure that the plan is prescriptive and not vague.

The plan should have steps that are clear and concise, without multiple options or choices.

The following do not belong in the plan:
- Questions for the user
- Notes on alternatives
- Lists of possible options for how to implement a step
- Any statement like "Fix: do x or y"

There should not be an "Optional" section. Either something should be done, or not. If evaluating if something listed as optional should be done, ask the user for clarification. Err on including an optional item, especially if it was already discussed previously.

## Asking for Clarification

If there is anything that is not clear, please ask the user questions to clarify. You are encouraged to ask follow up questions to make sure that we can have the best possible plan for the task at hand.