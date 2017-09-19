
ASS - pre-built images
======================

* http://dsapid.root1.ass.de/ui/#!/home

ASS - initial patches
=====================

* changed: LEAP 42.2 to 42.3
* changed: static root/root/guesttools files to git clone
* add: build-suse-zone.sh

General
=======

Experimental lx branded zone for openSUSE Leap 42.3

Current status: **it works**

# SmartOS Requirements

* SmartOS: > 20170913T233706Z
* https://us-east.manta.joyent.com/Joyent_Dev/public/SmartOS/smartos.html#20170913T233706Z
* https://smartos.org/bugview/OS-6326

# Image and manifest creation

Run the `build-suse-zone.sh` script on a openSUSE Leap 42.3 host.

Copy the `opensuse-lx-zone.tar.gz` file to a SmartOS host.

Checkout [this](https://github.com/ass-a2s/debian-lx-brand-image-builder) repository
and then execute:

```
./create-lx-image -t /zones/ass.de/test/opensuse-zone.tar.gz -k 4.4.0 -m 20170913T233706Z -i ass-opensuse-leap-42.3 -d "ASS - openSUSE Leap 42.3 64-bit lx-brand image." -u https://docs.joyent.com/images/container-native-linux
```

This will produce the `.zfs` image and its manifest.

The can be imported via:

```
imgadm install -m ass-opensuse-leap-42.3-20170919.json -f ass-opensuse-leap-42.3-20170919.zfs.gz
```

The names of the image and of the manifest are going to change according to your local time.

