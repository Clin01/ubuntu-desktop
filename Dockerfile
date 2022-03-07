# ------------------------------------------------------------
# Start with Ubuntu Groovy Gorilla
# ------------------------------------------------------------

FROM ubuntu

# ------------------------------------------------------------
# Set environment variables
# ------------------------------------------------------------

ENV DEBIAN_FRONTEND=noninteractive

# ------------------------------------------------------------
# Set the sources
# ------------------------------------------------------------

RUN echo 'deb http://ubuntu.mirror.rain.co.za/ubuntu/ groovy main restricted universe multiverse\n'\
'deb http://ubuntu.mirror.rain.co.za/ubuntu/ groovy-security main restricted universe multiverse\n'\
'deb http://ubuntu.mirror.rain.co.za/ubuntu/ groovy-updates main restricted universe multiverse\n'\
'deb http://ubuntu.mirror.rain.co.za/ubuntu/ groovy-backports main restricted universe multiverse\n'\
'deb-src http://ubuntu.mirror.rain.co.za/ubuntu/ groovy main restricted universe multiverse\n'\
'deb-src http://ubuntu.mirror.rain.co.za/ubuntu/ groovy-security main restricted universe multiverse\n'\
'deb-src http://ubuntu.mirror.rain.co.za/ubuntu/ groovy-updates main restricted universe multiverse\n'\
'deb-src http://ubuntu.mirror.rain.co.za/ubuntu/ groovy-proposed main restricted universe multiverse\n'\
'deb-src http://ubuntu.mirror.rain.co.za/ubuntu/ groovy-backports main restricted universe multiverse\n'\
'' > /etc/apt/sources.list

# ------------------------------------------------------------
# Install and Configure
# ------------------------------------------------------------

RUN apt-get update && apt-get install -y --no-install-recommends 
RUN    dbus-x11 nano sudo bash net-tools 
RUN    novnc x11vnc xvfb 
RUN    zip unzip expect supervisor curl git wget g++ ssh terminator htop gnupg2 locales 
RUN    xfce4 ibus ibus-clutter ibus-gtk ibus-gtk3 
RUN    gnome-shell ubuntu-gnome-desktop gnome-session gdm3 tasksel 
RUN    gnome-session gdm3 tasksel 
RUN    firefox

RUN apt-get autoclean
RUN apt-get autoremove

RUN dpkg-reconfigure locales

# ------------------------------------------------------------
# Add the Resources and Set Up the System
# ------------------------------------------------------------

COPY . /system

# @todo: Update the noVNC Web Page Resources to Support Legacy Browsers
# RUN unzip /system/resources/novnc.zip -d /system
# RUN rm -rf /usr/share/novnc
# RUN mv /system/novnc /usr/share/

RUN cp /usr/share/novnc/vnc_auto.html /usr/share/novnc/index.html
RUN sed "s|<title>noVNC</title>|<title>Ubuntu Desktop</title>|g" /usr/share/novnc/index.html > /usr/share/novnc/index-updated.html
RUN mv /usr/share/novnc/index-updated.html /usr/share/novnc/index.html
RUN cp /system/resources/favicon.ico /usr/share/novnc/favicon.ico

RUN chmod +x /system/conf.d/websockify.sh
RUN chmod +x /system/run.sh

CMD ["/system/run.sh"]
