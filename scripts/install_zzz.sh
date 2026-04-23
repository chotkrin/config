#!/bin/bash

mkdir -p ~/ZZZ_Temp && cd ~/ZZZ_Temp                                                     12:58 

# modify the content by checking /home/tkrin/.local/share/sleepy-launcher/debug.log
cat << 'EOF' > urls.txt
https://autopatchcn.juequling.com/package_download/op/client_app/download/20260309103618_mkDL8E0hMidGEPPf/VolumeZip/juequling_2.7.0_AS.zip.001
https://autopatchcn.juequling.com/package_download/op/client_app/download/20260309103618_mkDL8E0hMidGEPPf/VolumeZip/juequling_2.7.0_AS.zip.002
https://autopatchcn.juequling.com/package_download/op/client_app/download/20260309103618_mkDL8E0hMidGEPPf/VolumeZip/juequling_2.7.0_AS.zip.003
https://autopatchcn.juequling.com/package_download/op/client_app/download/20260309103618_mkDL8E0hMidGEPPf/VolumeZip/juequling_2.7.0_AS.zip.004
https://autopatchcn.juequling.com/package_download/op/client_app/download/20260309103618_mkDL8E0hMidGEPPf/VolumeZip/juequling_2.7.0_AS.zip.005
https://autopatchcn.juequling.com/package_download/op/client_app/download/20260309103618_mkDL8E0hMidGEPPf/VolumeZip/juequling_2.7.0_AS.zip.006
https://autopatchcn.juequling.com/package_download/op/client_app/download/20260309103618_mkDL8E0hMidGEPPf/VolumeZip/juequling_2.7.0_AS.zip.007
https://autopatchcn.juequling.com/package_download/op/client_app/download/20260309103618_mkDL8E0hMidGEPPf/VolumeZip/juequling_2.7.0_AS.zip.008
https://autopatchcn.juequling.com/package_download/op/client_app/download/20260309103618_mkDL8E0hMidGEPPf/VolumeZip/juequling_2.7.0_AS.zip.009
https://autopatchcn.juequling.com/package_download/op/client_app/download/20260309103618_mkDL8E0hMidGEPPf/VolumeZip/juequling_2.7.0_AS.zip.010
EOF

aria2c -i urls.txt -x 16 -s 16 -j 5
