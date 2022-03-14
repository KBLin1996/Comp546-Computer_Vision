clear, clc;

cowImage = im2double(imread("cow.png"));

grayCow = rgb2gray(cowImage);

edgeCow = edge(grayCow,'Canny');
imshow(edgeCow);
edgeCow = im2double(edgeCow);

distTrans = L1DisTransform(edgeCow);
distImg = mat2gray(distTrans);
figure
imshow(distImg)


% find distance transforms with bwdist()
eucDis = bwdist(edgeCow, "euclidean");
cityDis = bwdist(edgeCow, "cityblock");
chessDis = bwdist(edgeCow, "chessboard");
quasiDis = bwdist(edgeCow, "quasi-euclidean");

% Turn matrix into grayscale (binary form) image
eucImage = mat2gray(eucDis);
cityImage = mat2gray(cityDis);
chessImage = mat2gray(chessDis);
quasiImage = mat2gray(quasiDis);

figure()
subplot(2,2,1), imshow(eucImage), title('Euclidean')
subplot(2,2,2), imshow(cityImage), title('Cityblock')
subplot(2,2,3), imshow(chessImage), title('Chessboard')
subplot(2,2,4), imshow(quasiImage), title('Quasi-Euclidean')

figure()
subplot(2,2,1), imshow(eucImage), title('Euclidean')
hold on, imcontour(eucDis)
subplot(2,2,2), imshow(cityImage), title('Cityblock')
hold on, imcontour(cityDis)
subplot(2,2,3), imshow(chessImage), title('Chessboard')
hold on, imcontour(chessDis)
subplot(2,2,4), imshow(quasiImage), title('Quasi-Euclidean')
hold on, imcontour(quasiDis)


%% 2.2. Chamfer Matching
cowImage = im2double(imread("DistanceTransform_ChamferMatching/cow.png"));
tempImage = im2double(imread("DistanceTransform_ChamferMatching/template.png"));

[result, minDist] = chamferMatching(cowImage, tempImage);
figure();
imshow(result);

% grayImage = rgb2gray(cowImage);
% grayImage = edge(grayImage, "canny");
% transImage = bwdist(grayImage, "chessboard");

% figure();
% output = mat2gray(transImage);
% output(result) = 1;
% imshow(output);


%% Chamfer Matching Function
function [result, minDist] = chamferMatching(image, tempImage)
    grayImage = rgb2gray(image);
    grayImage = edge(grayImage, "canny");

    transImage = bwdist(grayImage, "chessboard");

    bestFitX = 0;
    bestFitY = 0;
    [tRow, tCol] = size(tempImage);
    [TRow, TCol] = size(transImage);
    total = sum(sum(tempImage));
    minDist = total;

    for i = 0 : TRow-tRow
        for j = 0 : TCol-tCol
            temp = zeros(TRow, TCol);
            temp(i+1 : i+tRow, j+1 : j+tCol) = tempImage;
            temp = temp .* transImage;
            
            dist = sum(sum(temp)) / total;

            if dist < minDist
                minDist = dist;
                bestFitX = i+1;
                bestFitY = j+1;
            end
        end
    end

    bestFit = zeros(TRow,TCol);
    bestFit(bestFitX : bestFitX+tRow-1, bestFitY : bestFitY+tCol-1) = tempImage;
    
    % Get non-zero indices
    k = find(bestFit);

%     result = k;

    R = image(:, :, 1);
    R(k) = 1;
    G = image(:, :, 2);
    G(k) = 0;
    B = image(:, :, 3);
    B(k) = 0;
    result = cat(3, R, G, B); 
end