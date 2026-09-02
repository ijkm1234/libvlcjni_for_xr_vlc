# Upstream Provenance

This repository is derived from VideoLAN libvlcjni.

- Upstream: https://code.videolan.org/videolan/libvlcjni.git
- Base branch: libvlcjni-3.x
- Base commit: 7cd0c151da4162aa3052fb6949ddab1436d8fafb
- XR branch: init

VLC core changes are maintained as normal commits in a dedicated fork.

- VLC fork: https://github.com/ijkm1234/vlc_for_xr_vlc.git
- Release branch: main
- XR release tag: `v0.0.1`
- Tagged release commit: `fef678a7fcf79f717fd909a43cf737f415f4fa9e`
- Released tree: `f3ac525baefb473ef03cc362ed837e9fb10f9921`
- Upstream VLC base: 3458be162f476ff64b639140b684efa1143ddeea

The `v0.0.1` release includes the Android compatibility patches and XRVLC
changes. During source preparation, `buildsystem/get-vlc.sh` resolves the
release tag, verifies both its commit and tree hashes, and checks out that
release directly in detached-HEAD mode for reproducibility.

The generated or checked-out `vlc/` source tree remains intentionally untracked.

Files modified from the upstream libvlcjni base are:

- `.gitignore`
- `buildsystem/get-vlc.sh`
- `gradle.properties`
- `libvlc/jni/libvlcjni-mediaplayer.c`
- `libvlc/src/org/videolan/libvlc/AWindow.java`
- `libvlc/src/org/videolan/libvlc/MediaPlayer.java`
- `libvlc/src/org/videolan/libvlc/interfaces/IVLCVout.java`

These modified files carry an in-file change notice dated 2026-08-16.

This repository is not affiliated with, sponsored by, or endorsed by
VideoLAN. VLC and VLC media player are trademarks of VideoLAN.
