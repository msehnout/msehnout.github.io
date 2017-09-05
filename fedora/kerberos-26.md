# Broken krb5 config in Fedora 26

There was a breaking change in krb5-libs in Fedora 26. Workaround is to switch back `dns_canonicalize_hostname` from `false` to `true`.
