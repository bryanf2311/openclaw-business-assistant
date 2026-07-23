## Description: <br>
Manage tasks and projects in Todoist. Use when user asks about tasks, to-dos, reminders, or productivity. <br>

This skill is ready for commercial/non-commercial use. <br>

## Publisher: <br>
[mjrussell](https://clawhub.ai/user/mjrussell) <br>

### License/Terms of Use: <br>


## Use Case: <br>
People who manage work in Todoist use this skill to let an agent list, search, create, update, complete, reopen, move, and delete Todoist tasks and manage related projects, labels, and comments. <br>

### Deployment Geography for Use: <br>
Global <br>

## Known Risks and Mitigations: <br>
Risk: The skill can read and change Todoist tasks when configured with a Todoist API token. <br>
Mitigation: Install it only for agents that should use the connected Todoist account, use a revocable token, and confirm delete, move, complete, reopen, or other state-changing actions when a request is ambiguous. <br>
Risk: The workflow depends on the globally installed todoist-ts-cli package. <br>
Mitigation: Review and trust the todoist-ts-cli package before installing or updating it globally. <br>


## Reference(s): <br>
- [Todoist](https://todoist.com) <br>
- [Todoist Developer Integrations Settings](https://todoist.com/app/settings/integrations/developer) <br>


## Skill Output: <br>
**Output Type(s):** [Text, Shell commands, Configuration, Guidance] <br>
**Output Format:** [Markdown with inline shell commands] <br>
**Output Parameters:** [1D] <br>
**Other Properties Related to Output:** [Requires the todoist CLI and TODOIST_API_TOKEN for authenticated Todoist account access.] <br>

## Skill Version(s): <br>
0.2.1 (source: server release metadata) <br>

## Ethical Considerations: <br>
Users should evaluate whether this skill is appropriate for their environment, review any generated or modified files before relying on them, and apply their organization's safety, security, and compliance requirements before deployment. <br>
