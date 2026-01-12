# Beets Configuration

Music library manager configuration for use across multiple machines.

## Setup

1. **Run dotbot** to symlink config:
   ```bash
   ./install
   ```

2. **Create secrets.yaml** from template:
   ```bash
   cp ~/.config/beets/secrets.yaml.template ~/.config/beets/secrets.yaml
   # Edit secrets.yaml with your API credentials
   ```

3. **Set up mode (safe by default)**:
   ```bash
   ln -sf mode-safe.yaml ~/.config/beets/mode.yaml
   ```

4. **Add environment variables** to `~/.zshrc_local`:
   ```bash
   # Beets paths (machine-specific)
   export BEETS_LIBRARY="$HOME/Dropbox/music"
   export BEETS_DB="$HOME/Dropbox/offline/data/musiclibrary.db"
   export BEETS_TEST_DIR="$HOME/Music/beets"
   ```

   Helper functions are already in `shell/functions.sh`:
   - `beet-safe` - Enable safe mode (no file modifications)
   - `beet-live` - Enable live mode (full functionality)
   - `beet-mode` - Show current mode
   - `beet-test <args>` - Run beet with test library/db
   - `beet-test-setup` - Create test environment
   - `beet-test-cleanup` - Delete test environment

5. **Install beets and plugins**:
   ```bash
   pipx install beets
   pipx inject beets \
     beetcamp \
     beets-beatport4 \
     pyacoustid \
     pylast \
     python-mpd2 \
     requests
   ```

   Note: Many plugins are built-in to beets (discogs, spotify, deezer, chroma,
   keyfinder, replaygain). Only external plugins need injection.

6. **Install external tools**:
   ```bash
   # macOS
   brew install chromaprint ffmpeg libkeyfinder

   # Build keyfinder-cli from source (macOS)
   git clone https://github.com/EvanPurkhiser/keyfinder-cli.git
   cd keyfinder-cli
   make
   sudo make install  # or copy to ~/bin/

   # Linux
   sudo apt install libchromaprint-tools ffmpeg libkeyfinder-dev
   # Then build keyfinder-cli as above
   ```

## File Structure

```
~/.config/beets/
├── config.yaml           # Main config (symlinked from dotfiles)
├── mode.yaml             # -> mode-safe.yaml or mode-live.yaml (local, gitignored)
├── mode-safe.yaml        # Safe mode: no file writes/moves
├── mode-live.yaml        # Live mode: full functionality
├── secrets.yaml          # API credentials (local, gitignored)
└── secrets.yaml.template # Template for secrets
```

## Metadata Source Priority

1. **Bandcamp** - Best for electronic/independent releases
2. **Discogs** - Comprehensive catalog, good for vinyl/physical releases
3. **Beatport** - Electronic music with BPM/key data
4. **MusicBrainz** - Open database, good fallback
5. **Spotify/Deezer** - Last resort for mainstream tracks

## Path Templates

- **Albums**: `album/{albumartist}/{album}/{artist} - {title}.aiff`
- **Compilations**: `comp/Various Artists/{album}/{artist} - {title}.aiff`
- **Singles**: `single/{artist} - {title}.aiff`
