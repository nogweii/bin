#!/bin/sh

# This is a script to install both ruby 1.8.7 and 1.9.1, with suffixed binaries and symlinks
BUILD_DIR="$HOME/Downloads/Ruby"
INSTALL_DIR="$HOME/sys/"

mkdir -p $BUILD_DIR ; cd $BUILD_DIR
wget ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.7-p72.tar.bz2
tar -xjvf ruby-1.8.7-p72.tar.bz2
cd ruby-1.8.7-p72
./configure --prefix=$INSTALL_DIR --program-suffix=18 --enable-shared
make && make all install
 
cd $BUILD_DIR
wget http://rubyforge.iasi.roedu.net/files/rubygems/rubygems-1.3.1.tgz
tar -xzvf rubygems-1.3.1.tgz
cd rubygems-1.3.1
$INSTALL_DIR/bin/ruby18 setup.rb --vendor
$INSTALL_DIR/bin/gem18 update --system
 
cd $BUILD_DIR
wget ftp://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.1-p0.tar.bz2
tar -xjvf ruby-1.9.1-p0.tar.bz2
cd ruby-1.9.1-p0
./configure --prefix=$INSTALL_DIR --program-suffix=19 --enable-shared
make && make all install
 
cd $INSTALL_DIR/bin
binaries=( erb gem irb rdoc ri ruby testrb )
for binary in ${binaries[@]}; do
  mv ${binary}{,~} # Just in case
  ln -s $(pwd)/${binary}18 $(pwd)/${binary}
done
