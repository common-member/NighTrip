#!/bin/bash
# Post-edit hook: Auto-run RuboCop autocorrect on edited Ruby files
# Triggered after Edit/Write tool use via .claude/settings.json

INPUT=$(cat)
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

# Only process Ruby files when rubocop is available
if [[ -n "$FILE" && "$FILE" == *.rb && -x ./bin/rubocop ]]; then
  echo "Running RuboCop autocorrect on $FILE..." >&2
  ./bin/rubocop --autocorrect-all "$FILE" 2>/dev/null || true
fi

exit 0
