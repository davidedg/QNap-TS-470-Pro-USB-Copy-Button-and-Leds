# QNap-TS-470-Pro-USB-Copy-Button-and-Leds
QNAP TS-470 Pro - USB copy button HAL layer

Long story short: reinstalling my QNAP TS-470 Pro with TrueNAS scale 24.10.
\
USB copy button was not working and [existing projects](https://gist.github.com/zopieux/0b38fe1c3cd49039c98d5612ca84a045?permalink_comment_id=5211545#gistcomment-5211545) on the Internet would not work either.
\
I found out that my hardware/bios version somehow requires an initialization code that I could not be bothered to reverse.
\
So here's the idea: run the initialization code straight from QNAP binaries while running chrooted inside TrueNAS.


1. On your existing QNAP device (tis will create an archive under `/share/Public/qts-hal.tar.gz` - adjust accordingly): 

        cd / && tar czf /share/Public/qts-hal.tar.gz \
          sbin/{hal_daemon,hal_util,nasutil,get_ccode} \
          bin/{sh,bash,busybox,echo,grep,ps} \
          etc/{hal.conf,hal_util*.conf,model*.conf} \
          dev/null \
          lib64 \
          lib/libuLinux_{hal,ini}.so \
          lib/{ld-2*,ld-linux-*,libc,libc-*,libcrypt,libcrypt-*,libdl,libdl-*,libiconv,libjson,libm,libm-*,libncurses,libpthread,librt,librt-*,libssl,libz}.so* \
          usr/lib/libuLinux_{NAS,PDC,Storage,Util,cgi,config,naslog,qha,qlicense,quota}.so* \
          usr/lib/{libcrypto,libsqlite3,libxml2}.so* \
          --no-recursion tmp var

2. After installing TrueNAS, copy the archive over, then:

        QTSROOT=/opt/qts && mkdir -p $QTSROOT && cp qts-hal.tar.gz $QTSROOT/ && cd $QTSROOT && tar xzf qts-hal.tar.gz && rm qts-hal.tar.gz

3. Run this script at system startup (pre-init): TODO(qts-init-hal)

4. Test the USB functionality with poll-copybutton (you can compile it on Debian 12).

5. Enjoy [existing projects](https://github.com/zopieux/qnapctl) to handle the usb copy button
