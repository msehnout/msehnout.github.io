#!/usr/bin/fish

cat top.html style.css body.html > index.html

# Generate kayaking notes
pushd kajak

cat top.html > index.html
echo "<ul>" >> index.html

for SRC in *.md
    set RIVER (echo "$SRC" | sed 's|\.md$||')
    set RIVERNAME (head --lines=1 "$SRC" | cut -c 3-)
    echo "Running loop for $RIVERNAME"
    echo "   <li><a href=\"$RIVER.html\">$RIVERNAME</a></li>" >> index.html
    cat top.html > "$RIVER.html"
    pandoc -f markdown -t html "$SRC" >> "$RIVER.html"
    cat bottom.html >> "$RIVER.html"
end

echo "</ul>" >> index.html
cat bottom.html >> index.html

popd
