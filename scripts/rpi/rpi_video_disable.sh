fbset -xres 16 -yres 16 -vxres 16 -vyres 16 -depth 16

will reduce the Video refresh memory bandwidth to almost nothing.

And I think:
/opt/vc/bin/tvservice -p
/opt/vc/bin/tvservice -o

will end up losing the console and making the memory bandwidth used go to zero.



sdram_freq=440
