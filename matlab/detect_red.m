function [highlighted_img, centroids, r] = detect_red(img)
    hI = rgb2hsv(img);
    hImage1 = hI(:, :, 1);
    sImage1 = hI(:, :, 2);
    vImage1 = hI(:, :, 3);

    % Define your color thresholds for red
    hueTL1 = 0.029; hueTH1 = 0.98;
    saturationTL1 = 0.39; saturationTH1 = 1;
    valueTL1 = 0.01; valueTH1 = 1;

    % Create masks for red color
    hueMaskRed1 = (hImage1 <= hueTL1) | (hImage1 >= hueTH1);
    saturationMaskRed1 = (sImage1 >= saturationTL1) & (sImage1 <= saturationTH1);
    valueMaskRed1 = (vImage1 >= valueTL1) & (vImage1 <= valueTH1);
    redObjectsMask1 = hueMaskRed1 & saturationMaskRed1 & valueMaskRed1;

    % Fill holes, erode, and dilate the mask
    out2 = imfill(redObjectsMask1, 'holes');
    out3 = bwmorph(out2, 'erode', 2);
    out3 = bwmorph(out3, 'dilate', 3);
    out3 = imfill(out3, 'holes');

    % Find connected components and region properties
    stats = regionprops(out3, 'Centroid');
    
    if isempty(stats)
        r = 0;
        centroids = []; % No red objects found
    else
        r = 1;
        centroids = vertcat(stats.Centroid);
    end

    % Highlight the detected regions
    imgBoth = imoverlay(img, out3);

    % Highlight each centroid with a blue color
    if r == 1
        for i = 1:size(centroids, 1)
            imgBoth = insertMarker(imgBoth, centroids(i, :), 'x', 'color', 'blue', 'size', 10);
        end
    end

    highlighted_img = imgBoth;
end
