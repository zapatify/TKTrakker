# Quick Start Guide

Get your TK Tracker bot running in 5 minutes!

## Prerequisites
- Ruby 3.3+ installed
- A Discord account

## Steps

### 1. Install Dependencies
```bash
gem install discordrb dotenv
```

### 2. Create Your Bot on Discord
1. Visit https://discord.com/developers/applications
2. Click "New Application" → name it "TK Tracker"
3. Go to "Bot" → "Add Bot"
4. Copy your bot token (Reset Token button)
5. Enable "MESSAGE CONTENT INTENT" under Privileged Gateway Intents
6. Save changes

### 3. Invite Bot to Your Server
1. Go to "OAuth2" → "URL Generator"
2. Select scope: `bot`
3. Select permissions: `Send Messages`, `Read Messages/View Channels`, `Read Message History`
4. Copy the URL and open it in your browser
5. Select your server and authorize

### 4. Configure the Bot
```bash
# Copy the example file
cp .env.example .env

# Edit .env and add your token
# DISCORD_BOT_TOKEN=paste_your_token_here
```

### 5. Run the Bot
```bash
ruby tk_tracker_bot.rb
```

### 6. Test It!
In Discord, type:
```
!tkhelp
```

## Basic Commands

- `!addtk @user` - Add a TK (admin only)
- `!showtotals` - View leaderboard (everyone)
- `!tkhelp` - Show all commands

## Troubleshooting

**Bot doesn't respond?**
- Make sure MESSAGE CONTENT INTENT is enabled in Developer Portal
- Restart the bot after enabling intents

**Permission denied?**
- Make sure you have an "Admin", "Moderator", or "TK Manager" role
- Or have Discord Administrator permission

**SSL errors on Mac?**
- The bot handles this automatically
- If issues persist, see the full README

## Need More Help?

See the full [README.md](README.md) for detailed instructions, deployment options, and troubleshooting.
