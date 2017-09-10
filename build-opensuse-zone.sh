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

#// FUNCTION: run script as root (Version 1.0)
checkrootuser() {
if [ "$(id -u)" != "0" ]; then
   echo "[ERROR] This script must be run as root" 1>&2
   exit 1
fi
}

#// FUNCTION: check state (Version 1.0)
checkhard() {
if [ $? -eq 0 ]
then
   echo "[$(printf "\033[1;32m  OK  \033[0m\n")] '"$@"'"
else
   echo "[$(printf "\033[1;31mFAILED\033[0m\n")] '"$@"'"
   sleep 1
   exit 1
fi
}

#// RUN

checkrootuser

if [ -f /etc/zypp/repos.d/Virtualization.repo ]
then
   : # dummy
else
   zypper ar -f http://download.opensuse.org/repositories/Virtualization/openSUSE_Leap_42.3 Virtualization
   checkhard added: Virtualization repo
fi

if [ -f /usr/bin/kiwi ]
then
   : # dummy
else
   if [ "$SUSE" = "opensuse" ]
   then
      zypper in -f python3-kiwi
      checkhard installed: python3-kiwi
   fi
   if [ "$SUSE" = "sles" ]
   then
      zypper in -f python2-kiwi
      checkhard installed: python2-kiwi
   fi
fi

if [ -f /usr/bin/umoci ]
then
   : # dummy
else
   zypper in -f umoci
   checkhard installed: umoci
fi

if [ -f /usr/bin/skopeo ]
then
   : # dummy
else
   zypper in -f skopeo
   checkhard installed: skopeo
fi

sudo kiwi-ng system prepare --description . --root /tmp/lx-zone
checkhard built: openSUSE lx zone from /tmp/lx-zone

sudo tar czf opensuse-zone.tar.gz /tmp/lx-zone
checkhard packaged: openSUSE lx zone from /tmp/lx-zone

### ### ### // ASS ### ### ###
exit 0
# EOF
