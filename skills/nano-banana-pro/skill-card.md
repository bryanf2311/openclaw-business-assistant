## Description: <br>
Nano Banana Pro generates and edits images with Gemini 3 Pro Image, supporting text-to-image and image-to-image workflows at 1K, 2K, and 4K resolutions. <br>

This skill is ready for commercial/non-commercial use. <br>

## Publisher: <br>
[steipete](https://clawhub.ai/user/steipete) <br>

### License/Terms of Use: <br>


## Use Case: <br>
External users and developers use this skill to create new images or edit existing local images by prompting Google's Gemini image API from an agent workflow. <br>

### Deployment Geography for Use: <br>
Global <br>

## Known Risks and Mitigations: <br>
Risk: Image prompts and optional input images are sent to Google's Gemini service for external processing. <br>
Mitigation: Use the skill only when that external processing is acceptable, and avoid confidential screenshots, credentials, medical, legal, or other sensitive images. <br>
Risk: Providing a Gemini API key directly in chat or shell commands can expose it in conversation or command history. <br>
Mitigation: Prefer the GEMINI_API_KEY environment variable and avoid pasting API keys into chat or reusable command history. <br>
Risk: The script writes the generated PNG to the requested filename and may replace an existing file at that path. <br>
Mitigation: Use timestamped filenames or confirm the target path before execution, then review the saved image before relying on it. <br>


## Reference(s): <br>


## Skill Output: <br>
**Output Type(s):** [Guidance, Shell commands, Files] <br>
**Output Format:** [PNG image file with plain-text status output and saved-path confirmation] <br>
**Output Parameters:** [1D] <br>
**Other Properties Related to Output:** [Uses a text prompt, output filename, optional input image, optional resolution, and Gemini API key.] <br>

## Skill Version(s): <br>
1.0.1 (source: server release metadata) <br>

## Ethical Considerations: <br>
Users should evaluate whether this skill is appropriate for their environment, review any generated or modified files before relying on them, and apply their organization's safety, security, and compliance requirements before deployment. <br>
