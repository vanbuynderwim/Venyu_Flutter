#!/usr/bin/env python3
import os
import re

def find_unsafe_setstate(directory):
    """Find setState calls in catch blocks without mounted checks."""
    unsafe_files = []

    for root, dirs, files in os.walk(directory):
        for file in files:
            if not file.endswith('.dart'):
                continue

            filepath = os.path.join(root, file)
            try:
                with open(filepath, 'r', encoding='utf-8') as f:
                    content = f.read()

                # Find all catch blocks with setState but no mounted check before setState
                pattern = r'}\s*catch\s*\([^)]+\)\s*{([^}]*?setState[^}]*?)}'
                matches = re.finditer(pattern, content, re.DOTALL)

                for match in matches:
                    catch_block = match.group(1)
                    # Check if there's setState without "if (mounted)" or "safeSetState" before it
                    if 'setState(' in catch_block:
                        # Split by setState and check each occurrence
                        parts = catch_block.split('setState(')
                        for i, part in enumerate(parts[1:], 1):  # Skip first part (before any setState)
                            # Check previous 100 chars before this setState
                            prev_context = parts[i-1][-100:] if i > 0 else ""
                            if 'if (mounted)' not in prev_context and 'safeSetState' not in catch_block:
                                unsafe_files.append((filepath, match.group(0)[:200]))
                                break
            except Exception as e:
                print(f"Error reading {filepath}: {e}")

    return unsafe_files

# Search in lib directory
unsafe = find_unsafe_setstate('lib')

print(f"\nFound {len(unsafe)} files with potentially unsafe setState in catch blocks:\n")
for filepath, snippet in unsafe:
    print(f"❌ {filepath}")
    print(f"   {snippet[:150]}...\n")
