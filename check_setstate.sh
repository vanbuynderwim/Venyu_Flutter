#!/bin/bash

# Find all Dart files in views directory
find lib/views -name "*.dart" | while IFS= read -r file; do
  # Check if file has catch blocks with setState but no mounted check
  if grep -Pzo '} catch[^}]*\{(?:(?!if \(mounted\)).){0,200}setState' "$file" 2>/dev/null | grep -q setState; then
    echo "❌ $file"
    grep -A 8 "} catch" "$file" | grep -B 3 -A 3 "setState" | head -20
    echo "---"
  fi
done
