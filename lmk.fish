#!/usr/bin/env fish

if not set -q PUSHOVER_TOKEN
  echo "PUSHOVER_TOKEN is not set"
  return
end

if not set -q PUSHOVER_USER
  echo "PUSHOVER_USER is not set"
  return
end

# Parse arguments with argparse for fish
argparse 'h/help' 'm/message=' 't/title=' -- $argv

# help
if set -q _flag_help
  echo "Usage: pushover.fish [-m|--message <message>] [-t|--title <title>]"
  return
end

if set -q _flag_message
  set MESSAGE $_flag_message
else if not isatty stdin
  read MESSAGE
else
  set MESSAGE "Hello! 👋"
end

if set -q _flag_title
  set TITLE $_flag_title
else
  set TITLE "Notification!"
end

curl -s \
  --form-string "token=$PUSHOVER_TOKEN" \
  --form-string "user=$PUSHOVER_USER" \
  --form-string "message=$MESSAGE" \
  --form-string "title=$TITLE" \
  https://api.pushover.net/1/messages.json
