#!/bin/bash
# Pull the stock files listed in proprietary-files-recovery.txt into recovery/root (64-bit only).
# Usage:  ./extract-files.sh adb              (stock OOS booted, USB debugging on; read-only `adb pull`)
#         ./extract-files.sh dir <ROOT>       (ROOT contains vendor/ odm/ system/ [system_ext/] from extracted stock images)
#         ./extract-files.sh local            (run ON the phone in Termux with root: copies straight from /vendor /odm /system into recovery/root)
# Every copied file is compared with proprietary-files-recovery.sha256 (the 593 stock hashes read on a OnePlus 8); a HASHDIFF line means the phone
# runs different firmware than the one this tree was verified against. Blobs are proprietary: keep the repository private unless you accept redistributing them.
set -u
HERE=$(cd "$(dirname "$0")" && pwd); TREE=$HERE; RR=$TREE/recovery/root
mode=${1:-}; src=${2:-}
case "$mode" in adb|local) ;; dir) [ -n "$src" ] || { sed -n '2,6p' "$0"; exit 1; } ;; *) sed -n '2,6p' "$0"; exit 1 ;; esac
BIN="/vendor/bin /vendor/bin/hw /odm/bin/hw /odm/bin"
LIB="/vendor/lib64 /odm/lib64 /system/lib64 /system_ext/lib64"
HW="/vendor/lib64/hw /odm/lib64/hw"
FW="/odm/vendor/firmware /vendor/firmware"
fetch() { # $1=device path  $2=destination file ; returns 0 if copied
  case "$mode" in
    adb)   adb pull "$1" "$2" >/dev/null 2>&1 ;;
    local) su -c "cat '$1'" > "$2" 2>/dev/null && [ -s "$2" ] ;;
    dir)   [ -f "$src$1" ] && cp -L "$src$1" "$2" ;;
  esac
}
miss_req=0; got=0; bad=0
sha_of() { sha256sum "$1" 2>/dev/null | cut -d" " -f1; }
while read -r kind name; do
  case "$kind" in ''|\#*) continue ;; esac
  opt=0; [ "${kind:0:1}" = "?" ] && { opt=1; kind=${kind:1}; }
  dest2=""
  case "$kind" in bin) dirs=$BIN; dest=$RR/system/bin ;; lib64) dirs=$LIB; dest=$RR/vendor/lib64 ;; hw) dirs=$HW; dest=$RR/vendor/lib64/hw ;; fw) dirs=$FW; dest=$RR/odm/vendor/firmware; dest2=$RR/vendor/firmware ;; *) echo "bad kind $kind"; continue ;; esac
  mkdir -p "$dest"; ok=0
  for d in $dirs; do if fetch "$d/$name" "$dest/$name"; then
      want=$(awk -v p="$d/$name" '$2==p {print $1}' "$HERE/proprietary-files-recovery.sha256"); have=$(sha_of "$dest/$name")
      if [ -z "$want" ]; then echo "OK      $d/$name  (no reference hash)"
      elif [ "$want" = "$have" ]; then echo "OK      $d/$name  sha256 matches stock 593"
      else echo "HASHDIFF $d/$name  have=$have want=$want"; bad=$((bad+1)); fi
      [ -n "$dest2" ] && { mkdir -p "$dest2"; cp "$dest/$name" "$dest2/$name"; }
      ok=1; got=$((got+1)); break; else rm -f "$dest/$name"; fi; done
  if [ $ok = 0 ]; then if [ $opt = 1 ]; then echo "absent  $name (optional)"; else echo "MISSING $name"; miss_req=$((miss_req+1)); fi; fi
done < "$HERE/proprietary-files-recovery.txt"
chmod 755 "$RR"/system/bin/* 2>/dev/null
echo "copied $got file(s); required files missing: $miss_req; hash mismatches: $bad"
[ $miss_req = 0 ] && [ $bad = 0 ]
