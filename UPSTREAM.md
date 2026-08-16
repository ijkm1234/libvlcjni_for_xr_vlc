# Upstream Provenance

This repository is derived from VideoLAN libvlcjni.

- Upstream: https://code.videolan.org/videolan/libvlcjni.git
- Base branch: libvlcjni-3.x
- Base commit: 7cd0c151da4162aa3052fb6949ddab1436d8fafb
- XR branch: init

VLC core changes are maintained as normal commits in a dedicated fork.

- VLC fork: https://github.com/ijkm1234/vlc_for_xr_vlc.git
- Baseline branch: main (`3458be162f476ff64b639140b684efa1143ddeea`)
- XR release tag: `v0.0.1`
- Tagged release commit: `7381a31a75b018ced4757448f22979636c9c9dd2`
- Integrated tree: `493d3734ff87e49ee2dc95d573235e81b0ab3614`
- Upstream VLC base: 3458be162f476ff64b639140b684efa1143ddeea

During source preparation, `buildsystem/get-vlc.sh` checks out the original VLC
base, applies the unchanged libvlcjni patches from `libvlc/patches/`, then
cherry-picks the non-merge XR commits reachable from the release tag. The
resulting tree hash is verified for reproducibility.

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
