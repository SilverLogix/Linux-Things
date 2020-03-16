# Do not use yet!!!
# Using for an auto install script menu later!
# Mar 08, 2020, 01:39:12


sudo apt install 

preload					# Fast start, much wow
ksystemlog				# God of log
grub-customizer			# EZ grub config!
exfat-fuse exfat-utils	# For mounting exfat
qdirstat				# Find things taking up space!
midori					# Lightweight backup webrowser
xterm					# Some things require this???

sudo preload start


# WARNING Do not remove K3b! IT WILL BREAK SOUND!

# Why would i want these
sudo apt-get remove --purge qlipper
sudo apt-get remove --purge libreo*


sudo apt clean
sudo apt autoremove


# For compiling things! My Complete All in One! 
# WARNING OVER 1GB! 
sudo apt-get install wget git build-essential cmake kernel-package fakeroot libncurses5-dev libssl-dev ccache bison flex autoconf automake autotools-dev dkms checkinstall libelf-dev libiberty-dev libpci-dev libudev-dev zlib1g-dev intltool pkg-config python-dev libtool ccache doxygen software-properties-common libart-2.0-dev libaspell-dev libblas3 liblapack3 libboost-dev libboost-python-dev libcdr-dev libdouble-conversion-dev libgc-dev libgdl-3-dev libglib2.0-dev libgsl-dev libgtk-3-dev libgtkmm-3.0-dev libgtkspell3-3-dev libhunspell-dev libjemalloc-dev liblcms2-dev libmagick++-dev libpango1.0-dev libpng-dev libpoppler-glib-dev libpoppler-private-dev libpotrace-dev libreadline-dev librevenge-dev libsigc++-2.0-dev libsoup2.4-dev libvisio-dev libwpg-dev libxml-parser-perl libxml2-dev libxslt1-dev python-lxml zlib1g-dev


# OTHER

# Fix bugged grub countdown
sudo sed -i "/recordfail_broken=/{s/1/0/}" /etc/grub.d/00_header

# Launch things with high priority
sudo nice -n -10 su <USERNAME> -c firefox



