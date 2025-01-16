#!/bin/bash

rm -rf man*/

for file in $(find /usr/share/man/man* -type f); do
    relative_path="${file#/usr/share/man/}"
    dirname="${relative_path%.?.gz}"
    mkdir -p "$dirname"
    (cd "$dirname" && zcat "$file" \
        | groff -mandoc -Thtml \
        | sed -e 's/<b>\([^<]*\)<\/b>(\([1-9]*\))/<a href="..\/..\/man\2\/\1\/"><b>\1<\/b>(\2)<\/a>/g' \
        | sed 's/<\/head>/<link rel="stylesheet" href="..\/..\/man.css" \/><script type="module" src="..\/..\/man.js"><\/script><\/head>/'> "index.html")
    echo "$relative_path"

    echo "$(basename "$dirname")	$dirname/" >> pages.tsv
done
