#!/bin/sh

package=shaarli

echo "Attempting to get a newer version of ${package}"

if uscan --no-symlink; then
    # There is a new version available!
    version=$(uscan --report --verbose| sed -n 's/uscan: Newest version of shaarli on remote site is \([.0-9]\+\).*/\1/p')
    # Version number for the Debian package
    dversion=${version}~dfsg1
    # Version number for the git tag
    tversion=${version}_dfsg1
    
    if [ -f ../${package}-${version}.tar.gz ]; then
        git checkout upstream
        echo "Importing new upstream version in upstream branch"
        git-import-orig --pristine-tar --no-merge --upstream-version=${version} ../${package}-${version}.tar.gz
        git checkout dfsg_clean
        git pull . upstream
        echo "Removing non-DFSG approved files"
        rm inc/jquery*
        rm inc/qr.min.js
        rm inc/rain.tpl.class.php
        git commit -a -m "Make ${version} source DFSG clean"
        git tag upstream/${tversion}
        git checkout master
        echo "Merging DFSG-clean new version in master branch"
        git pull --no-edit . dfsg_clean
        dch --newversion ${dversion}-1
        echo "All set for ${dversion}-1."
        echo "Build the package by running 'git-buildpackage --git-ignore-new'"
    fi
else
    echo "No new version: end of $0."
fi

