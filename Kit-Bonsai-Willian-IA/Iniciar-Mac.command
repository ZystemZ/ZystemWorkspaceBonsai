#!/bin/bash
base=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd) || exit 1
/bin/bash "$base/Iniciar-Linux-Mac.sh"
printf '\nPressione Enter para fechar.'
read -r _
