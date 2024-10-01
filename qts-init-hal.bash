#!/bin/bash

## VERSION DRAFT 0001

QTSROOT=/opt/qts


#rm -rf $QTSROOT/tmp/* >/dev/null 2>&1
#rm -rf $QTSROOT/var/* >/dev/null 2>&1

umount $QTSROOT/tmp >/dev/null 2>&1
umount $QTSROOT/var >/dev/null 2>&1



mount -o size=512K -t tmpfs none $QTSROOT/var
mkdir -p $QTSROOT/var/{log,lock}
mount -o size=128K -t tmpfs none $QTSROOT/tmp


##TODO: use timeout
chroot $QTSROOT hal_daemon -f
sleep 1 ## this needs to run twice for a good init
chroot $QTSROOT hal_daemon -f


sleep 10 ##TODO: check return code, and wait for this string to appear in  $QTSROOT/var/log/hal_daemon.log
## hal_button_usb_monitor (.*):usb_button_support = 1


kill -9 $(pidof hal_daemon)



# clean up
#rm -rf $QTSROOT/tmp/* >/dev/null 2>&1
#rm -rf $QTSROOT/var/* >/dev/null 2>&1
umount $QTSROOT/tmp
umount $QTSROOT/var
