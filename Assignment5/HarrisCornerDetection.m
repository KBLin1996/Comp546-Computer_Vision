function HarrisCornerDetection(image, sigma, threshold, displayImage)
    %% Cornerness Measure
    grayChessImage = rgb2gray(image);
    %figure(1)
    %imshow(grayChessImage), title("ChessBoard to GrayScale");
    
    
    % Central difference x-gradient and y-gradient filters
    xFilter = [-1 0 1] / 2;
    Ix = imfilter(grayChessImage, xFilter, 'replicate');
    
    yFilter = [-1; 0; 1] / 2;
    Iy = imfilter(grayChessImage, yFilter, 'replicate');
    
    %figure(2)
    %subplot 121; imshow(Ix), title("x-gradient Image");
    %subplot 122; imshow(Iy), title("y-gradient Image");
    
    
    % Ix^2, Iy^2, IxIy
    Ix2 = Ix .* Ix;
    Iy2 = Iy .* Iy;
    IxIy = Ix .* Iy;

    %figure(3)
    %subplot 131; imshow(Ix2), title("Ix2 Image");
    %subplot 132; imshow(Iy2), title("Iy2 Image");
    %subplot 133; imshow(IxIy), title("IxIy Image");
    
    %figure(3)
    %imshow(Ix2), title("Ix2 Image");
    %figure(4)
    %imshow(Iy2), title("Iy2 Image");
    %figure(5)
    %imshow(IxIy), title("IxIy Image");
    
    
    % Create a Gaussian smoothing filter using fspecial with a chosen standard
    % deviation σ and size 4σ (sigma is given as input parameter)
    h = fspecial('gaussian', 4 * sigma, sigma);
    
    
    % Apply the Gaussian filter to Ix2, Iy2 and IxIy using imfilter
    guaIx2 = imfilter(Ix2, h);
    guaIy2 = imfilter(Iy2, h);
    guaIxIy = imfilter(IxIy, h);
    
    %figure(6)
    %subplot 131; imshow(Ix2), title("Gaussian Ix2 Image");
    %subplot 132; imshow(Iy2), title("Guassian Iy2 Image");
    %subplot 133; imshow(IxIy), title("Guassian IxIy Image");
    
    
    % Compute the cornerness measure M
    det = guaIx2 .* guaIy2 - guaIxIy .* guaIxIy;
    trace = guaIx2 + guaIy2;
    
    M = det ./ (trace + eps);
    %figure(7);
    %imshow(M);
    
    
    
    %% Corner Extraction
    % % Applying non-maximal suppression on M
    B = ordfilt2(M, 9, ones(3,3));
    NMSFigure = (M == B) & (M > threshold);
    figure(8);
    imshow(NMSFigure);
    
    % Find the coordinates of the corner points (threshold given as input parameter)
    [row, col] = find((M == B) & (M > threshold));
    
    % Display the image and superimpose the corners
    %figure(9);
    %imshow(displayImage);
    
    %hold on;
    %plot(col, row, 'r*');
    %title('Harris Corner Detection');
end