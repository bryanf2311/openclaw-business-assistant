## Description: <br>
This skill helps agents use the Netlify CLI to create or link Netlify sites, configure CI/CD from GitHub, and manage monorepo deployment settings. <br>

This skill is ready for commercial/non-commercial use. <br>

## Publisher: <br>
[ajmwagar](https://clawhub.ai/user/ajmwagar) <br>

### License/Terms of Use: <br>


## Use Case: <br>
Developers and site operators use this skill to have an agent prepare Netlify deployment workflows, especially for Hugo or monorepo sites, by generating configuration and proposing or running Netlify CLI commands. <br>

### Deployment Geography for Use: <br>
Global <br>

## Known Risks and Mitigations: <br>
Risk: The skill can guide an agent through Netlify actions that create or link sites, connect GitHub CI/CD, or deploy to production. <br>
Mitigation: Confirm the target folder, Netlify team or account, site name, repository, build settings, environment variables, and production deploy intent before running commands. <br>
Risk: Netlify credentials or environment variables could grant broad account access or expose secrets. <br>
Mitigation: Use a scoped, revocable Netlify token and avoid writing secrets into generated files, command history, or shared logs. <br>
Risk: Generated Netlify configuration may point CI/CD at the wrong base directory, build command, or publish directory. <br>
Mitigation: Review netlify.toml and Netlify site settings before committing changes or enabling continuous deployment. <br>


## Reference(s): <br>
- [ClawHub skill page](https://clawhub.ai/ajmwagar/skills/netlify) <br>


## Skill Output: <br>
**Output Type(s):** [guidance, shell commands, configuration] <br>
**Output Format:** [Markdown guidance with bash and TOML snippets] <br>
**Output Parameters:** [1D] <br>
**Other Properties Related to Output:** [May create netlify.toml and run Netlify CLI commands when the agent executes the provided workflow.] <br>

## Skill Version(s): <br>
1.0.0 (source: server release metadata) <br>

## Ethical Considerations: <br>
Users should evaluate whether this skill is appropriate for their environment, review any generated or modified files before relying on them, and apply their organization's safety, security, and compliance requirements before deployment. <br>
