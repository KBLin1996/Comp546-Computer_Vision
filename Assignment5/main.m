clear, clc;
%% Implementation - Harris Corner Detection
chessImage = im2double(imread("chessboard.jpg"));

% HarrisCornerDetection => HarrisCornerDetection(image, sigma, threshold, displayImage)
%HarrisCornerDetection(chessImage, 2, 0.003, chessImage);


%% Rotate the chessboard image by 30 deg and apply your function
rotateImage = imrotate(chessImage, 30);

% Change the black background to white
whiteRotateImage = rotateImage;
blackIdx = find(rotateImage == 0);
whiteRotateImage(blackIdx) = 255;

%HarrisCornerDetection(whiteRotateImage, 4.75, 0.00315, rotateImage);


%% Resize the chessboard image by 4 times on both axes and apply your function
largeImage = imresize(chessImage, 4, "bicubic");
HarrisCornerDetection(largeImage, 8, 0.0004, largeImage);