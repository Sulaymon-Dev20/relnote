#!/bin/bash

# Print logo with emoji
echo "🚀 Starting RELNOTE installation..."

# Set permissions for relnote.sh
echo "🔧 Setting executable permissions for relnote.sh..."
if chmod 755 relnote.sh; then
  echo "✅ Permissions set successfully."
else
  echo "❌ Failed to set permissions for relnote.sh. Please check if the file exists and try again."
  exit 1
fi

# Copy relnote.sh to /usr/bin/
echo "📁 Copying relnote.sh to /usr/bin/relnote..."
if cp relnote.sh /usr/bin/relnote; then
  echo "✅ File copied successfully."
else
  echo "❌ Failed to copy relnote.sh. Please check your permissions and try again."
  exit 1
fi

# Create the /usr/share/relnote directory if it doesn't exist
if [ ! -d /usr/share/relnote ]; then
  echo "📂 Creating directory /usr/share/relnote..."
  if mkdir -p /usr/share/relnote; then
    echo "✅ Directory created."
  else
    echo "❌ Failed to create directory /usr/share/relnote. Please check your permissions and try again."
    exit 1
  fi
else
  echo "📂 /usr/share/relnote already exists."
fi

# Copy note.js to /usr/share/relnote/
echo "📄 Copying note.js to /usr/share/relnote/..."
if cp note.js /usr/share/relnote/note.js; then
  echo "✅ note.js copied successfully."
else
  echo "❌ Failed to copy note.js. Please check your file and permissions."
  exit 1
fi

# Copy relnote.1 to /usr/share/man/man1/
echo "📘 Copying relnote.1 to /usr/share/man/man1/..."
if cp relnote.1 /usr/share/man/man1/; then
  echo "✅ Man page copied successfully."
else
  echo "❌ Failed to copy relnote.1. Please check your file and permissions."
  exit 1
fi

# Completion message
echo "🎉 Installation completed successfully!"
