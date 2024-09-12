#!/bin/bash

chmod 755 relnote.sh
cp relnote.sh /usr/bin/relnote
if [ ! -d /usr/share/relnote ]; then
  mkdir -p /usr/share/relnote;
fi
cp note.js /usr/share/relnote/note.js
