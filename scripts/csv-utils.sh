#!/usr/bin/env bash
set -euo pipefail

csv_col_idx() {
  local file="$1"
  local name="$2"
  awk -F, -v n="$name" '
    NR==1 {
      for (i=1; i<=NF; i++) {
        if ($i == n) {
          print i
          exit
        }
      }
    }
  ' "$file"
}

csv_values() {
  local file="$1"
  local name="$2"
  if [[ ! -f "$file" ]]; then
    return
  fi
  local idx
  idx="$(csv_col_idx "$file" "$name")"
  if [[ -z "$idx" ]]; then
    return
  fi
  awk -F, -v i="$idx" 'NR>1 {print $i}' "$file"
}

csv_count_eq() {
  local file="$1"
  local name="$2"
  local value="$3"
  if [[ ! -f "$file" ]]; then
    echo 0
    return
  fi
  local idx
  idx="$(csv_col_idx "$file" "$name")"
  if [[ -z "$idx" ]]; then
    echo 0
    return
  fi
  awk -F, -v i="$idx" -v v="$value" 'NR>1 && $i==v {c++} END {print c+0}' "$file"
}

csv_count_eq_pair() {
  local file="$1"
  local name_a="$2"
  local value_a="$3"
  local name_b="$4"
  local value_b="$5"
  if [[ ! -f "$file" ]]; then
    echo 0
    return
  fi
  local idx_a idx_b
  idx_a="$(csv_col_idx "$file" "$name_a")"
  idx_b="$(csv_col_idx "$file" "$name_b")"
  if [[ -z "$idx_a" || -z "$idx_b" ]]; then
    echo 0
    return
  fi
  awk -F, -v ia="$idx_a" -v va="$value_a" -v ib="$idx_b" -v vb="$value_b" 'NR>1 && $ia==va && $ib==vb {c++} END {print c+0}' "$file"
}

csv_count_repo_not_status() {
  local file="$1"
  local repo="$2"
  if [[ ! -f "$file" ]]; then
    echo 0
    return
  fi
  local repo_idx status_idx
  repo_idx="$(csv_col_idx "$file" "repo")"
  status_idx="$(csv_col_idx "$file" "status")"
  if [[ -z "$repo_idx" || -z "$status_idx" ]]; then
    echo 0
    return
  fi
  awk -F, -v ri="$repo_idx" -v rv="$repo" -v si="$status_idx" 'NR>1 && $ri==rv && $si!="aligned" {c++} END {print c+0}' "$file"
}
