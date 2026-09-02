#! /bin/sh
# Modified for XRVLC by XRVLC contributors on 2026-08-16.
set -e

LIBVLCJNI_SRC_DIR="$(cd "$(dirname "$0")"; pwd -P)/.."

#############
# FUNCTIONS #
#############

diagnostic()
{
    echo "$@" 1>&2;
}

fail()
{
    diagnostic "$1"
    exit 1
}

check_vlc_tree()
{
    current_revision=$(git rev-parse HEAD)
    if [ "$current_revision" != "$VLC_TESTED_HASH" ]; then
        fail "Error: Your VLC revision is ${current_revision}, expected ${VLC_TESTED_HASH} (${VLC_XR_VERSION})."
    fi
    current_tree=$(git rev-parse 'HEAD^{tree}')
    if [ "$current_tree" != "$VLC_TESTED_TREE" ]; then
        fail "Error: Your VLC tree is ${current_tree}, expected ${VLC_TESTED_TREE}."
    fi
    if ! git diff --quiet || ! git diff --cached --quiet; then
        fail "Error: Your vlc checkout contains tracked local changes."
    fi
}

prepare_vlc_source()
{
    resolved_version=$(git rev-parse "${VLC_XR_VERSION}^{commit}" 2> /dev/null || true)
    if [ "$resolved_version" != "$VLC_TESTED_HASH" ]; then
        diagnostic "VLC sources: fetching release tag ${VLC_XR_VERSION}"
        git fetch --force "$VLC_REPOSITORY" \
            "+refs/tags/${VLC_XR_VERSION}:refs/tags/${VLC_XR_VERSION}" || \
            fail "VLC sources: cannot fetch release tag ${VLC_XR_VERSION}"
    fi
    resolved_version=$(git rev-parse "${VLC_XR_VERSION}^{commit}" 2> /dev/null || true)
    [ "$resolved_version" = "$VLC_TESTED_HASH" ] || \
        fail "Error: VLC XR release tag ${VLC_XR_VERSION} resolves to ${resolved_version}, expected ${VLC_TESTED_HASH}."

    git am --abort > /dev/null 2>&1 || true
    git cherry-pick --abort > /dev/null 2>&1 || true
    git checkout --detach "${VLC_TESTED_HASH}"
    git reset --hard "${VLC_TESTED_HASH}"

    check_vlc_tree
}

VLC_XR_VERSION=v0.0.1
VLC_TESTED_HASH=fef678a7fcf79f717fd909a43cf737f415f4fa9e
VLC_TESTED_TREE=f3ac525baefb473ef03cc362ed837e9fb10f9921
VLC_REPOSITORY=https://github.com/ijkm1234/vlc_for_xr_vlc.git

RESET=0
BYPASS_VLC_SRC_CHECKS=0
while [ $# -gt 0 ]; do
    case $1 in
        help|--help|-h)
            echo "Use -b to bypass libvlc source checks (vlc custom sources)"
            echo "  --vlcgit <vlc_git_url> (default $VLC_REPOSITORY)"
            echo "  --vlcversion <vlc_xr_release_tag> (default $VLC_XR_VERSION)"
            echo "  --vlchash <vlc_release_commit> (default $VLC_TESTED_HASH)"
            echo "  --vlctree <vlc_release_tree> (default $VLC_TESTED_TREE)"
            exit 0
            ;;
        --reset)
            RESET=1
            ;;
        --vlcgit)
            VLC_REPOSITORY=$2
            shift
            ;;
        --vlcversion)
            VLC_XR_VERSION=$2
            shift
            ;;
        --vlchash)
            VLC_TESTED_HASH=$2
            shift
            ;;
        --vlctree)
            VLC_TESTED_TREE=$2
            shift
            ;;
        -b)
            BYPASS_VLC_SRC_CHECKS=1
            ;;
        *)
            diagnostic "$0: Invalid option '$1'."
            diagnostic "$0: Try --help for more information."
            exit 1
            ;;
    esac
    shift
done

####################
# Fetch VLC source #
####################

if [ ! -d "vlc" ]; then
    diagnostic "VLC sources: not found, cloning"
    git clone -b "${VLC_XR_VERSION}" --single-branch "${VLC_REPOSITORY}" vlc || fail "VLC sources: git clone failed"
    cd vlc
    prepare_vlc_source
    cd ..
else
    diagnostic "VLC source: found sources, leaving untouched"
fi
if [ "$BYPASS_VLC_SRC_CHECKS" = 1 ]; then
    diagnostic "VLC sources: Bypassing checks (required by option)"
elif [ $RESET -eq 1 ]; then
    cd vlc
    prepare_vlc_source
    cd ..
else
    diagnostic "VLC sources: checking integrated VLC tree"
    diagnostic "NOTE: checks can be bypass by adding '-b' option to this script."
    cd vlc
    check_vlc_tree
    cd ..
fi
