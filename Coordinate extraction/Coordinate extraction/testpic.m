system('fswebcam -d /dev/video2 -r 800x600 --skip 20 --set sharpness=1 --set "Focus, Auto"=False --set "Focus (absolute)"=100 --no-banner --jpeg 95 imgleft.jpg');
system('fswebcam -d /dev/video0 -r 800x600 --skip 20 --set sharpness=1 --set "Focus, Auto"=False --set "Focus (absolute)"=100 --no-banner --jpeg 95 imgright.jpg');
