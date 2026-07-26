#!/bin/bash

set -eu

line_count=$(printf '%s\n' "${SELECTED_TEXT}" | wc -l)
line_start=$((LINE_NUMBER - line_count + 1))
unix_path=$(cygpath -u "${RELATIVE_FILE}")

sed -i -b -E "
  ${line_start},${LINE_NUMBER} s_//![[:blank:]]*([^[:blank:]!\r])_//! \1_g
  ${line_start},${LINE_NUMBER} s_///([^[:blank:]/\r])_/// \1_g
  ${line_start},${LINE_NUMBER} s_/\*\*([^[:blank:]*<\r])_/** \1_g
  ${line_start},${LINE_NUMBER} s_/\*!([^[:blank:]!<\r])_/*! \1_g

  ${line_start},${LINE_NUMBER} s_/\*[[:blank:]]*([^[:blank:]*!\r])_/* \1_g
  ${line_start},${LINE_NUMBER} s_([^[:blank:]*])[[:blank:]]*\*/_\1 */_g
  ${line_start},${LINE_NUMBER} s_//[[:blank:]]*([^/!\r])_// \1_g
  ${line_start},${LINE_NUMBER} s_[[:blank:]]+(\r?)\$_\1_
" "${unix_path}"
