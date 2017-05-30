#!/usr/bin/fish

# Generate kayaking notes
pushd kajak

cat top.html > index.html
echo "<ul>" >> index.html

for SRC in *.md
    set RIVER (echo "$SRC" | sed 's|\.md$||')
    echo "Running loop for $RIVER"
    echo "   <li><a href=\"$RIVER.html\">$RIVER</a></li>" >> index.html
    cat top.html > "$RIVER.html"
    pandoc -f markdown -t html "$SRC" >> "$RIVER.html"
    cat bottom.html >> "$RIVER.html"
end

echo "</ul>" >> index.html
cat bottom.html >> index.html

popd
