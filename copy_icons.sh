#!/bin/bash

# Script to copy icons from Swift app to Flutter app
# This script copies the @2x versions of icons from the iOS app to Flutter

SOURCE_DIR="/Users/wimvanbuynder/Projects/Venyu_iOS/Venyu/Venyu/Assets.xcassets"
DEST_DIR="/Users/wimvanbuynder/Projects/Venyu_Flutter/app/assets/icons"

echo "Starting icon copy process..."
echo "Source: $SOURCE_DIR"
echo "Destination: $DEST_DIR"

# Create destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Counter for copied files
count=0

# Find all .imageset directories and copy the @2x images
find "$SOURCE_DIR" -name "*.imageset" -type d | while read -r imageset_dir; do
    # Get the icon name from the directory name
    icon_name=$(basename "$imageset_dir" .imageset)
    
    # Skip the AppIcon as it's handled separately
    if [[ "$icon_name" == "AppIcon" ]]; then
        continue
    fi
    
    # Look for @2x image files in the imageset directory
    for img_file in "$imageset_dir"/*.png; do
        if [[ -f "$img_file" ]]; then
            # Get the filename without path
            filename=$(basename "$img_file")
            
            # If it's a @2x file, copy it without the @2x suffix
            if [[ "$filename" == *"@2x.png" ]]; then
                new_filename="${filename/@2x/}"
                cp "$img_file" "$DEST_DIR/$new_filename"
                echo "Copied: $filename -> $new_filename"
                ((count++))
            # If it's a regular file and no @2x exists, copy it as is
            elif [[ "$filename" == *.png && ! -f "${img_file%.*}@2x.png" ]]; then
                cp "$img_file" "$DEST_DIR/$filename"
                echo "Copied: $filename"
                ((count++))
            fi
        fi
    done
done

echo "Icon copy completed!"
echo "Total files copied: $count"
echo "Icons are now available in: $DEST_DIR"