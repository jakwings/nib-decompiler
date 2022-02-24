#!/bin/sh

# Reference:
# - https://github.com/akahan/Nib-Decompiler
# - https://github.com/akahan/Nib-Decompiler/pull/4/files
# - https://stackoverflow.com/questions/25397048/extract-cfkeyedarchiveruid-value
# Tests:
# - ibtool --all decompiled.nib  # almost all data is printable
# - ibtool --upgrade --write upgraded.xib decompiled.nib  # failed silently

set -euf; unset -v IFS; export LC_ALL=C

if [ 1 -ne "$#" ]; then
  printf 'Usage: decompile.sh <compiled.nib>  #=> ./decompiled.nib\n' >&2
  exit 1
fi

compiled="$1"
decompiled="./decompiled-$$.nib"

if [ -d "${compiled}" ]; then
  rm -R -f -- "${decompiled}"
  mkdir -p -- "$(dirname -- "${decompiled}")"
  cp -R -- "${compiled}" "${decompiled}"
else
  rm -R -f -- "${decompiled}"
  mkdir -p -- "${decompiled}"
  cp -R -- "${compiled}" "${decompiled}/keyedobjects.nib"
fi

cat >"${decompiled}/info.nib" <<'EOT'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
	<dict/>
</plist>
EOT

cat >"${decompiled}/classes.nib" <<'EOT'
{
	IBClasses = ();
	IBVersion = 1;
}
EOT

printf '%s\n' "${decompiled}"
