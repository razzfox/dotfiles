cd /opt

git clone https://github.com/transcode-open/apt-cyg.git
cp -v apt-cyg/apt-cyg /usr/local/bin/

git clone https://github.com/wofr06/lesspipe

git clone https://github.com/hut/ranger.git
cd ranger*
make install
cd ..


# Also install:
# Go
#https://golang.org/dl/
# Ruby
#http://rubyinstaller.org/
# TeraCopy
#http://www.codesector.com/downloads
# ffmpeg
#http://ffmpeg.zeranoe.com/builds/
# Ext2Fsd
#http://www.ext2fsd.com/
