close all;
clear;
clc;

%% 2.1 Distance Transform
% load the cow image
cow_image = imread('cow.png');

% compute the canny edge map of the image
cow_gray_image = rgb2gray(cow_image);
canny_edge = edge(cow_gray_image, "canny");

figure(1);
subplot 121, imshow(cow_image), title("Original Cow Image");
subplot 122, imshow(canny_edge), title("Canny Edge Image");

% compute L1 distance transform of the image
%dt_image = myDistanceTransform(canny_edge);
%dt_image = mat2gray(dt_image);

%figure(2);
%subplot 121, imshow(canny_edge), title("Canny Edge Image");
%subplot 122, imshow(dt_image), title("Distance Transform Image");

% computer distance transform using bwdist


D1 = bwdist(canny_edge,'euclidean');
grayD1 = mat2gray(D1);

D2 = bwdist(canny_edge,'cityblock');
grayD2 = mat2gray(D2);

D3 = bwdist(canny_edge,'chessboard');
grayD3 = mat2gray(D3);

D4 = bwdist(canny_edge,'quasi-euclidean');
grayD4 = mat2gray(D4);

figure(3);
imshow(canny_edge);

figure(4);
subplot 221, imshow(grayD1), title("Euclidean Image");
subplot 222, imshow(grayD2), title("Cityblock Image");
subplot 223, imshow(grayD3), title("Chessboard Image");
subplot 224, imshow(grayD4), title("Quasi-Euclidean Image");


figure(5);
subplot 221, imshow(grayD1), hold on, imcontour(D1), title("Euclidean Image with contour");
subplot 222, imshow(grayD2), hold on, imcontour(D2), title("Cityblock Image with contour");
subplot 223, imshow(grayD3), hold on, imcontour(D3), title("Chessboard Image with contour");
subplot 224, imshow(grayD4), hold on, imcontour(D4), title("Quasi-Euclidean Image with contour");
% 
% %% Chamfer Matching
template_image = imread('template.png');
[output, min_distance] = chamferMatching(cow_image, template_image);

figure(6);
imshow(output)