clear, clc;

left_image = im2double(imread("BinocularStereo/tsukuba_l.ppm"));
right_image = im2double(imread("BinocularStereo/tsukuba_r.ppm"));


%% 2. Consider each of the following pixels
% points = [136, 83; 203, 304; 182, 119; 186, 160; 123, 224; 153, 338];
% 
% for i = 1 : length(points)
%     row_points = point_correspondence(left_image, right_image, points(i, :), 15, "SAD");
% 
%     x = row_points(1, :);
%     y = row_points(2, :);
% 
%     [minVal, minIdx] = min(y);
%     [maxVal, maxIdx] = max(y);
%     minDelta = x(minIdx);
%     maxDelta = x(maxIdx);
%     fprintf("Picture %d: minVal=%.2f at Delta=%d; maxVal=%.2f at Delta=%d\n", ...
%         i, minVal, minDelta, maxVal, maxDelta);
%     
%     figure(i)
%     plot(x, y)
% 
%     title("Similarity Profile")
%     xlabel("Delta along " + points(i, 1) + "th row")
%     ylabel("Value difference")
% end


%% 3. Devise a strategy to estimate the most similar patch
% points = [91, 213];
% 
% minDelta = zeros(1, 6);
% for i = linspace(3, 18, 6)
%     row_points = point_correspondence(left_image, right_image, points, i, "SAD");
%     
%     x = row_points(1, :);
%     y = row_points(2, :);
% 
%     [minVal, minIdx] = min(y);
%     minDelta(i/3) = x(minIdx);
% 
%     subplot (2, 3, i/3);
%     plot(x, y) 
%     
%     title("Patch Size = " + i)
%     xlabel("Delta along 91th row")
%     ylabel("Value difference")
% end


%% 4. Repeat this calculation for all left image pixels
% patch_size = [5, 7, 9, 12];
% subplot_size = sqrt(length(patch_size));
% 
% for i = 1 : length(patch_size)
%     depth_image = find_depth(left_image, right_image, patch_size(i), "SAD", 24);
% 
%     inf_idx = find(depth_image == Inf);
%     depth_image(inf_idx) = 0;
%     
%     title_string = sprintf("Patch Size %d", patch_size(i));
%     subplot(subplot_size, subplot_size, i), imshow(depth_image), colormap('jet');
%     colorbar;
%     title(title_string);
% end


%% 5. To fill in the undefined values, use an interpolation technique
% patch_size = [7, 8, 9, 10];
% subplot_size = sqrt(length(patch_size));
% 
% for i = 1 : length(patch_size)
%     depth_image = find_depth(left_image, right_image, patch_size(i), "SAD", 24);
% 
%     new_depth_image = interpolation(depth_image, "cubic");
%     
%     title_string = sprintf("Patch Size %d", patch_size(i));
%     subplot(subplot_size, subplot_size, i), imshow(new_depth_image), colormap('jet');
%     colorbar;
%     title(title_string);
% end

% Compare nearest-neighbor, linear, and cubic
% depth_image = find_depth(left_image, right_image, 8, "SAD", 24);
% 
% depth_image_linear = interpolation(depth_image, "linear");
% depth_image_nearest = interpolation(depth_image, "nearest");
% depth_image_cubic = interpolation(depth_image, "cubic");
% 
% figure(1);
% subplot 131, imshow(depth_image_linear), colormap('jet'); colorbar; title("Linear Interpolation");
% subplot 132, imshow(depth_image_nearest), colormap('jet'); colorbar; title("Nearest Interpolation");
% subplot 133, imshow(depth_image_cubic), colormap('jet'); colorbar; title("Cubic Interpolation");


%% Parse in SAD or SSD
% SAD
% depth_image_SAD = find_depth(left_image, right_image, 8, "SAD", 24);
% depth_image_SAD = interpolation(depth_image_SAD, "cubic");
% 
% figure(2);
% subplot 121, imshow(depth_image_SAD), colormap('jet'), colorbar;
% title("Sum of Absolute Difference");

% SSD
% depth_image_SSD = find_depth(left_image, right_image, 8, "SSD", 24);
% depth_image_SSD = interpolation(depth_image_SSD, "cubic");
% 
% subplot 122, imshow(depth_image_SSD), colormap('jet'), colorbar;
% title("Sum of Square Difference");


%% Best Result
% depth_image = find_depth(left_image, right_image, 8, "SAD", 24);
% depth_image = interpolation(depth_image, "cubic");
% figure(3);
% subplot 121, imshow(depth_image), title("Depth Image");
% subplot 122, imshow(left_image), title("Original Image");
% 
% depth_image = find_depth(left_image, right_image, 8, "SSD", 24);
% depth_image = interpolation(depth_image, "cubic");
% figure(4);
% subplot 121, imshow(depth_image), title("Depth Image");
% subplot 122, imshow(left_image), title("Original Image");


%% 1.2 Dynamic Programming
% Different patch size (SAD)
patch_size = [6, 8, 10, 11];
subplot_size = sqrt(length(patch_size));

figure(5);
for i = 1 : length(patch_size)
    depth_image = dp_find_depth(left_image, right_image, patch_size(i), 24, 0.1, "SAD");

    
    title_string = sprintf("Patch Size %d", patch_size(i));
    subplot(subplot_size, subplot_size, i), imagesc(depth_image), colormap('jet'), colorbar;
    title(title_string);
end

% Different patch size (SSD)
patch_size = [6, 8, 10, 11];
subplot_size = sqrt(length(patch_size));

figure(6);
for i = 1 : length(patch_size)
    depth_image = dp_find_depth(left_image, right_image, patch_size(i), 24, 0.1, "SAD");

    
    title_string = sprintf("Patch Size %d", patch_size(i));
    subplot(subplot_size, subplot_size, i), imagesc(depth_image), colormap('jet'), colorbar;
    title(title_string);
end

% Different occlusion cost
occlusion_cost = [0.00001, 0.1, 1, 10];
subplot_size = sqrt(length(occlusion_cost));

figure(7);
for i = 1 : length(occlusion_cost)
    depth_image = dp_find_depth(left_image, right_image, 8, 24, occlusion_cost(i), "SAD");
    
    title_string = sprintf("Occlusion Cost %d", occlusion_cost(i));
    subplot(subplot_size, subplot_size, i), imagesc(depth_image), colormap('jet'), colorbar;
    title(title_string);
end