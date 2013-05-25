#!/bin/sh

package=shaarli

echo "attempting to get a newer version of ${package}"

if uscan; then
    version=$(uscan --report --verbose| sed -n 's/Newest version on remote site is \([.0-9]\+\).*/\1/p')
    dversion=${version}~beta~dfsg1
    version=${version}beta
    if [ -f ../${package}_${version}.zip ]; then
	cd ..
	unzip -qq -o ${package}_${version}.zip
	rm ${package}_${version}.zip
	mv ${package}_${version} ${package}-${dversion}
	rm ${package}-${dversion}/inc/jquery*
	rm ${package}-${dversion}/inc/rain.tpl.class.php
	tar czf ${package}_${dversion}.orig.tar.gz ${package}-${dversion}
	echo "extracted the newest version into ../${package}-${dversion}"
    fi
else
    echo "no new version: end of $0."
fi
