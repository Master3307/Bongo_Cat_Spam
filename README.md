
# Bongo Cat Spam (BCat) — Minimal README

This repo contains installer and plugin scripts for running the Bongo Cat automation in Steam.

Quick install (single command, no repo clone):

```bash
curl -L -o BCatInstaller.run "https://github.com/Master3307/Bongo_Cat_Spam/releases/download/Release/BCatInstaller.run" && chmod +x BCatInstaller.run && ./BCatInstaller.run
```

What the installer does (summary):

```
=== Installing requirements (system packages)...
Installing Bongo Cat Automation requirements...
xdotool is already installed
kdialog is already installed
xclip is already installed
All required packages are now installed.
=== Running main installer ===

============
INSTALLATION COMPLETE!
============

=== Done! See README.md for instructions. ===
```

Steam setup (required):

1. In Steam, right-click Bongo Cat → Properties → Launch Options.
2. Paste this launch option (the installer copies it to your clipboard):

```text
/bin/bash "$HOME/.local/share/Steam/steamapps/common/BongoCat/BongoCat_Data/Plugins/bcat_wrapper.sh" %command%
```

3. Close Properties and click PLAY. The spam script will run from the Plugins folder after Bongo Cat starts.

Update / remove:

- To update or remove the plugin scripts, delete `spam.sh` and `bcat_wrapper.sh` from:

```
$HOME/.local/share/Steam/steamapps/common/BongoCat/BongoCat_Data/Plugins
```

Uninstall:

- Remove the Plugins folder above or clear the Launch Options entry in Steam.

>That's all