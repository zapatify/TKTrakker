#!/usr/bin/env ruby
# Discord Team Kill Tracker Bot
# Tracks team kills for online games with admin controls and leaderboards

require 'dotenv/load'  # Load environment variables from .env file
require 'discordrb'    # Discord API library
require 'openssl'      # SSL support
require 'json'         # JSON parsing for data storage

# Only set custom cert path on macOS development
# This fixes SSL certificate issues with OpenSSL 3.x on macOS
if RUBY_PLATFORM.include?('darwin') && File.exist?('/opt/homebrew/etc/ca-certificates/cert.pem')
  OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:ca_file] = '/opt/homebrew/etc/ca-certificates/cert.pem'
end

# Data storage file - stores TK counts persistently
DATA_FILE = 'tk_data.json'

# Load TK data from JSON file
# Returns: Hash with user_id as key, containing username and tk count
def load_data
  if File.exist?(DATA_FILE)
    JSON.parse(File.read(DATA_FILE))
  else
    {}
  end
end

# Save TK data to JSON file
# Params: data - Hash of user data to save
def save_data(data)
  File.write(DATA_FILE, JSON.pretty_generate(data))
end

# Check if user has permission to use admin commands
# Params: event - Discord message event
# Returns: Boolean - true if user is admin
def is_admin?(event)
  # Get the member object for the user in this server
  member = event.server.member(event.user.id)
  
  # Check if they have administrator permission
  return true if member.permission?(:administrator)
  
  # Check if they have specific admin/moderator roles
  # You can customize this list to match your server's role names
  admin_role_names = ['Admin', 'Moderator', 'admin', 'moderator', 'mod', 'Mod', 'TK Manager']
  member.roles.any? { |role| admin_role_names.include?(role.name) }
end

# Initialize Discord bot with token from environment variable
bot = Discordrb::Bot.new(
  token: ENV['DISCORD_BOT_TOKEN'],
  intents: [:server_messages, :direct_messages]  # Required intents for reading messages
)

# ============================================
# ADMIN COMMANDS
# ============================================

# Add TK command (admin only)
# Usage: !addtk @username
bot.message(start_with: '!addtk') do |event|
  unless is_admin?(event)
    event.respond "❌ Only admins can add team kills."
    next
  end

  # Get mentioned user
  if event.message.mentions.empty?
    event.respond "❌ Please mention a user: `!addtk @username`"
    next
  end

  user = event.message.mentions.first
  user_id = user.id.to_s

  # Load data
  data = load_data
  data[user_id] ||= { 'username' => user.name, 'tks' => 0 }
  data[user_id]['tks'] += 1
  data[user_id]['username'] = user.name # Update username in case it changed
  
  save_data(data)

  total = data[user_id]['tks']
  event.respond "✅ One kill added to #{user.mention}'s total. #{user.mention} now has **#{total} TK#{total == 1 ? '' : 's'}**."
end

# Subtract TK command (admin only)
# Usage: !subtk @username
bot.message(start_with: '!subtk') do |event|
  unless is_admin?(event)
    event.respond "❌ Only admins can subtract team kills."
    next
  end

  # Get mentioned user
  if event.message.mentions.empty?
    event.respond "❌ Please mention a user: `!subtk @username`"
    next
  end

  user = event.message.mentions.first
  user_id = user.id.to_s

  # Load data
  data = load_data
  
  unless data[user_id]
    event.respond "❌ #{user.mention} has no team kills recorded."
    next
  end

  if data[user_id]['tks'] > 0
    data[user_id]['tks'] -= 1
    save_data(data)
    total = data[user_id]['tks']
    event.respond "✅ One kill subtracted from #{user.mention}'s total. #{user.mention} now has **#{total} TK#{total == 1 ? '' : 's'}**."
  else
    event.respond "❌ #{user.mention} already has 0 team kills."
  end
end

# ============================================
# PUBLIC COMMANDS
# ============================================

# Show totals command (everyone can use)
# Usage: !showtotals
bot.message(content: '!showtotals') do |event|
  data = load_data

  if data.empty?
    event.respond "📊 No team kills recorded yet!"
    next
  end

  # Sort by TKs (highest to lowest)
  sorted = data.sort_by { |_id, info| -info['tks'] }

  # Build message
  message = "📊 **Team Kill Leaderboard**\n\n"
  sorted.each do |user_id, info|
    tks = info['tks']
    next if tks == 0 # Skip users with 0 TKs
    
    username = info['username']
    message += "• **#{username}** has **#{tks} TK#{tks == 1 ? '' : 's'}**\n"
  end

  if message == "📊 **Team Kill Leaderboard**\n\n"
    event.respond "📊 No team kills recorded yet!"
  else
    event.respond message
  end
end

# ============================================
# RESET FUNCTIONALITY
# ============================================

# Store pending resets (to handle confirmation)
# Maps user_id to timestamp of reset request
$pending_resets = {}

# Reset TKs command (admin only, with confirmation)
# Usage: !resettks
bot.message(content: '!resettks') do |event|
  unless is_admin?(event)
    event.respond "❌ Only admins can reset team kills."
    next
  end

  # Mark as pending reset
  $pending_resets[event.user.id] = Time.now

  event.respond "⚠️ **WARNING:** This will delete ALL team kill data and start fresh.\nType `!confirmreset` within 30 seconds to confirm, or ignore this message to cancel."
end

# Confirm reset command
# Usage: !confirmreset (must be used within 30 seconds of !resettks)
bot.message(content: '!confirmreset') do |event|
  unless is_admin?(event)
    next
  end

  # Check if there's a pending reset
  if $pending_resets[event.user.id]
    # Check if it's within 30 seconds
    if Time.now - $pending_resets[event.user.id] <= 30
      # Perform reset
      save_data({})
      $pending_resets.delete(event.user.id)
      event.respond "✅ All team kill data has been reset. Starting fresh!"
    else
      $pending_resets.delete(event.user.id)
      event.respond "❌ Reset confirmation timed out. Please use `!resettks` again if you want to reset."
    end
  else
    event.respond "❌ No pending reset. Use `!resettks` first."
  end
end

# ============================================
# HELP COMMAND
# ============================================

# Help command - displays all available commands
# Usage: !tkhelp
bot.message(content: '!tkhelp') do |event|
  help_message = <<~HELP
    🎮 **Team Kill Tracker Bot - Commands**
    
    **Everyone:**
    • `!showtotals` - Display the team kill leaderboard
    • `!tkhelp` - Show this help message
    
    **Admins Only:**
    • `!addtk @user` - Add a team kill to a user
    • `!subtk @user` - Subtract a team kill from a user (for corrections)
    • `!resettks` - Reset all team kill data (requires confirmation)
  HELP
  
  event.respond help_message
end

# ============================================
# BOT STARTUP
# ============================================

# Bot ready event - fires when bot successfully connects to Discord
bot.ready do |event|
  puts "Logged in as #{bot.profile.name}"
  puts "Bot is ready and tracking team kills!"
end

# Start the bot (this blocks until bot is stopped)
bot.run