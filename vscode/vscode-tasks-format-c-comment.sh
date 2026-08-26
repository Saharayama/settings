#!/bin/bash

set -euo pipefail

line_count=$(printf '%s\n' "$SELECTED_TEXT" | wc -l)
line_start=$((LINE_NUMBER - line_count + 1))
unix_path=$(cygpath -u "$FILE")
line_range="${line_start},${LINE_NUMBER}"

sed -i -b -E "
  ${line_range} s_//![[:blank:]]*([^[:blank:]!\r])_//! \1_g
  ${line_range} s_///([^[:blank:]/\r])_/// \1_g
  ${line_range} s_/\*\*([^[:blank:]*<\r])_/** \1_g
  ${line_range} s_/\*!([^[:blank:]!<\r])_/*! \1_g

  ${line_range} s_/\*[[:blank:]]*([^[:blank:]*!\r])_/* \1_g
  ${line_range} s_([^[:blank:]*])[[:blank:]]*\*/_\1 */_g
  ${line_range} s_//[[:blank:]]*([^/!\r])_// \1_g
  ${line_range} s_[[:blank:]]+(\r?)\$_\1_
" "$unix_path"
