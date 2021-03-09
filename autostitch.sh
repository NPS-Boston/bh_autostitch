#!/bin/bash
for i in 1 2 3 4
do
wget -O sw.jpeg http://192.168.3.221/snap.jpeg
wget -O se.jpeg http://192.168.3.163/snap.jpeg
wget -O nw.jpeg http://192.168.3.214/snap.jpeg
wget -O ne.jpeg http://192.168.2.248/snap.jpeg
ffmpeg -y -r 60 -f lavfi -i color=c=black:s=7184x1064 -i ne.jpeg -i se.jpeg -i sw.jpeg -i nw.jpeg -loop 1 -i 1080-mask-left.png -loop 1 -i 1080-mask-left-75px.png -loop 1 -i 3592_VR_legend.png -filter_complex "\
                [5:v] alphaextract [a]; \
                [6:v] alphaextract [b]; \
                [a] split [a1][a2]; \
                [b] split [b1][b2]; \
                [1:v][a1] alphamerge [ne]; \
                [2:v][a2] alphamerge [se]; \
                [3:v][b1] alphamerge [sw]; \
                [4:v][b2] alphamerge [nw]; \
                [ne] split [ne1][ne2]; \
                [0:v][ne1] overlay=shortest=1:x=-1670:y=-5 [tmp1]; \
                [tmp1][se] overlay=shortest=1:x=90:y=-5 [tmp2]; \
                [tmp2][sw] overlay=shortest=1:x=1935:y=-15 [tmp3]; \
                [tmp3][nw] overlay=shortest=1:x=3766:y=-2 [tmp4]; \
                [tmp4][ne2] overlay=shortest=1:x=5513:y=-5 [tmp5]; \
		[7:v][tmp5] overlay=shortest=1:x=0:y=1350 \
" -frames:v 1 pano.jpeg

sleep 15
done
