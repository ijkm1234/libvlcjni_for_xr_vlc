# libvlcjni — XRVLC fork

[![Join the chat at https://discord.gg/3h3K3JF](https://img.shields.io/discord/716939396464508958?label=discord)](https://discord.gg/3h3K3JF)

This repository is an independent modified fork of the VideoLAN **LibVLC**
bindings for Android. It is maintained for XRVLC and is not an official
VideoLAN distribution. It is not affiliated with or endorsed by VideoLAN.

The upstream source, base revision, integrated VLC revision, and modified-file
inventory are documented in [UPSTREAM.md](UPSTREAM.md).

This documentation was modified for XRVLC on 2026-08-16.

- [Project Structure](#project-structure)
- [LibVLC](#libvlc)
- [License](#license)
- [Build](#build)
  - [Build LibVLC](#build-libvlc)
- [Contribute](#contribute)
  - [Pull requests](#pull-requests)
- [Issues and feature requests](#issues-and-feature-requests)
- [Support](#support)

## Project Structure

Here are the current folders of vlc-android project:

- buildsystem : Build scripts, CI and maven publication configuration
- libvlc : LibVLC gradle module, VLC source code will be cloned in `vlc/` at root level.

## LibVLC

LibVLC is the Android library embedding VLC engine, which provides a lot of multimedia features, like:

- Play every media file formats, every codec and every streaming protocols
- Hardware and efficient decoding on every platform, up to 8K
- Network browsing for distant filesystems (SMB, FTP, SFTP, NFS...) and servers (UPnP, DLNA)
- Playback of Audio CD, DVD and Bluray with menu navigation
- Support for HDR, including tonemapping for SDR streams
- Audio passthrough with SPDIF and HDMI, including for Audio HD codecs, like DD+, TrueHD or DTS-HD
- Support for video and audio filters
- Support for 360 video and 3D audio playback, including Ambisonics
- Ability to cast and stream to distant renderers, like Chromecast and UPnP renderers.

And more.

![LibVLC stack](https://images.videolan.org/images/libvlc_stack.png)

The upstream LibVLC module can be used to power Android media players. The
XRVLC variant in this repository is built from source.

See the upstream
[LibVLC Android samples](https://code.videolan.org/videolan/libvlc-android-samples).

## License

The libvlcjni library code is licensed under
[LGPL-2.1-or-later](libvlc/COPYING.LIB), except where an individual file states
otherwise. Existing copyright and license notices remain in effect; XRVLC
modifications follow the license of the files being modified.

## Build

### Build LibVLC

You will need a recent Linux distribution to build VLC.
It should work with Windows 10, and macOS, but there is no official support for this.

#### Setup

See the upstream
[AndroidCompile wiki page](https://wiki.videolan.org/AndroidCompile/), especially
for build dependencies.

Here are the essential points:

On Debian/Ubuntu, install the required dependencies:
```bash
sudo apt install automake ant autopoint cmake build-essential libtool-bin \
    patch pkg-config protobuf-compiler ragel subversion unzip git \
    openjdk-8-jre openjdk-8-jdk flex python wget
```

Setup the build environment:
Set `$ANDROID_SDK` to point to your Android SDK directory
`export ANDROID_SDK=/path/to/android-sdk`

Set `$ANDROID_NDK` to point to your Android NDK directory
`export ANDROID_NDK=/path/to/android-ndk`

Then, you are ready to build!

#### Build

`buildsystem/compile.sh -l -a <ABI>`

ABI can be `arm`, `arm64`, `x86`, `x86_64` or `all` for a multi-abis build

You can do a library release build with `-r` argument

## Contribute

libvlcjni and this XRVLC fork are libre and open source software.

### Pull requests

XRVLC-specific changes should be proposed to this repository. Changes intended
for upstream libvlcjni should be proposed to the
[VideoLAN repository](https://code.videolan.org/videolan/libvlcjni/).

## Issues and feature requests

Report XRVLC-specific issues in this repository. The
[VideoLAN libvlcjni bugtracker](https://code.videolan.org/videolan/libvlcjni/issues)
is for the upstream project.

## Support

- XRVLC source and issues: https://github.com/ijkm1234/libvlcjni_for_xr_vlc
- Upstream source: https://code.videolan.org/videolan/libvlcjni
