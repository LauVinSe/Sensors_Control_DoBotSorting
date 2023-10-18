% function object_3D_coordinates = convertTo3DCoordinates(u, v, Z, K)
%     % Extract the intrinsic parameters from K
%     fx = K(1,1);
%     fy = K(2,2);
%     cx = K(1,3);
%     cy = K(2,3);
% 
%     % Back-project the points from 2D to 3D:
%     X_world = (u - cx) * Z / fx;
%     Y_world = (v - cy) * Z / fy;
% 
%     % The result is in the camera's coordinate system.
%     % If your camera isn't at (0,0,0) in the world system or has some rotation, 
%     % you'll need to transform these coordinates by the camera's extrinsic matrix (not provided here).
%     object_3D_coordinates = [X_world, Y_world, Z];
% end

function object_3D_coordinates = convertTo3DCoordinates(u, v, Z, invK)
    % Create a column vector for the image point
    uv_point = [u; v; 1];  % This is in homogeneous coordinates

    % Back-project to camera reference system
    % We're using homogeneous coordinates, so we need to normalize after the multiplication
    cam_point = invK * uv_point;
    cam_point = cam_point / cam_point(3); % normalize (only necessary if K had a non-1 bottom right element, but good for consistency)

    % Now, use the depth information to scale the point in the camera's coordinate space
    X = cam_point(1) * Z;
    Y = cam_point(2) * Z;
    Z_world = Z; % Keeping the variable names consistent for clarity

    object_3D_coordinates = [X , Y, Z_world];
end