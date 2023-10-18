function [highlighted_img,centroids, y] = detect_yellow(img)
    % Convert the input image to HSV color space
    hsv_img = rgb2hsv(img);

    % Extract the Hue, Saturation, and Value channels
    h = hsv_img(:, :, 1);
    s = hsv_img(:, :, 2);
    v = hsv_img(:, :, 3);

    % Define the green color thresholds in HSV
    hue_lower_threshold = 0.1;    % Adjust as needed
    hue_upper_threshold = 0.3;    % Adjust as needed
    saturation_threshold = 0.4;    % Adjust as needed
    value_threshold = 0.3;         % Adjust as needed

    % Create masks for green color detection
    hue_mask = (h >= hue_lower_threshold) & (h <= hue_upper_threshold);
    saturation_mask = (s >= saturation_threshold);
    value_mask = (v >= value_threshold);

    % Combine the masks to detect green regions
    green_mask = hue_mask & saturation_mask & value_mask;

    % Check if green is detected
    g = any(green_mask(:));

    % Perform morphological operations on the blue mask if needed
    green_mask = imfill(green_mask, 'holes');
    green_mask = bwmorph(green_mask, 'erode', 2);
    green_mask = bwmorph(green_mask, 'dilate', 3);
    green_mask = imfill(green_mask, 'holes');

    % Find connected components and region properties
    stats = regionprops(green_mask, 'Centroid');
    
    if isempty(stats)
        y = 0;
        centroids = []; % No red objects found
    else
        y = 1;
        centroids = vertcat(stats.Centroid);
    end

    % Highlight the detected regions
    imgBoth = imoverlay(img, green_mask);

    % Highlight each centroid with a blue color
    if y == 1
        for i = 1:size(centroids, 1)
            imgBoth = insertMarker(imgBoth, centroids(i, :), 'x', 'color', 'blue', 'size', 10);
        end
    end

    % Return the resulting image and the flag indicating blue detection
    highlighted_img = imgBoth;
end