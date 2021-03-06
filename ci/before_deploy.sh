# This script takes care of building your crate and packaging it for release

set -ex

main() {
    local src=$(pwd) \
          stage=

    case $TRAVIS_OS_NAME in
        linux)
            stage=$(mktemp -d)
            ;;
        osx)
            stage=$(mktemp -d -t tmp)
            ;;
    esac

    test -f Cargo.lock || cargo generate-lockfile

    # Update this to build the artifacts that matter to you
    cross rustc --bin the-way --target $TARGET --release

    # Update this to package the right artifacts
    cp target/$TARGET/release/the-way $stage/
    cp README.md $stage/
    cp images/* $stage/
    cp LICENSE $stage/

    cd $stage
    tar czf $src/$CRATE_NAME-$TRAVIS_TAG-$TARGET.tar.gz *
    cd $src

    rm -rf $stage
}

main
