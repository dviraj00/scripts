#!/bin/bash
printf "


      .o.                    .                       o8o           oooo        
     .888.                 .o8                       `"'           `888        
    .8"888.      .oooo.o .o888oo  .ooooo.  oooo d8b oooo   .oooo.o  888  oooo  
   .8' `888.    d88(  "8   888   d88' `88b `888""8P `888  d88(  "8  888 .8P'   
  .88ooo8888.   `"Y88b.    888   888ooo888  888      888  `"Y88b.   888888.    
 .8'     `888.  o.  )88b   888 . 888    .o  888      888  o.  )88b  888 `88b.  
o88o     o8888o 8""888P'   "888" `Y8bod8P' d888b    o888o 8""888P' o888o -r00t 
                                                                               
                                                                               
                                                                               
This installation script is for ubuntu/debian based distros only.
Might work on other distros too if you satisfy dependencies as it does not contain distro specific code apart from package manager.

Feel free to edit this script to your necessity, redestribute, and credit this author.
Happy calling!!
"
printf "Elevating privilages for installation";
sudo su;

printf "Installing dependencies";
apt-get install build-essential wget libssl-dev libncurses5-dev libnewt-dev libxml2-dev linux-headers-$(uname -r) libsqlite3-dev uuid-dev git subversion;
printf "All dependencies satisfied";

printf "Downloading Asterisk";

cd /usr/src/;
wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-15-current.tar.gz;

printf "Unpacking..."
tar zxvf asterisk-15-current.tar.gz

printf "Compiling and setting up..."
cd asterisk-15*/;
contrib/scripts/get_mp3_source.sh;
contrib/scripts/install_prereq install;
./configure && make menuselect && make && make install;

printf "Creating sample configs..."
make samples;
make config;
ldconfig;
groupadd asterisk;
useradd -d /var/lib/asterisk -g asterisk asterisk;
sed -i 's/#AST_USER="asterisk"/AST_USER="asterisk"/g' /etc/default/asterisk;
sed -i 's/#AST_GROUP="asterisk"/AST_GROUP="asterisk"/g' /etc/default/asterisk;
sed -i 's/;runuser = asterisk/runuser = asterisk/g' /etc/asterisk/asterisk.conf;
sed -i 's/;rungroup = asterisk/rungroup = asterisk/g' /etc/asterisk/asterisk.conf;
chown -R asterisk:asterisk /var/spool/asterisk /var/run/asterisk /etc/asterisk /var/{lib,log,spool}/asterisk /usr/lib/asterisk;

printf "Installation done!!
starting up Asterisk";
asterisk -rvvv;


done
