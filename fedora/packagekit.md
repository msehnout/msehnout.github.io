# Giant cache dir in /var/cache/PackageKit

```
$ sudo du -hc -d1 /var/cache/
...
14G	/var/cache/PackageKit
$ sudo pkcon refresh force -c -1
...
$ sudo du -hc -d1 /var/cache/
...
12G	/var/cache/PackageKit
```

```
#!/usr/bin/env bash

# Remove stale RPMs from /var/cache/PackageKit/2[0-9]/metadata/updates/packages/
#
# They take a lot of space.
# Remove the ones that are no longer installed.
# It would be OK to remove even the ones already installed but that would
# probably prevent the use of Delta RPMs.
#
# Notes:
# Don't run this during an update (duh!).
# If you run it after an update failed and before you try it again,
# any RPMs that have been downloaded but not installed will be
# discarded so a subsequent update will have to download them again.
#
# <https://bugzilla.redhat.com/show_bug.cgi?id=1306992>
# <https://bugs.freedesktop.org/show_bug.cgi?id=80053>
# <https://lists.fedoraproject.org/pipermail/users/2016-March/469483.html>
#
# Written by D. Hugh Redelmeier
# Dedicated to the public domain.

# stop on command failure; consider references to undefined variables to be an error
set -eu

df -h /var/cache/PackageKit

for d in /var/cache/PackageKit/2[0-9]/metadata/*/packages/ ; do
	cd $d

	# create a list of installed RPM files
	rpm -qa | sed -e 's/$/.rpm/' | LOCALE=C sort >~/0installed

	# create a list of hoarded files
	LOCALE=C ls >~/0saved

	# create a list of files that are obsoleted (saved but not installed)
	LOCALE=C comm -23 --check-order ~/0saved ~/0installed  >~/0obsolete

	echo "$0: $(wc -l <~/0obsolete) obsolete RPMs of $(wc -l <~/0saved) in $(pwd)"

	if [ -s ~/0obsolete ] ; then

		# Delete files list in ~/0obsolete
		# This is the first step that requires root.
		# Note: ~/ means something different for each user.

		sudo xargs --no-run-if-empty --delimiter='\n' rm -f <~/0obsolete
	fi
done

df -h /var/cache/PackageKit
```
