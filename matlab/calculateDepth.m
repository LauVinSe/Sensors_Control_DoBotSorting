%% Working
% 
% function z_coordinates = calculateDepth(centroids, depthImage)
%     % Initialize an array to store the Z-coordinates (depth)
%     z_coordinates = zeros(size(centroids, 1), 1);
% 
%     % Extract the X and Y coordinates of the centroids
%     x_coordinates = centroids(:, 1);
%     y_coordinates = centroids(:, 2);
% 
%     % Calculate the Z-coordinates (depth) for each centroid
%     for i = 1:size(centroids, 1)
%         x = x_coordinates(i);
%         y = y_coordinates(i);
% 
%         % Ensure the pixel coordinates are within the image boundaries
%         if x >= 1 && x <= size(depthImage, 2) && y >= 1 && y <= size(depthImage, 1)
%             % Extract the depth value in meters at the centroid's position
%             z_coordinates(i) = depthImage(round(y), round(x));
%         end
%     end
% end

function z_coordinates = calculateDepth(centroids, depthImage)
    % Validate input parameters
    if nargin < 2
        error('Missing required parameters: centroids and depthImage are required.');
    end

    % Check if the input is a non-empty matrix
    if isempty(centroids) || isempty(depthImage)
        error('Input matrices (centroids or depthImage) should not be empty.');
    end

    % Initialize an array to store the Z-coordinates (depth values)
    numCentroids = size(centroids, 1);
    z_coordinates = zeros(numCentroids, 1);

    % Iterate over the centroids to retrieve the depth from the depth image
    for i = 1:numCentroids
        % Round the coordinates as pixel indices must be integers. Also, ensure they're within the valid range.
        x = min(max(round(centroids(i, 1)), 1), size(depthImage, 2));
        y = min(max(round(centroids(i, 2)), 1), size(depthImage, 1));

        % Fetch the corresponding depth value. Flip the indices if necessary based on your image structure.
        z_coordinates(i) = depthImage(y, x); % assumes depthImage rows correspond to Y, columns to X
    end

    % Handle any potential issue with depth data (e.g., missing or invalid depth)
    invalidDepthIndices = isnan(z_coordinates) | z_coordinates == 0;
    if any(invalidDepthIndices)
        warning('Some centroids returned invalid depth data. Consider additional handling.');
        % Optionally, set invalid depth values to a default or handle them as appropriate for your application
        z_coordinates(invalidDepthIndices) = NaN; % or any other appropriate value or method of handling
    end
end