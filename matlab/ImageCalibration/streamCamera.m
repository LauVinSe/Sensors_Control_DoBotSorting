%% Initiate ROS
rosshutdown;
rosinit('http://localhost:11311/');

% Subscribe to relevant topic - RGB Image from RGB-D Camera
rgbSub = rossubscriber('camera/color/image_raw');
pause(1);
image_h = imshow(readImage(rgbSub.LatestMessage));

while 1
    image_h.CData = readImage(rgbSub.LatestMessage);
    set(image_h,'CData',image_h.CData);
    drawnow
end