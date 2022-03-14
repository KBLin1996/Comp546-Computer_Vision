clear, clc;

%% Part 1.1
lineData = load('LineData.mat');
x = lineData.x;
y = lineData.y;

%[inlierX, inlierY, iter] = RANSAC(x, y, 2, 0.32, true);


%% Part 1.2
affineData = load('AffineData.mat');
pointsOrig = affineData.orig_feature_pt;
pointsTrans = affineData.trans_feature_pt;

figure()
[inlierX, inlierY, iter] = RANSAC(pointsOrig, pointsTrans, 2, 360, false);

% randomly pick three indexes from the inliers
randomThreeIdx = randperm(length(inlierX), 3);

u1 = [inlierX(1, randomThreeIdx(1)) inlierX(2, randomThreeIdx(1))];
u2 = [inlierX(1, randomThreeIdx(2)) inlierX(2, randomThreeIdx(2))];
u3 = [inlierX(1, randomThreeIdx(3)) inlierX(2, randomThreeIdx(3))];

% A is a 6x6 matrix
A = [
    u1(1), u1(2), 1, 0, 0, 0;
    0, 0, 0, u1(1), u1(2), 1;
    u2(1), u2(2), 1, 0, 0, 0;
    0, 0, 0, u2(1), u2(2), 1;
    u3(1), u3(2), 1, 0, 0, 0;
    0, 0, 0, u3(1), u3(2), 1;
];

% matrix after transformation 6x1
B = [
    inlierY(1, randomThreeIdx(1));
    inlierY(2, randomThreeIdx(1));
    inlierY(1, randomThreeIdx(2));
    inlierY(2, randomThreeIdx(2));
    inlierY(1, randomThreeIdx(3));
    inlierY(2, randomThreeIdx(3));
];

% calculate affine matrix 6x1 => AX = B
X = linsolve(A, B);


% check on the image for result
originalImage = im2double(imread("castle_original.png"));
transformImage = im2double(imread("castle_transformed.png"));

transformMatrix = [
    X(1), X(4), 0;
    X(2), X(5), 0;
    X(3), X(6), 1;
];

tform = maketform('affine', transformMatrix);

imageSize = size(transformImage);
xData = [1 imageSize(2)];
yData = [1 imageSize(1)];
xyScale = [1 1];

resultImage = imtransform(originalImage, tform, 'Xdata', xData, 'Ydata', yData, 'XYScale', xyScale);

subplot 121, imshow(resultImage); title('Result After RANSAC')
subplot 122, imshow(transformImage); title('Transform Image')