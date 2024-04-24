#!/usr/bin/env fish

# Parse arguments
argparse 'h/help' 'p/pipeline=' -- $argv

# Help
if set -q _flag_help
  echo "Usage: $argv0 [-h|--help] [-p|--pipeline]"
  return
end

if set -q _flag_pipeline
  set PIPELINE $_flag_pipeline
else
  set PIPELINE $argv[1]
end

echo $PIPELINE

set STATE (sem get pipelines $PIPELINE | yq e '.pipeline.state')
while test $STATE = "running"
  sleep 120  # Wait for 2 minutes
  set STATE (sem get pipelines $PIPELINE | yq e '.pipeline.state')
end

set RESULT (sem get pipelines $PIPELINE | yq e '.pipeline.result')
lmk -t "Build Status" -m "Build finished: $RESULT" 
