#!/bin/sh

package=shaarli

echo "Attempting to get a newer version of ${package}"

if uscan; then
    # There is a new version available!
    version=$(uscan --report --verbose| sed -n 's/Newest version on remote site is \([.0-9]\+\).*/\1/p')
    # Version number for the Debian package
    dversion=${version}~beta~dfsg1
    # Version number for the git tag
    tversion=${version}_beta_dfsg1
    # Upstream's version number
    version=${version}beta
    
    if [ -f ../${package}_${version}.zip ]; then
        unzip -qq ../${package}_${version}.zip -d ..
        git checkout upstream
        echo "Importing new upstream version in upstream branch"
        git-import-orig --pristine-tar --no-merge --upstream-version=${version} ../${package}_${version}
        git checkout dfsg_clean
        git pull . upstream
        echo "Removing non-DFSG approved files"
        rm inc/jquery*
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

