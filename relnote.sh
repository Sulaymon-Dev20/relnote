#!/bin/bash

# Set default values
HTML_FILE="index.html"
REL_JS="/usr/share/relnote/note.js"  # The JavaScript file path (modify if needed)
API_DATA=""
DEPLOY_TIME=""
WARNING_ACTIVATION=86400000  # Default value set to 1 day in milliseconds
WARNING_DISMISSAL=60000       # Default value set to 60 seconds in milliseconds
VERSION="1.0.0"               # Version of the script
MESSAGE="This website might be instability on \$1, from \$2 to \$3 due to maintenance."

# Function to display usage information
usage() {
  echo -e "📜 Usage: relnote [OPTIONS]"
  echo -e "Options:"
  echo -e "  -f, --file <html_path>         Specify the HTML file path (default is index.html)"
  echo -e "  -j, --js <js_path>             Specify the JS file path (default is note.js)"
  echo -e "  -u, --url <url>                Specify the URL for API data"
  echo -e "  -d, --deploy <date_time>       Specify the deploy time in the format 'Sun Aug 25 12:03:19 CDT 2024'"
  echo -e "  -t, --text <message>           Specify text format '$MESSAGE'"
  echo -e "  -wa, --warning-activation <ms> Set the warning activation time in milliseconds (default is $WARNING_ACTIVATION)"
  echo -e "  -wd, --warning-dismissal <ms>  Set the warning dismissal time in milliseconds (default is $WARNING_DISMISSAL)"
  echo -e "  -v, --version                  Display the version information"
  echo -e "  -h, --help                     Display this help message"
  exit 1
}

# Function to display version information
version() {
  echo -e "🛠️ relnote version $VERSION"
  exit 0
}

# Check if passed date format is valid
validate_date() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    date -j -f "%a %b %d %T %Z %Y" "$1" +%s >/dev/null 2>&1
  else
    date -d "$1" +%s >/dev/null 2>&1
  fi
  return $?  # Return the status of the date command
}

# Parse command line options
while [[ $# -gt 0 ]]; do
  case $1 in
    -f | --file)
      HTML_FILE="$2"
      shift 2
      ;;
    -j | --js)
      REL_JS="$2"
      shift 2
      ;;
    -u | --url)
      if [[ -n "$API_DATA" ]]; then
        echo -e "⚠️ Error: You can only specify one of --url or --deploy."
        usage
      fi
      API_DATA="$2"
      shift 2
      ;;
    -d | --deploy)
      if [[ -n "$DEPLOY_TIME" ]]; then
        echo -e "⚠️ Error: You can only specify one of --url or --deploy."
        usage
      fi
      DEPLOY_TIME="$2"
      shift 2
      ;;
    -t | --text)
      MESSAGE="$2"
      shift 2
      ;;
    -wa | --warning-activation)
      WARNING_ACTIVATION="$2"
      shift 2
      ;;
    -wd | --warning-dismissal)
      WARNING_DISMISSAL="$2"
      shift 2
      ;;
    -v | --version)
      version
      ;;
    -h | --help)
      usage
      ;;
    *)
      echo -e "❌ Unknown option: $1"
      usage
      ;;
  esac
done

# Check if the specified HTML file exists and is a file
if [[ ! -f "$HTML_FILE" ]]; then
  echo -e "❌ Error: '$HTML_FILE' is not a file or does not exist."
  exit 1
fi

# Prepare to handle API Data if URL is provided
if [[ -n "$API_DATA" ]]; then
  RESPONSE=$(curl --write-out "%{http_code}" --silent --output /dev/null "$API_DATA")
  if [[ "$RESPONSE" -ne 200 ]]; then
    echo -e "🔄 Notice: The API '$API_DATA' is not responsive."
    echo -e "💡 Using default values."
    API_DATA=""
  else
    echo -e "🔗 API data will be used from: $API_DATA"
  fi
fi

# Validate deploy time if provided
if [[ -n "$DEPLOY_TIME" ]]; then
  if ! validate_date "$DEPLOY_TIME"; then
    echo -e "❌ Error: Deploy time '$DEPLOY_TIME' is not a valid date format."
    exit 1
  fi
  echo -e "⏳ Deploy time is set to: $DEPLOY_TIME"
fi

# Ensure either API data or deploy time is provided
if [[ -z "$API_DATA" && -z "$DEPLOY_TIME" ]]; then
  echo -e "❌ Error: You must specify either --url or --deploy."
  exit 1
fi

# Create script content to inject into HTML
SCRIPT_CONTENT="<script src='note.js'></script> <script> apiData = '${API_DATA:-""}'; deployDate = '${DEPLOY_TIME:-""}'; warningActivation = $WARNING_ACTIVATION; warningDismissal = $WARNING_DISMISSAL; message = '$MESSAGE'; if (deployDate != null && deployDate.length > 0) { calculateDate(deployDate); } else { getDateByIP(); } </script>"
ESCAPED_JS_CONTENT=$(printf '%s' "$SCRIPT_CONTENT" | sed 's/[&/\]/\\&/g')

# Check if the JavaScript file exists
if [[ ! -f "$REL_JS" ]]; then
  echo -e "❌ Error: The JavaScript file '$REL_JS' does not exist."
  exit 1
fi

# Copy JS file to the same directory as the HTML file
HTML_DIR=$(dirname "$HTML_FILE")
cp "$REL_JS" "$HTML_DIR">/dev/null 2>&1

# Insert scripts before closing </body> tag
if grep -q "</body>" "$HTML_FILE"; then
  sed -i '' "s|</body>|$ESCAPED_JS_CONTENT</body>|g" "$HTML_FILE"
else
  echo -e "❌ Error: No closing </body> tag found in the HTML file."
  exit 1
fi

echo -e "✅ Successfully updated '$HTML_FILE' with note.js and copied the JS file to the HTML directory."
exit 0