<div align="center">

<img src="https://github.com/Sulaymon-Dev20/relnote/blob/main/relnote.png?raw=true" width="200" alt='Quran for Android logo'/>

# RELNOTE

[![Build Status](https://github.com/quran/quran_android/actions/workflows/build.yml/badge.svg)](https://github.com/quran/quran_android/actions/workflows/build.yml)
[![Version](https://img.shields.io/github/v/release/Sulaymon-Dev20/relnote?include_prereleases&sort=semver)](https://github.com/quran/quran_android/releases/latest)
[![Github Downloads](https://img.shields.io/github/downloads/Sulaymon-Dev20/relnote/total?logo=Github)](https://github.com/quran/quran_android/releases)

The `relnote` command helps create notifications about release dates by injecting a JavaScript file into an HTML file
and configuring notification settings. It allows you to dynamically set variables and manage notification timings
through command-line options.

</div>

## Features

- **Injects JavaScript**: Embeds a specified JavaScript file into an HTML file.
- **Configurable Variables**: Sets `apiData`, `delayDate`, and timing settings for notifications.
- **API and Delay Options**: Supports both API data URLs and specific release dates.
- **Customizable Timing**: Allows customization of warning activation and dismissal times.

## Installation

1. **Download** the `relnote` script.

   ```bash
   git clone https://github.com/Sulaymon-Dev20/relnote.git 
   ```

2. **Make it executable**:

   ```bash
   chmod +x relnote
   ```

3. **Move it to a directory in your PATH**:
   ```bash
   sudo bash install.sh
   ```

## Usage

<div align="center">

[![HOW TO USE RELNOTE](https://img.youtube.com/vi/YOUTUBE_VIDEO_ID_HERE/0.jpg)](https://www.youtube.com/watch?v=YOUTUBE_VIDEO_ID_HERE)
</div>

```bash 
   relnote [OPTIONS]
   ```

### Options

- **-f, --file <html_path>**
  Specify the HTML file path (default is index.html).

- **-j, --js <js_path>**
  Specify the JavaScript file path (default is /usr/share/relnote/note.js).

- **-u, --url <url>**
  Specify the URL for API data.

- **-d, --delay <date_time>**
  Specify the delay time in the format 'Sun Aug 25 12:03:19 CDT 2024'.

- **-wa, --warning-activation <ms>**
  Set the warning activation time in milliseconds (default is 86400000).

- **-wd, --warning-dismissal <ms>**
  Set the warning dismissal time in milliseconds (default is 60000).

- **-h, --help**
  Display this help message.

## Examples

1. Basic usage with default settings:
   ```bash
   relnote
   ```
2. Inject **note.js** into a custom HTML file and set a release date:
   ```bash 
   relnote -f myfile.html -j /path/to/note.js -d "Sun Sep 15 10:00:00 CDT 2024"
   ```
3. Specify API data URL and adjust warning timings:
   ```bash
   relnote -f custom.html -u http://example.com/api -wa 3600000 -wd 30000
   ```

## License

This project is licensed under the [MIT License](https://rem.mit-license.org/license.txt).

## Author

- Name: Nuriddin Bobonorov
- Email: sulaymon1w@gmail.com
- Website: [portfolio](http://portfolio.ofnur.com/)