rosshutdown;
rosinit('http://localhost:11311/');

rgbSub = rossubscriber('camera/color/image_raw');
pause(1);
image_h = imshow(readImage(rgbSub.LatestMessage));

dobot = DobotMagician;

q = [0 0 0 0];
dobot.PublishTargetJoint(q)
pause(1)


for i = 1:10
    image_h.CData = readImage(rgbSub.LatestMessage);
    [color_detected, centroidsRed,r] = detect_red(image_h.CData);
    set(image_h,'CData',color_detected);
    centroidsRed
    r

end

if r == 0
    error('Cannot find object');
end

depthSub = rossubscriber('/camera/aligned_depth_to_color/image_raw');
pause(1);
msg = depthSub.LatestMessage;
img = readImage(msg);
% depthImage_h = imshow(img);

% Read the depth image as a uint16 image
depthImage = readImage(depthSub.LatestMessage);
depthImage = double(depthImage) / 1000.0; % Convert depth values from millimeters to meters

z_coordinates = calculateDepth(centroidsRed, depthImage);

%% intrinsic parameter of the camera - callibrate each time we use


fx = 606.8311157226562;
fy = 606.0000610351562;

cx = 333.31500244140625;

cy = 246.64346313476562;

K = [fx,  0, cx; ...
     0, fy, cy; ...
     0,  0,  1];
invK = inv(K);

u = centroidsRed(:, 1);
v = centroidsRed(:, 2);

object_3D_coordinates = convertTo3DCoordinates(u, v, z_coordinates - 0.035, invK); 

% Camera distance to DoBot
cameraInDobot = [0.24, 0, 0.32];

cameraToDobot = transl(0.32,0,0.24) * trotz(-pi/2) * trotx(pi);

objectTr = transl(object_3D_coordinates(1),object_3D_coordinates(2),object_3D_coordinates(3));

objectInRobot = cameraToDobot * objectTr;

objectPose = objectInRobot(1:3,4);

X = objectPose(1) - 0.078;
Y = objectPose(2) + 0.055;
Z = objectPose(3) %+ 0.0325;

disp([X , Y, Z])

input('Proceed?')

if X < 0 || X > 0.32 || Y < -0.3 || Y > 0.3 || Z < -0.07
    error("Bad input")
end

end_effector_position = [X Y Z];
end_effector_rotation = [0,0,0];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(1)

%% Turn on tool
% Open tool
onOff = 1;
openClose = 1;
dobot.PublishToolState(onOff,openClose);
pause(3)

q1 = q;
dobot.PublishTargetJoint(q1)
pause(1)

%%
qTarget = [0.6292    0.9725    0.0816    0.0000];
dobot.PublishTargetJoint(qTarget)
pause(3)

%% Turn off tool
onOff = 0;
openClose = 0;
dobot.PublishToolState(onOff,openClose);
pause(1)

%% Blue

q1 = q;
dobot.PublishTargetJoint(q1)
pause(1)

input('Next color?')
pause(5)


for i = 1:10
    image_h.CData = readImage(rgbSub.LatestMessage);
    [color_detected, centroidsBlue,b] = detect_blue(image_h.CData);
    set(image_h,'CData',color_detected);

end

if b == 0
    error('Cannot find object');
end

depthSub = rossubscriber('/camera/aligned_depth_to_color/image_raw');
pause(1);
msg = depthSub.LatestMessage;
img = readImage(msg);
% depthImage_h = imshow(img);

% Read the depth image as a uint16 image
depthImage = readImage(depthSub.LatestMessage);
depthImage = double(depthImage) / 1000.0; % Convert depth values from millimeters to meters

z_coordinates = calculateDepth(centroidsBlue, depthImage);

%% intrinsic parameter of the camera - callibrate each time we use


fx = 606.8311157226562;
fy = 606.0000610351562;

cx = 333.31500244140625;
cy = 246.64346313476562;

K = [fx,  0, cx; ...
     0, fy, cy; ...
     0,  0,  1];
invK = inv(K);

u = centroidsBlue(:, 1);
v = centroidsBlue(:, 2);

object_3D_coordinates = convertTo3DCoordinates(u, v, z_coordinates - 0.035, invK); 

% Camera distance to DoBot
cameraInDobot = [0.24, 0, 0.32];

cameraToDobot = transl(0.32,0,0.24) * trotz(-pi/2) * trotx(pi);

objectTr = transl(object_3D_coordinates(1),object_3D_coordinates(2),object_3D_coordinates(3));

objectInRobot = cameraToDobot * objectTr;

objectPose = objectInRobot(1:3,4);

X = objectPose(1) - 0.078;
Y = objectPose(2) + 0.05;
Z = objectPose(3); %+ 0.0325;

disp([X , Y, Z])

input('Proceed?')

if X < 0 || X > 0.32 || Y < -0.3 || Y > 0.3 || Z < -0.07
    error("Bad input")
end

end_effector_position = [X Y Z];
end_effector_rotation = [0,0,0];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(1)

%% Turn on tool
% Open tool
onOff = 1;
openClose = 1;
dobot.PublishToolState(onOff,openClose);
pause(3)

q1 = q;
dobot.PublishTargetJoint(q1)
pause(1)

%%
qTarget = [0.6292    0.9725    0.0816    0.0000];
dobot.PublishTargetJoint(qTarget)
pause(3)

%% Turn off tool
onOff = 0;
openClose = 0;
dobot.PublishToolState(onOff,openClose);
pause(1)

%% 
q1 = q;
dobot.PublishTargetJoint(q1)
pause(1)

%% Yellow
input('Next color?')
pause(5)
q1 = q;
dobot.PublishTargetJoint(q1)
pause(1)



for i = 1:10
    image_h.CData = readImage(rgbSub.LatestMessage);
    [color_detected, centroidsYellow,y] = detect_yellow(image_h.CData);
    set(image_h,'CData',color_detected);

end

if y == 0
    error('Cannot find object');
end

depthSub = rossubscriber('/camera/aligned_depth_to_color/image_raw');
pause(1);
msg = depthSub.LatestMessage;
img = readImage(msg);
% depthImage_h = imshow(img);

% Read the depth image as a uint16 image
depthImage = readImage(depthSub.LatestMessage);
depthImage = double(depthImage) / 1000.0; % Convert depth values from millimeters to meters

z_coordinates = calculateDepth(centroidsYellow, depthImage);

%% intrinsic parameter of the camera - callibrate each time we use


fx = 606.8311157226562;
fy = 606.0000610351562;

cx = 333.31500244140625;
cy = 246.64346313476562;

K = [fx,  0, cx; ...
     0, fy, cy; ...
     0,  0,  1];
invK = inv(K);

u = centroidsYellow(:, 1);
v = centroidsYellow(:, 2);

object_3D_coordinates = convertTo3DCoordinates(u, v, z_coordinates - 0.035, invK); 

% Camera distance to DoBot
cameraInDobot = [0.24, 0, 0.32];

cameraToDobot = transl(0.32,0,0.24) * trotz(-pi/2) * trotx(pi);

objectTr = transl(object_3D_coordinates(1),object_3D_coordinates(2),object_3D_coordinates(3));

objectInRobot = cameraToDobot * objectTr;

objectPose = objectInRobot(1:3,4);

X = objectPose(1) - 0.078;
Y = objectPose(2) + 0.05;
Z = objectPose(3); %+ 0.0325;

disp([X , Y, Z])

input('Proceed?')

if X < 0 || X > 0.32 || Y < -0.3 || Y > 0.3 || Z < -0.07
    error("Bad input")
end

end_effector_position = [X Y Z];
end_effector_rotation = [0,0,0];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(1)

%% Turn on tool
% Open tool
onOff = 1;

openClose = 1;
dobot.PublishToolState(onOff,openClose);
pause(3)

q1 = q;
dobot.PublishTargetJoint(q1)
pause(1)

%%
qTarget = [0.6292    0.9725    0.0816    0.0000];
dobot.PublishTargetJoint(qTarget)
pause(3)

%% Turn off tool
onOff = 0;
openClose = 0;
dobot.PublishToolState(onOff,openClose);
pause(1)

%% 
q1 = q;
dobot.PublishTargetJoint(q1)
pause(1)