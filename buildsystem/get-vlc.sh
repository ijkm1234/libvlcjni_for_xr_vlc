#! /bin/sh
set -e

LIBVLCJNI_SRC_DIR="$(cd "$(dirname "$0")"; pwd -P)/.."
PATCHES_DIR=$LIBVLCJNI_SRC_DIR/libvlc/patches

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
    current_tree=$(git rev-parse 'HEAD^{tree}')
    if [ "$current_tree" != "$VLC_TESTED_TREE" ]; then
        fail "Error: Your integrated vlc tree is ${current_tree}, expected ${VLC_TESTED_TREE}."
    fi
    if ! git diff --quiet || ! git diff --cached --quiet; then
        fail "Error: Your vlc checkout contains tracked local changes."
    fi
}

prepare_vlc_source()
{
    git cat-file -e "${VLC_BASE_HASH}^{commit}" 2> /dev/null || \
        fail "Error: VLC base commit ${VLC_BASE_HASH} is missing."
    if ! git cat-file -e "${VLC_XR_VERSION}^{commit}" 2> /dev/null; then
        diagnostic "VLC sources: fetching release tag ${VLC_XR_VERSION}"
        git fetch "$VLC_REPOSITORY" \
            "refs/tags/${VLC_XR_VERSION}:refs/tags/${VLC_XR_VERSION}" || \
            fail "VLC sources: cannot fetch release tag ${VLC_XR_VERSION}"
    fi
    git cat-file -e "${VLC_XR_VERSION}^{commit}" 2> /dev/null || \
        fail "Error: VLC XR release tag ${VLC_XR_VERSION} is missing."

    git am --abort > /dev/null 2>&1 || true
    git cherry-pick --abort > /dev/null 2>&1 || true
    git checkout --detach "${VLC_BASE_HASH}"
    git reset --hard "${VLC_BASE_HASH}"

    diagnostic "VLC sources: applying libvlcjni upstream patches"
    git am --message-id "$PATCHES_DIR"/*.patch || fail "VLC sources: cannot apply libvlcjni patches"

    diagnostic "VLC sources: applying XR commits"
    # Release tags may point to a GitHub merge commit. Apply the tagged XR
    # commits but skip the merge wrapper, which would duplicate their changes.
    xr_commits=$(git rev-list --reverse --no-merges \
        "${VLC_BASE_HASH}..${VLC_XR_VERSION}")
    [ -n "$xr_commits" ] || fail "VLC sources: XR commit range is empty"
    for xr_commit in $xr_commits; do
        git cherry-pick "$xr_commit" || fail "VLC sources: cannot apply XR commit ${xr_commit}"
    done

    check_vlc_tree
}

VLC_BASE_HASH=3458be162f476ff64b639140b684efa1143ddeea
VLC_XR_VERSION=v0.0.1
VLC_TESTED_TREE=493d3734ff87e49ee2dc95d573235e81b0ab3614
VLC_REPOSITORY=https://github.com/ijkm1234/vlc_for_xr_vlc.git

RESET=0
BYPASS_VLC_SRC_CHECKS=0
while [ $# -gt 0 ]; do
    case $1 in
        help|--help|-h)
            echo "Use -b to bypass libvlc source checks (vlc custom sources)"
            echo "  --vlcgit <vlc_git_url> (default $VLC_REPOSITORY)"
            echo "  --vlcversion <vlc_xr_release_tag> (default $VLC_XR_VERSION)"
            echo "  --vlcbasehash <vlc_base_git_hash> (default $VLC_BASE_HASH)"
            echo "  --vlctree <integrated_tree_hash> (default $VLC_TESTED_TREE)"
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
        --vlcbasehash)
            VLC_BASE_HASH=$2
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
