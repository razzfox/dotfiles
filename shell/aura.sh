AURA="$(which aura)" 2>/dev/null || return 1
break="----------------------------------------------------------------------------"

aura() {
  if test "$EUID" = 0; then
    if grep --silent "nobody ALL=(ALL) NOPASSWD: $AURA" /etc/sudoers; then
      sudo -u nobody sudo $AURA "$@"
    else
      echo "nobody ALL=(ALL) NOPASSWD: $AURA" >> /etc/sudoers
      aura "$@"
    fi
  else
    $AURA "$@"
  fi
}

aura_edit_pkgbuild() {
  aura --hotedit "$@"
}

auras() {
  less --quit-if-one-screen --LONG-PROMPT --force --RAW-CONTROL-CHARS <(echo -e "${break}\nArch Official:\n$break"; $AURA -Ss --color=always "$@"; echo -e "${break}\nAUR Unofficial:\n$break"; $AURA -As "$@")
}
