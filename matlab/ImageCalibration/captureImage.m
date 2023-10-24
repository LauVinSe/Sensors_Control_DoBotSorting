% Shutdown any previous ROS sessions
rosshutdown;

% Initialize ROS with the master's URI
rosinit('http://localhost:11311/');

% Subscribe to the relevant topic - RGB Image from RGB-D Camera
rgbSub = rossubscriber('camera/color/image_raw');

% Pause for a short duration to ensure subscription is active and messages are being received
pause(2); % pause for 2 seconds to ensure the next message is a fresh image

% Read the latest message from the subscribed topic
rgbImageMsg = receive(rgbSub); % You can specify a timeout, if needed, with 'receive(rgbSub, 10)' where 10 is 10 seconds

% Extract the image from the message
rgbImage = readImage(rgbImageMsg);

% Display the image
imshow(rgbImage);

% To save the image to a file, use the following line:
imwrite(rgbImage, 'snapshot15.png');