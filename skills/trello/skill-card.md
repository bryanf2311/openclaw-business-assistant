## Description: <br>
Manage Trello boards, lists, and cards via the Trello REST API. <br>

This skill is ready for commercial/non-commercial use. <br>

## Publisher: <br>
[steipete](https://clawhub.ai/user/steipete) <br>

### License/Terms of Use: <br>


## Use Case: <br>
Developers and Trello users use this skill to inspect boards, lists, and cards, then create, move, comment on, or archive cards through Trello API commands. <br>

### Deployment Geography for Use: <br>
Global <br>

## Known Risks and Mitigations: <br>
Risk: The Trello token can grant powerful account access if exposed or misused. <br>
Mitigation: Keep the token secret, provide it only through environment variables, and revoke it when the skill is no longer needed. <br>
Risk: POST and PUT commands can create, move, comment on, or archive Trello cards. <br>
Mitigation: Review board, list, and card IDs before running write commands. <br>


## Reference(s): <br>
- [Trello REST API documentation](https://developer.atlassian.com/cloud/trello/rest/) <br>
- [Trello API key page](https://trello.com/app-key) <br>
- [ClawHub skill page](https://clawhub.ai/steipete/skills/trello) <br>
- [ClawHub publisher profile](https://clawhub.ai/user/steipete) <br>


## Skill Output: <br>
**Output Type(s):** [Shell commands, Configuration, Guidance] <br>
**Output Format:** [Markdown with inline bash code blocks] <br>
**Output Parameters:** [1D] <br>
**Other Properties Related to Output:** [Requires jq plus TRELLO_API_KEY and TRELLO_TOKEN environment variables.] <br>

## Skill Version(s): <br>
1.0.0 (source: server release metadata) <br>

## Ethical Considerations: <br>
Users should evaluate whether this skill is appropriate for their environment, review any generated or modified files before relying on them, and apply their organization's safety, security, and compliance requirements before deployment. <br>
