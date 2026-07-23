## Description: <br>
Fetch and read transcripts from YouTube videos. Use when you need to summarize a video, answer questions about its content, or extract information from it. <br>

This skill is ready for commercial/non-commercial use. <br>

## Publisher: <br>
[michaelgathara](https://clawhub.ai/user/michaelgathara) <br>

### License/Terms of Use: <br>


## Use Case: <br>
Developers, employees, and external users use this skill to retrieve YouTube video transcripts so an agent can summarize the video, answer questions about its content, or extract specific information. <br>

### Deployment Geography for Use: <br>
Global <br>

## Known Risks and Mitigations: <br>
Risk: The skill runs yt-dlp locally and contacts video URLs provided for transcript retrieval. <br>
Mitigation: Install yt-dlp from trusted package sources and use trusted YouTube URLs. <br>
Risk: Fetched transcript text is third-party content and may be inaccurate, misleading, or unsafe to rely on without review. <br>
Mitigation: Treat transcripts as untrusted input and verify important claims against the original video or other reliable sources. <br>
Risk: Transcript retrieval fails when a video has no closed captions or auto-generated subtitles. <br>
Mitigation: Confirm that the source video has available subtitles before depending on the skill for content extraction. <br>


## Reference(s): <br>
- [YouTube Watcher on ClawHub](https://clawhub.ai/michaelgathara/skills/youtube-watcher) <br>
- [michaelgathara publisher profile](https://clawhub.ai/user/michaelgathara) <br>


## Skill Output: <br>
**Output Type(s):** [Text, Markdown, Shell commands, Guidance] <br>
**Output Format:** [Plain text transcript output with Markdown guidance for summarization, question answering, or information extraction.] <br>
**Output Parameters:** [1D] <br>
**Other Properties Related to Output:** [Requires yt-dlp and works only when the requested YouTube video has closed captions or auto-generated subtitles.] <br>

## Skill Version(s): <br>
1.0.0 (source: frontmatter and server release evidence) <br>

## Ethical Considerations: <br>
Users should evaluate whether this skill is appropriate for their environment, review any generated or modified files before relying on them, and apply their organization's safety, security, and compliance requirements before deployment. <br>
