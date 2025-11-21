require 'dotenv/load'
require 'discordrb'
require 'openssl'


# Only set custom cert path on macOS development
if RUBY_PLATFORM.include?('darwin') && File.exist?('/opt/homebrew/etc/ca-certificates/cert.pem')
  OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:ca_file] = '/opt/homebrew/etc/ca-certificates/cert.pem'
end

bot = Discordrb::Bot.new(
  token: ENV['DISCORD_BOT_TOKEN'],
  intents: [:server_messages, :direct_messages]
)

# Log all messages to see if bot can read them
bot.message do |event|
  puts "Received message: '#{event.content}' from #{event.user.name}"
end

bot.message(content: '!ping') do |event|
  puts "Ping command triggered!"
  event.respond 'Pong!'
end

bot.message(start_with: '!hello') do |event|
  puts "Hello command triggered!"
  event.respond "Hello, #{event.user.name}!"
end

bot.ready do |event|
  puts "Logged in as #{bot.profile.name}"
  puts "Bot is ready and listening!"
end

bot.run