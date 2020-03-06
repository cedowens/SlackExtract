# SlackExtract

Swift code to automate the steps to extract Slack data available on a macOS host. This leverages the research by Cody Thomas at: https://posts.specterops.io/abusing-slack-for-offensive-operations-2343237b9282

Steps:
1. You can edit the main.swift code as needed -OR- you can simply download and run the SlackExtract swift binary
2. The binary is not signed so you will need to clear the quarantine flag on it (xattr -c SlackExtract)
3. Run from the terminal ($ ./SlackExtract)

This binary will read from the following files:

~/Library/Application Support/Slack/storage/slack-teams
~/Library/Application Support/Slack/storage/slack-downloads
~/Library/Application Support/Slack/Cookies

As noted in Cody Thomas' post, you can copy the three files above and put them on a new host with a newly installed (and never logged into) Slack instance and start Slack there and you will be logged in.
