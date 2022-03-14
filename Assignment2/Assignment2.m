%% Part 1
%% Exercise 1
original_image = imread("IronMan.jpg");

% See Pixel Info
%
% imshow(original_image);
% axis on     % show axis
% impixelinfo; 
% [x,y] = ginput(4);
%

crop_head = original_image(3:211, 469:613, :);
%imshow(crop_head)
% Save the image
imwrite(crop_head, 'head.png');

% Display green conponent of head
green_head = crop_head(:, :, 2);
%imshow(green_head)

% Transpose channel to (G, R, B)
red_image = original_image(:, :, 1);
green_image = original_image(:, :, 2);
blue_image = original_image(:, :, 3);

transpose_image = cat(3, green_image, red_image, blue_image);
%imshow(transpose_image)


%% Exercise 2
original_image = imread("barbara.jpg");

gray_image = rgb2gray(original_image);
%imshow(gray_image)

% Plot a histogram of the gray scale image with bin-size of 5 in intensity
%histogram(gray_image, 'BinWidth', 5);

% Blur the gray scale image by using Gaussian filters of size 15 × 15 with standard deviations 2 and 8
gauss_filt_1 = fspecial('gaussian', 15, 2); 
gauss_filt_2 = fspecial('gaussian', 15, 8); 

conv_image_1 = imfilter(gray_image, gauss_filt_1, 'symmetric'); 
conv_image_2 = imfilter(gray_image, gauss_filt_2, 'symmetric'); 

%subplot 131, imshow(gray_image); title('Grayscale Image')
%subplot 132, imshow(conv_image_1); title('Gaussian Filter Standard Dev = 2')
%subplot 133, imshow(conv_image_2); title('Gaussian Filter Standard Dev = 8') 


% Plot histograms for the blurred images
%subplot 131, histogram(gray_image, 'BinWidth', 5); title('Grayscale Histo')
%subplot 132, histogram(conv_image_1, 'BinWidth', 5); title('Gaussian Standard Dev = 2 Histo')
%subplot 133, histogram(conv_image_2, 'BinWidth', 5); title('Gaussian Standard Dev = 8 Histo')


% Subtract the blurred image obtained using the filter with standard deviation of 2 from the original gray scale image 
sub_image = gray_image - conv_image_1;
%imshow(sub_image)


% Threshold the resultant image at 5% of its maximum pixel value.
thresh = double(max(max(sub_image))) * 0.05;

thresh_image = sub_image;

% k = find(X) returns a vector containing the linear indices of each nonzero element in array X
index_0 = find(sub_image <= thresh);
index_255 = find(sub_image > thresh);

thresh_image(index_0) =  0;
thresh_image(index_255) =  255;

%imshow(thresh_image)


%% Part 2
%% Filtering
I1 = [120 110 90 115 40; 145 135 135 65 35; 125 115 55 35 25; 80 45 45 20 15; 40 35 25 10 10];
I2 = [125 130 135 110 125; 145 135 135 155 125; 65 60 55 45 40; 40 35 40 25 15; 15 15 20 15 10];

matrix1_1 = I1;
matrix2_1 = I1;
matrix3_1 = I1;

matrix1_2 = I2;
matrix2_2 = I2;
matrix3_2 = I2;

% Apply zero-padding on I1 and I2
I1 = padarray(I1, [1, 1], 0, 'both');
I2 = padarray(I2, [1, 1], 0, 'both');

filter1 = [1 1 1] / 3;
filter2 = [1; 1; 1] / 3;
filter3 = [1 1 1; 1 1 1; 1 1 1] / 9;

[row_1, col_1] = size(I1);


% filter1 on I1
for i = 2:row_1 - 1
    for j = 1:col_1 - 2
        matrix1_1(i-1, j) = I1(i, j:j+2) * transpose(filter1);
    end
end

% filter2 on I1
for i = 1:row_1 - 2
    for j = 2:col_1 - 1
        matrix2_1(i, j-1) = transpose(I1(i:i+2, j)) * filter2;
    end
end

% % filter3 on I1
for i = 1:row_1 - 2
    for j = 1:col_1 - 2
        matrix3_1(i, j) = sum(sum(I1(i:i+2, j:j+2) .* filter3));
    end
end


[row_2, col_2] = size(I2);

% filter1 on I2
for i = 2:row_2 - 1
    for j = 1:col_2 - 2
        matrix1_2(i-1, j) = I2(i, j:j+2) * transpose(filter1);
    end
end

% filter2 on I2
for i = 1:row_2 - 2
    for j = 2:col_2 - 1
        matrix2_2(i, j-1) = transpose(I2(i:i+2, j)) * filter2;
    end
end

% filter3 on I2
for i = 1:row_2 - 2
    for j = 1:col_2 - 2
        matrix3_2(i, j) = sum(sum(I2(i:i+2, j:j+2) .* filter3));
    end
end


% Apply following filters on the gray scale image of barbara from Part I
original_image = imread("barbara.jpg");

gray_image = rgb2gray(original_image);
[row, col] = size(gray_image);


% central difference gradient filter
gray_image = double(gray_image) / 255;
x_filter = [-1, 0, 1] / 2;
x_image = imfilter(gray_image, x_filter, 'replicate');

y_filter = [-1; 0; 1] / 2;
y_image = imfilter(gray_image, y_filter, 'replicate');

gradient_image = sqrt(x_image .^ 2 + y_image .^ 2);
%imshow(gradient_image)


% sobel filter
sobel_filter = fspecial('sobel');
sobel_image = imfilter(gray_image, sobel_filter, 'symmetric'); 
%imshow(sobel_image)


% mean filter
mean_filter = fspecial('average');
mean_image = imfilter(gray_image, mean_filter, 'symmetric'); 
%imshow(mean_image)


% median filter
median_image = medfilt2(gray_image);
%imshow(median_image)


%% Smoothing
noisy_image = imread("camera_man_noisy.png");
%imshow(noisy_image)

% Averaging filters of sizes 2×2,4×4,8×8,16×16
average_2 = fspecial("average", 2);
avg2_image = imfilter(noisy_image, average_2, "symmetric");

average_4 = fspecial("average", 4);
avg4_image = imfilter(noisy_image, average_4, "symmetric");

average_8 = fspecial("average", 8);
avg8_image = imfilter(noisy_image, average_8, "symmetric");

average_16 = fspecial("average", 16);
avg16_image = imfilter(noisy_image, average_16, "symmetric");

% subplot 241, imshow(avg2_image); title('Average 2x2')
% subplot 242, imshow(avg4_image); title('Average 4x4')
% subplot 243, imshow(avg8_image); title('Average 8x8') 
% subplot 244, imshow(avg16_image); title('Average 16x16') 


% Gaussian filter of standard deviations 2, 4, 8, 16
% A good choice of gaussian filter size is 4 times its standard deviation
% to include most of the variability within the box
dev_2 = fspecial("gaussian", 8, 2);
dev2_image = imfilter(noisy_image, dev_2, "symmetric");

dev_4 = fspecial("gaussian",16, 4);
dev4_image = imfilter(noisy_image, dev_4, "symmetric");

dev_8 = fspecial("gaussian", 32, 8);
dev8_image = imfilter(noisy_image, dev_8, "symmetric");

dev_16 = fspecial("gaussian",64, 16);
dev16_image = imfilter(noisy_image, dev_16, "symmetric");

% subplot 241, imshow(dev2_image); title('Standard Dev 2, Size 8')
% subplot 242, imshow(dev4_image); title('Standard Dev 4, Size 16')
% subplot 243, imshow(dev8_image); title('Standard Dev 8, Size 32') 
% subplot 244, imshow(dev16_image); title('Standard Dev 16, Size 64') 


%% Graduate Credit
% A bilateral filter is an edge-preserving smoothing filter
noisy_image = double(imread("camera_man_noisy.png")) / 255;
% noisy_image = noisy_image + 0.03 * randn(size(noisy_image));
% noisy_image(noisy_image < 0) = 0;
% noisy_image(noisy_image > 1) = 1;


w = 5;
sigma = [5, 0.23];

bilateral_image = bfilter2(noisy_image, w, sigma);

w = 5;
sigma = [5, 0.23];

bilateral_image = bfilter2(noisy_image, w, sigma);

w = 5;
sigma = [5, 0.33];
bilateral_image_4 = bfilter2(noisy_image, w, sigma);

subplot 121, imshow(bilateral_image); title('Bilateral Image (intensity standard dev=0.23)')
subplot 122, imshow(bilateral_image_4); title('Bilateral Image (intensity standard dev=0.33)')










