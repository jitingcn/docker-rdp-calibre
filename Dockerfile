
# Builds a docker gui image
FROM hurricane/dockergui:x11rdp1.3

MAINTAINER aptalca

#########################################
##        ENVIRONMENTAL CONFIG         ##
#########################################

# Set environment variables

# User/Group Id gui app will be executed as default are 99 and 100
ENV USER_ID=99
ENV GROUP_ID=100

# Gui App Name default is "GUI_APPLICATION"
ENV APP_NAME="Calibre"

# Default resolution, change if you like
ENV WIDTH=1920
ENV HEIGHT=1080
ENV EDGE=1

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

#########################################
##    REPOSITORIES AND DEPENDENCIES    ##
#########################################
RUN \
echo 'deb http://archive.ubuntu.com/ubuntu trusty main universe restricted' > /etc/apt/sources.list && \
echo 'deb http://archive.ubuntu.com/ubuntu trusty-updates main universe restricted' >> /etc/apt/sources.list

# Install packages needed for app
RUN \
export DEBCONF_NONINTERACTIVE_SEEN=true DEBIAN_FRONTEND=noninteractive && \
apt-get update && \
apt-get install -y ImageMagick python-djvu pdftohtml && \
apt-get install -y --force-yes --no-install-recommends fonts-wqy-microhei && \
apt-get install -y --force-yes --no-install-recommends ttf-wqy-zenhei

#########################################
##          GUI APP INSTALL            ##
#########################################

# Install steps for X app
RUN \
sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin

 # Clean-up
RUN \
rm -fr /var/lib/apt/lists/* && \
apt-get clean

ADD firstrun.sh /etc/my_init.d/firstrun.sh
RUN chmod +x /etc/my_init.d/firstrun.sh

# Copy X app start script to right location
COPY startapp.sh /startapp.sh

#########################################
##         EXPORTS AND VOLUMES         ##
#########################################

# Place whater volumes and ports you want exposed here:
VOLUME ["/config"]
EXPOSE 3389 8080 8081
