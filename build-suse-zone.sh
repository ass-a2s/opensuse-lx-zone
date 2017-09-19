#!/bin/sh

### LICENSE - (BSD 2-Clause) // ###
#
# Copyright (c) 2017, Daniel Plominski (ASS-Einrichtungssysteme GmbH)
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
# list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice, this
# list of conditions and the following disclaimer in the documentation and/or
# other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
### // LICENSE - (BSD 2-Clause) ###

### ### ### ASS // ### ### ###

SUSE=$(grep -s "^ID=" /etc/os-release | sed 's/ID=//g' | sed 's/"//g')

ADIR="$PWD"

#// FUNCTION: run script as root (Version 1.0)
check_root_user() {
if [ "$(id -u)" != "0" ]; then
   echo "[ERROR] This script must be run as root" 1>&2
   exit 1
fi
}

#// FUNCTION: check state (Version 1.0)
check_hard() {
if [ $? -eq 0 ]
then
   echo "[$(printf "\033[1;32m  OK  \033[0m\n")] '"$@"'"
else
   echo "[$(printf "\033[1;31mFAILED\033[0m\n")] '"$@"'"
   sleep 1
   exit 1
fi
}

#// FUNCTION: prepare_opensuse (Version 1.0)
prepare_opensuse() {
if [ "$SUSE" = "opensuse" ]
then
   if [ ! -f /etc/zypp/repos.d/Virtualization.repo ]
   then
      zypper ar -f http://download.opensuse.org/repositories/Virtualization/openSUSE_Leap_42.3 Virtualization
      check_hard added: Virtualization - openSUSE 42.3 Repository
   fi
   if [ ! -f /usr/bin/kiwi ]
   then
      zypper in -f python3-kiwi
      check_hard installed: python3-kiwi
   fi
   if [ ! -f /usr/bin/umoci ]
   then
      zypper in -f umoci
      check_hard installed: umoci
   fi
   if [ ! -f /usr/bin/skopeo ]
   then
      zypper in -f skopeo
      check_hard installed: skopeo
   fi
fi
}

#// FUNCTION: build_opensuse (Version 1.0)
build_opensuse() {
if [ "$SUSE" = "opensuse" ]
then
   sudo kiwi-ng system prepare --description . --root /tmp/lx-zone
   check_hard built: openSUSE lx zone from /tmp/lx-zone

   sudo tar czf opensuse-zone.tar.gz /tmp/lx-zone
   check_hard packaged: openSUSE lx zone from /tmp/lx-zone
fi
}

#// FUNCTION: prepare_sles (Version 1.0)
prepare_sles() {
if [ "$SUSE" = "sles" ]
then
   if [ ! -f /etc/zypp/repos.d/Virtualization.repo ]
   then
      zypper ar -f http://download.opensuse.org/repositories/Virtualization/SLE_12 Virtualization
      check_hard added: Virtualization - SLES 12 Repository
   fi
fi
}

#// FUNCTION: check_git (Version 1.0)
check_git() {
if [ ! -d "$ADIR"/root/root/guesttools ]
then
   echo "[$(printf "\033[1;31mFAILED\033[0m\n")] can not find ../root/root/guesttools"
   sleep 1
   exit 1
fi
}

#// RUN

check_root_user

prepare_opensuse
prepare_sles

git clone https://github.com/ass-a2s/sdc-vmtools-lx-brand "$ADIR"/root/root/guesttools
check_hard git: guesttools
check_git

build_opensuse

### ### ### // ASS ### ### ###
exit 0
# EOF
