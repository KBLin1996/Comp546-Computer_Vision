clear, clc;

%% a
camera = im2double(imread("cameraman.tiff"));
noise_camera = im2double(imread("cameraman_noisy.tiff"));

dx_filter = [-1 0 1; -2 0 2; -1 0 1];
dy_filter = [1 2 1; 0 0 0; -1 -2 -1];

% Apply zero-padding on camera and noise_camera
camera = padarray(camera, [1, 1], 0, 'both');
noise_camera = padarray(noise_camera, [1, 1], 0, 'both');
camera_x = camera;
camera_y = camera;
noise_camera_x = noise_camera;
noise_camera_y = noise_camera;

[row_1, col_1] = size(camera);
for i = 1:row_1 - 2
    for j = 1:col_1 - 2
        camera_x(i, j) = sum(sum(camera(i:i+2, j:j+2) .* dx_filter));
    end
end

for i = 1:row_1 - 2
    for j = 1:col_1 - 2
        camera_y(i, j) = sum(sum(camera(i:i+2, j:j+2) .* dy_filter));
    end
end

[row_2, col_2] = size(noise_camera);
for i = 1:row_2 - 2
    for j = 1:col_2 - 2
        noise_camera_x(i, j) = sum(sum(noise_camera(i:i+2, j:j+2) .* dx_filter));
    end
end

for i = 1:row_2 - 2
    for j = 1:col_2 - 2
        noise_camera_y(i, j) = sum(sum(noise_camera(i:i+2, j:j+2) .* dy_filter));
    end
end

%subplot 121, imshow(camera_x); title('cameraman.tiff on Dx')
%subplot 122, imshow(camera_y); title('cameraman.tiff on Dy')
%subplot 121, imshow(noise_camera_x); title('cameraman noisy.tiff on Dx')
%subplot 122, imshow(noise_camera_y); title('cameraman noisy.tiff on Dy')


% magnitude
camera_mag = sqrt(camera_x .* camera_x + camera_y .* camera_y);
noise_camera_mag = sqrt(noise_camera_x .* noise_camera_x + noise_camera_y .* noise_camera_y);

%subplot 121, imshow(camera_mag); title('cameraman.tiff magnitude')
%subplot 122, imshow(noise_camera_mag); title('cameraman noisy.tiff magnitude')

camera_dir = atan2(camera_y, camera_x);
noise_camera_dir = atan2(noise_camera_y, noise_camera_x);

%subplot 121, imshow(camera_dir); title('cameraman.tiff direction')
%subplot 122, imshow(noise_camera_dir); title('cameraman noisy.tiff direction')


camera_deg = rad2deg(camera_dir);
index_big_180 = find(mod(camera_deg + 360, 360) >= 180);
index_small_180 = find(mod(camera_deg + 360, 360) < 180);

camera_deg(index_big_180) = mod(camera_deg(index_big_180) + 360, 360) - 180;
camera_deg(index_small_180) = mod(camera_deg(index_small_180) + 360, 360);

noise_camera_deg = rad2deg(noise_camera_dir);
index_big_180 = find(mod(noise_camera_deg + 360, 360) >= 180);
index_small_180 = find(mod(noise_camera_deg + 360, 360) < 180);

noise_camera_deg(index_big_180) = mod(noise_camera_deg(index_big_180) + 360, 360) - 180;
noise_camera_deg(index_small_180) = mod(noise_camera_deg(index_small_180) + 360, 360);


camera_color = cat(3, camera_mag, camera_mag, camera_mag);
noise_camera_color = cat(3, noise_camera_mag, noise_camera_mag, noise_camera_mag);

[camera_deg, camera_color] = get_dir_color(camera_deg, camera_color);
[noise_camera_deg, noise_camera_color] = get_dir_color(noise_camera_deg, noise_camera_color);

%subplot 121, imshow(camera_color); title('cameraman.tiff color')
%subplot 122, imshow(noise_camera_color); title('cameraman noisy.tiff color')

camera_rad = deg2rad(camera_deg);
noise_camera_rad = deg2rad(noise_camera_deg);

%subplot 121, imshow(camera_rad); title('cameraman.tiff rounding')
%subplot 122, imshow(noise_camera_rad); title('cameraman noisy.tiff rounding')



%% b
camera = im2double(imread("cameraman.tiff"));
noise_camera = im2double(imread("cameraman_noisy.tiff"));
filter = [2 4 5 4 2; 4 9 12 9 4; 5 12 15 12 5; 4 9 12 9 4; 2 4 5 4 2] / 159;

% % Apply zero-padding on camera and noise_camera
camera = padarray(camera, [2, 2], 0, 'both');
noise_camera = padarray(noise_camera, [2, 2], 0, 'both');
 
for i = 1:size(camera, 1) - 4
    for j = 1:size(camera, 2) - 4
        camera(i, j) = sum(sum(camera(i:i+4, j:j+4) .* filter));
    end
end

for i = 1:size(noise_camera, 1) - 4
    for j = 1:size(noise_camera, 2) - 4
        noise_camera(i, j) = sum(sum(noise_camera(i:i+4, j:j+4) .* filter));
    end
end


for i = 1:size(camera, 1) - 2
    for j = 1:size(camera, 2) - 2
        camera_x(i, j) = sum(sum(camera(i:i+2, j:j+2) .* dx_filter));
    end
end

for i = 1:size(camera, 1) - 2
    for j = 1:size(camera, 2) - 2
        camera_y(i, j) = sum(sum(camera(i:i+2, j:j+2) .* dy_filter));
    end
end

for i = 1:size(noise_camera, 1) - 2
    for j = 1:size(noise_camera, 2) - 2
        noise_camera_x(i, j) = sum(sum(noise_camera(i:i+2, j:j+2) .* dx_filter));
    end
end

for i = 1:size(noise_camera, 1) - 2
    for j = 1:size(noise_camera, 2) - 2
        noise_camera_y(i, j) = sum(sum(noise_camera(i:i+2, j:j+2) .* dy_filter));
    end
end

%subplot 121, imshow(camera_x); title('cameraman.tiff on Dx')
%subplot 122, imshow(camera_y); title('cameraman.tiff on Dy')
%subplot 121, imshow(noise_camera_x); title('cameraman noisy.tiff on Dx')
%subplot 122, imshow(noise_camera_y); title('cameraman noisy.tiff on Dy')


% magnitude
camera_mag_b = sqrt(camera_x .* camera_x + camera_y .* camera_y);
noise_camera_mag_b = sqrt(noise_camera_x .* noise_camera_x + noise_camera_y .* noise_camera_y);

%subplot 121, imshow(camera_mag); title('cameraman.tiff magnitude')
%subplot 122, imshow(noise_camera_mag); title('cameraman noisy.tiff magnitude')

camera_dir = atan2(camera_y, camera_x);
noise_camera_dir = atan2(noise_camera_y, noise_camera_x);

%subplot 121, imshow(camera_dir); title('cameraman.tiff direction')
%subplot 122, imshow(noise_camera_dir); title('cameraman noisy.tiff direction')


camera_deg_b = rad2deg(camera_dir);
index_big_180 = find(mod(camera_deg_b + 360, 360) >= 180);
index_small_180 = find(mod(camera_deg_b + 360, 360) < 180);

camera_deg_b(index_big_180) = mod(camera_deg_b(index_big_180) + 360, 360) - 180;
camera_deg_b(index_small_180) = mod(camera_deg_b(index_small_180) + 360, 360);

noise_camera_deg_b = rad2deg(noise_camera_dir);
index_big_180 = find(mod(noise_camera_deg_b + 360, 360) >= 180);
index_small_180 = find(mod(noise_camera_deg_b + 360, 360) < 180);

noise_camera_deg_b(index_big_180) = mod(noise_camera_deg_b(index_big_180) + 360, 360) - 180;
noise_camera_deg_b(index_small_180) = mod(noise_camera_deg_b(index_small_180) + 360, 360);


camera_color_b = cat(3, camera_mag_b, camera_mag_b, camera_mag_b);
noise_camera_color_b = cat(3, noise_camera_mag_b, noise_camera_mag_b, noise_camera_mag_b);

[camera_deg_b, camera_color_b] = get_dir_color(camera_deg_b, camera_color_b);
[noise_camera_deg_b, noise_camera_color_b] = get_dir_color(noise_camera_deg_b, noise_camera_color_b);

%subplot 121, imshow(camera_color_b); title('cameraman.tiff color')
%subplot 122, imshow(noise_camera_color_b); title('cameraman noisy.tiff color')

% Compare with session a
%subplot 121, imshow(noise_camera_color); title('color before filtering')
%subplot 122, imshow(noise_camera_color_b); title('color after filtering')

camera_rad_b = deg2rad(camera_deg_b);
noise_camera_rad_b = deg2rad(noise_camera_deg_b);

%subplot 121, imshow(camera_rad_b); title('cameraman.tiff rounding')
%subplot 122, imshow(noise_camera_rad_b); title('cameraman noisy.tiff rounding')



%% c
% Non-Maximum Suppression

% On pictures in session (a)
camera_NMS = NMS(camera_deg, camera_mag) .* camera_mag;
noise_camera_NMS = NMS(noise_camera_deg, noise_camera_mag) .* noise_camera_mag;

%subplot 121, imshow(camera_mag); title('cameraman.tiff magnitude')
%subplot 122, imshow(camera_NMS); title('cameraman.tiff NMS')

%subplot 121, imshow(noise_camera_mag); title('cameraman noisy.tiff magnitude')
%subplot 122, imshow(noise_camera_NMS); title('cameraman noisy.tiff NMS')


% On pictures in session (b)
camera_NMS_b = NMS(camera_deg_b, camera_mag_b) .* camera_mag_b;
noise_camera_NMS_b = NMS(noise_camera_deg_b, noise_camera_mag_b) .* noise_camera_mag_b;

%subplot 121, imshow(camera_mag_b); title('cameraman b.tiff magnitude')
%subplot 122, imshow(camera_NMS_b); title('cameraman b.tiff NMS')

%subplot 121, imshow(noise_camera_mag_b); title('cameraman noisy.tiff magnitude')
%subplot 122, imshow(noise_camera_NMS_b); title('cameraman noisy.tiff NMS')



%% d

% Hysteresis Thresholding
% image in a
camera_HT = Hysteresis_Threshold(camera_NMS, 0.07, 0.1);
noise_camera_HT = Hysteresis_Threshold(noise_camera_NMS, 0.07, 0.1);

%subplot 121, imshow(camera_HT); title('cameraman.tiff HT')
%subplot 122, imshow(noise_camera_HT); title('cameraman noise.tiff HT')


% image in b
camera_HT_b = Hysteresis_Threshold(camera_NMS_b, 0.02, 0.045);
noise_camera_HT_b = Hysteresis_Threshold(camera_NMS_b, 0.02, 0.045);

%subplot 121, imshow(camera_HT_b); title('cameraman.tiff HT')
%subplot 122, imshow(noise_camera_HT_b); title('cameraman noise.tiff HT')



%% Hybrid Images
graduate = im2double(imread("KB_graduate.JPG"));
KB = im2double(imread("KB.jpg"));

KB = imresize(KB, [size(graduate, 1), size(graduate, 2)]);


sigma = 6;

filter = fspecial('Gaussian', sigma * 4 + 1, sigma);

high_pass_KB = KB - imfilter(KB, filter);
low_pass_graduate = imfilter(graduate, filter);

%subplot 121, imshow(high_pass_KB + 0.3); title('cameraman.tiff HT')
%subplot 122, imshow(low_pass_graduate); title('cameraman noise.tiff HT')

hybrid_image = high_pass_KB + low_pass_graduate;

imshow(hybrid_image)