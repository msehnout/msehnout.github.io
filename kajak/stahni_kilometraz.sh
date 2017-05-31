#!/bin/bash

while read -r reka
do
    NAZEV=$(echo "${reka}" | sed 's|.*\.cz/\w*/||' | sed 's|\.aspx.*||')
    ZEME=$(echo "${reka}" | sed 's|.*\.cz/||' | sed 's|/.*\.aspx.*||')
    echo "Stahuju ${reka} - ${NAZEV} (${ZEME})"
    curl "${reka}&kilo=kilom&kfoto=1&symbol=1" -o "${NAZEV}"
    # Oklika pokud doslo k chybe, tak to zkusime bez fotek
    if grep 'Chybove hlaseni' "${NAZEV}" &> /dev/null
    then
        curl "${reka}&kilo=kilom&symbol=1" -o "${NAZEV}"
    fi
    # Vytvor hlavicku
    cat > "${NAZEV}.html" << EOF
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>

<body>

EOF
    # Nadpis
    echo "<h1>${NAZEV}</h1>" >> "${NAZEV}.html"
    # Stahni kilometraz
    sed -n -e '/ctl00_ctl00_ContentPlaceHolder1_Kilometraz_ctl00_tKilom/,/<\/table>/ p' "${NAZEV}" >> "${NAZEV}.html"
    # Nahrad relativni cesty absolutnima
    sed -i "s|src=\"foto|src=\"http://www.raft.cz/${ZEME}/foto|g" "${NAZEV}.html"
    sed -i 's|src="../gif|src="http://www.raft.cz/gif|g' "${NAZEV}.html"
    cat >> "${NAZEV}.html" << EOF
</body>
EOF
    wkhtmltopdf "${NAZEV}.html" "${NAZEV}.pdf"
done < reky
