# ------------------------------------------------------------ 
# Start with Ubuntu focal Gorilla
# ------------------------------------------------------------

FROM ubuntu:latest

# ------------------------------------------------------------
# Set environment variables
# ------------------------------------------------------------

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get install sudo

# ------------------------------------------------------------
# Set the sources
# ------------------------------------------------------------

RUN echo 'deb http://ubuntu.mirror.rain.co.za/ubuntu/ focal main restricted universe multiverse\n'\
'deb http://ubuntu.mirror.rain.co.za/ubuntu/ focal-security main restricted universe multiverse\n'\
'deb http://ubuntu.mirror.rain.co.za/ubuntu/ focal-updates main restricted universe multiverse\n'\
'deb http://ubuntu.mirror.rain.co.za/ubuntu/ focal-backports main restricted universe multiverse\n'\
'deb-src http://ubuntu.mirror.rain.co.za/ubuntu/ focal main restricted universe multiverse\n'\
'deb-src http://ubuntu.mirror.rain.co.za/ubuntu/ focal-security main restricted universe multiverse\n'\
'deb-src http://ubuntu.mirror.rain.co.za/ubuntu/ focal-updates main restricted universe multiverse\n'\
'deb-src http://ubuntu.mirror.rain.co.za/ubuntu/ focal-proposed main restricted universe multiverse\n'\
'deb-src http://ubuntu.mirror.rain.co.za/ubuntu/ focal-backports main restricted universe multiverse\n'\
'' > /etc/apt/sources.list

# ------------------------------------------------------------
# Install and Configure
# ------------------------------------------------------------

RUN sudo apt-get update
RUN sudo apt-get install -y --no-install-recommends

RUN sudo apt-get update
RUN sudo apt-get upgrade -y
RUN sudo apt-get install -y dbus

RUN sudo apt-get update -y
RUN sudo apt-get install -y dbus-x11

RUN sudo dpkg --configure -a

RUN sudo apt-get install -f

RUN sudo dbus-x11 nano sudo bash net-tools 
RUN sudo novnc x11vnc xvfb 
RUN sudo zip unzip expect supervisor curl git wget g++ ssh terminator htop gnupg2 locales 
RUN sudo xfce4 ibus ibus-clutter ibus-gtk ibus-gtk3 
RUN sudo gnome-shell ubuntu-gnome-desktop gnome-session gdm3 tasksel 
RUN sudo gnome-session gdm3 tasksel 
RUN firefox

RUN sudo apt-get autoclean
RUN sudo apt-get autoremove

RUN sudo dpkg-reconfigure locales

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
