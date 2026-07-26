#!/bin/bash

set -eu

line_count=$(printf '%s\n' "${SELECTED_TEXT}" | wc -l)
line_start=$((LINE_NUMBER - line_count + 1))
unix_path=$(cygpath -u "${RELATIVE_FILE}")

RECENT_COLORS="234, 23 month ago, 235, 22 month ago, 236, 21 month ago, 237, 20 month ago, 238, 19 month ago, 239, 18 month ago, 240, 17 month ago, 241, 16 month ago, 242, 15 month ago, 243, 14 month ago, 244, 13 month ago, 245, 12 month ago, 246, 11 month ago, 247, 10 month ago, 248, 9 month ago, 249, 8 month ago, 250, 7 month ago, 251, 6 month ago, 252, 5 month ago, 253, 4 month ago, 254, 3 month ago, 231, 2 month ago, 230, 1 month ago, 229, 3 weeks ago, 228, 2 weeks ago, 227, 1 week ago, 226"

git \
  -c pager.blame="less -+F -S -x4" \
  -c color.blame.highlightRecent="$RECENT_COLORS" \
  blame \
  ${BASE_COMMIT} \
  --abbrev=6 \
  --color-by-age \
  --date=format:'%Y-%m-%d %H:%M:%S' \
  -L "${line_start}","${LINE_NUMBER}" \
  -- "${unix_path}"
