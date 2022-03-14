clc, clear;

%% Load buddha images
num_images = 12;
image_category = "buddha";

for i = 1:num_images
    
    read_img = imread("../psmImages/" + image_category + "/" + image_category + "." + (i-1) + ".png"); 
    
    images(:, :, :, i) = read_img;
    subplot(4, 3, i), imshow(images(:,:,:,i));
end
sgtitle("12 " + image_category + " Images");

[n, m, ~] = size(images(:,:,:,1));


%% Load the buddha mask
mask_image = imread("../psmImages/" + image_category + "/" + image_category + ".mask.png");

figure(2);
imshow(mask_image); title("The " + image_category + " Mask");


%% 1. Albedo RGB channels

% Load light direction (lighting.mat)
light = load('lighting.mat').L;

albedo_R = albedo(images, mask_image, light, 1);
albedo_G = albedo(images, mask_image, light, 2);
albedo_B = albedo(images, mask_image, light, 3);


figure(3);
subplot 131, imshow(albedo_R); title("R channel of the albedo");
subplot 132, imshow(albedo_G); title("G channel of the albedo");
subplot 133, imshow(albedo_B); title("B channel of the albedo");


%% 2. Normal map
normal = surface_normal(images, mask_image, light);
figure(4);
imshow(normal);

p = normal(:, :, 1) ./ normal(:, :, 3);
q = normal(:, :, 2) ./ normal(:, :, 3);

mask_p = find(isnan(p) == 1);
mask_q = find(isnan(q) == 1);

p(mask_p) = 0;
q(mask_q) = 0;

% quiver() => Surface normal vectors computed from grayscale input
figure(5);
quiver(1:5:m, 1:5:n, p(1:5:end, 1:5:end), q(1:5:end, 1:5:end), 6);
axis ij tight;
axis off;


%% 3. Recovered depth map using the direct integration of the surface normal vectors
depth_image = zeros(n, m);

for i = 2:n
    depth_image(i, 1) = depth_image(i-1, 1) + q(i, 1);
end

for i = 1:n
    for j = 2:m
        depth_image(i, j) = depth_image(i, j-1)+p(i, j);
    end
end

figure(6);
surfl(-depth_image); shading interp; colormap gray; axis tight;
title("Negative depth_image");


%% 4. Refined depth map using the provided code
mask = rgb2gray(mask_image);
depth_image = refineDepthMap(normal, mask);

figure(7)
surfl(depth_image, 'light'); shading interp; colormap gray; axis tight;
colormap gray;
title("Positive depth_image");