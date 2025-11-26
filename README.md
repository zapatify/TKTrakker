![Ruby Version](https://img.shields.io/badge/ruby-3.3%2B-red)
![License](https://img.shields.io/badge/license-MIT-blue)
![GitHub release](https://img.shields.io/github/v/release/yourusername/discord-tk-tracker)# Discord Team Kill Tracker Bot

A Discord bot that tracks team kills in online games. Admins can add/subtract TKs, and anyone can view the leaderboard.

**🚀 [Quick Start Guide](QUICKSTART.md)** - Get up and running in 5 minutes!

## Features

- 📊 Track team kills for server members
- 👑 Admin-only commands to add/subtract TKs
- 🏆 Public leaderboard sorted by most TKs
- 🔄 Reset functionality with safety confirmation
- 💾 Persistent storage (data survives bot restarts)
- 🎯 Role-based permissions

## Commands

### Everyone Can Use:
- `!showtotals` - Display the team kill leaderboard
- `!tkhelp` - Show help message with all commands

### Admin Commands:
- `!addtk @user` - Add a team kill to a user
- `!subtk @user` - Subtract a team kill from a user (for corrections)
- `!resettks` - Reset all team kill data (requires confirmation)
- `!confirmreset` - Confirm the reset (must be used within 30 seconds)

## Who Can Use Admin Commands?

Users with any of the following:
- Discord Administrator permission
- "Admin" role
- "Moderator" role (or "mod")
- "TK Manager" role

## Prerequisites

- Ruby 3.3 or higher
- A Discord account
- A Discord server where you have admin permissions

## Setup Instructions

### 1. Install Ruby

**macOS:**
```bash
brew install ruby
```

**Ubuntu/Linux:**
```bash
sudo apt-get update
sudo apt-get install ruby-full
```

**Windows:**
Download from https://rubyinstaller.org/

### 2. Clone or Download This Repository

```bash
git clone https://github.com/yourusername/discord-tk-tracker.git
cd discord-tk-tracker
```

### 3. Install Dependencies

```bash
gem install bundler
bundle install
```

Or install gems individually:
```bash
gem install discordrb dotenv
```

### 4. Create a Discord Bot Application

1. Go to https://discord.com/developers/applications
2. Click "New Application" and give it a name (e.g., "TK Tracker")
3. Go to the "Bot" section in the left sidebar
4. Click "Add Bot"
5. Under the bot's token section, click "Reset Token" and **copy the token** (keep it secret!)
6. Scroll down to "Privileged Gateway Intents" and enable:
   - ✅ **MESSAGE CONTENT INTENT**
7. Click "Save Changes"

### 5. Configure Environment Variables

1. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```

2. Edit `.env` and add your bot token:
   ```
   DISCORD_BOT_TOKEN=your_bot_token_here
   ```

### 6. Invite the Bot to Your Server

1. In the Discord Developer Portal, go to "OAuth2" → "URL Generator"
2. Under "Scopes", select:
   - ✅ **bot**
3. Under "Bot Permissions", select:
   - ✅ **Send Messages**
   - ✅ **Read Messages/View Channels**
   - ✅ **Read Message History**
   - ✅ **Mention Everyone** (for @mentions in responses)
4. Copy the generated URL at the bottom
5. Paste it in your browser and select your server
6. Click "Authorize"

### 7. Run the Bot

```bash
ruby tk_tracker_bot.rb
```

You should see:
```
Logged in as YourBotName
Bot is ready and tracking team kills!
```

The bot is now online! Try typing `!tkhelp` in your Discord server.

## Deployment Options

### Run on Your Computer

Just run `ruby tk_tracker_bot.rb` - the bot will stay online as long as the script is running.

### Deploy to a Server (24/7 Hosting)

#### Option 1: Railway (Free Tier Available)

1. Create a `Procfile`:
   ```
   worker: ruby tk_tracker_bot.rb
   ```

2. Create a `Gemfile`:
   ```ruby
   source 'https://rubygems.org'
   
   gem 'discordrb'
   gem 'dotenv'
   ```

3. Push to GitHub
4. Sign up at https://railway.app
5. Create new project from GitHub repo
6. Add environment variable: `DISCORD_BOT_TOKEN`
7. Deploy!

#### Option 2: Heroku

1. Create a `Procfile`:
   ```
   worker: ruby tk_tracker_bot.rb
   ```

2. Create a `Gemfile` (same as above)

3. Deploy:
   ```bash
   heroku create your-bot-name
   heroku config:set DISCORD_BOT_TOKEN=your_token_here
   git push heroku main
   heroku ps:scale worker=1
   ```

#### Option 3: Linux VPS (DigitalOcean, Linode, etc.)

1. SSH into your server
2. Install Ruby
3. Clone your repository
4. Install gems: `bundle install`
5. Run with screen or tmux:
   ```bash
   screen -S tkbot
   ruby tk_tracker_bot.rb
   # Press Ctrl+A then D to detach
   ```

Or set up as a systemd service for automatic restart.

#### Option 4: Docker

Create a `Dockerfile`:
```dockerfile
FROM ruby:3.3

RUN apt-get update && apt-get install -y ca-certificates && update-ca-certificates

WORKDIR /app

COPY Gemfile* ./
RUN bundle install

COPY . .

CMD ["ruby", "tk_tracker_bot.rb"]
```

Build and run:
```bash
docker build -t tk-tracker-bot .
docker run -e DISCORD_BOT_TOKEN=your_token_here tk-tracker-bot
```

## Data Storage

Team kill data is stored in `tk_data.json` in the same directory as the bot. This file is automatically created and updated.

**Important:** 
- Don't delete this file or you'll lose all TK data
- Make sure to back it up if deploying to a server
- Add it to `.gitignore` (already included) to keep data local

## Customization

### Change Admin Roles

Edit the `is_admin?` function in `tk_tracker_bot.rb`:

```ruby
admin_role_names = ['Admin', 'Moderator', 'YourCustomRole']
```

### Change Command Prefixes

Replace `!` with your preferred prefix throughout the code:

```ruby
bot.message(start_with: '?addtk') do |event|
```

### Add More Commands

Follow the existing command patterns in the code. Each command is a `bot.message` block.

## Troubleshooting

### Bot doesn't respond to commands

1. Make sure MESSAGE CONTENT INTENT is enabled in Discord Developer Portal
2. Check that the bot has "Send Messages" permission in your server
3. Verify the bot is online (should show green status)
4. Check the console for error messages

### SSL Certificate Errors (macOS)

If you see SSL errors on macOS, the code includes a fix that automatically uses Homebrew's certificates.

### Permission Errors

Make sure users have the correct roles or Administrator permission in Discord.

### Bot goes offline

The bot only runs while the script is running. For 24/7 uptime, deploy to a hosting service (see Deployment Options).

## Contributing

Feel free to submit issues and pull requests!

## License

MIT License - feel free to use and modify as needed.

## Support

For questions or issues, please open an issue on GitHub.

## Acknowledgments

Built with [discordrb](https://github.com/shardlab/discordrb) - a Ruby Discord API library.