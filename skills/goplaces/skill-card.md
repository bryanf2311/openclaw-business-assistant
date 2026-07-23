## Description: <br>
Query Google Places API (New) via the goplaces CLI for text search, place details, resolve, and reviews. Use for human-friendly place lookup or JSON output for scripts. <br>

This skill is ready for commercial/non-commercial use. <br>

## Publisher: <br>
[steipete](https://clawhub.ai/user/steipete) <br>

### License/Terms of Use: <br>


## Use Case: <br>
Developers and agents use this skill to look up Google Places data with the goplaces CLI, including text search, place details, resolving place names, reviews, and script-friendly JSON output. <br>

### Deployment Geography for Use: <br>
Global <br>

## Known Risks and Mitigations: <br>
Risk: The skill depends on a Google Places API key, which can expose credentials or incur cost if mishandled. <br>
Mitigation: Use a restricted Google Places API key with quota or billing limits, and avoid exposing the key in prompts or logs. <br>
Risk: Installing goplaces from a third-party Homebrew tap requires trust in that tap and project. <br>
Mitigation: Install only after verifying that the Homebrew tap and goplaces project are trusted for the deployment environment. <br>
Risk: GOOGLE_PLACES_BASE_URL can redirect API traffic to an unintended endpoint if set incorrectly. <br>
Mitigation: Leave GOOGLE_PLACES_BASE_URL unset unless intentionally using a trusted proxy or test endpoint. <br>


## Reference(s): <br>
- [Goplaces project homepage](https://github.com/steipete/goplaces) <br>
- [ClawHub skill page](https://clawhub.ai/steipete/skills/goplaces) <br>


## Skill Output: <br>
**Output Type(s):** [Text, Shell commands, Configuration, Guidance] <br>
**Output Format:** [Markdown with inline shell commands and optional JSON CLI output] <br>
**Output Parameters:** [1D] <br>
**Other Properties Related to Output:** [Requires the goplaces binary and GOOGLE_PLACES_API_KEY.] <br>

## Skill Version(s): <br>
1.0.0 (source: server release metadata) <br>

## Ethical Considerations: <br>
Users should evaluate whether this skill is appropriate for their environment, review any generated or modified files before relying on them, and apply their organization's safety, security, and compliance requirements before deployment. <br>
