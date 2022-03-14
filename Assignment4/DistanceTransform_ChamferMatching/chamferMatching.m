function [output, min] = chamferMatching(image, templateImage)
   grayImage = rgb2gray(image);
   edgeImage = edge(grayImage, "canny");

   dtImage = bwdist(edgeImage, "E");

   fixX = 0;
   fixY = 0;
   [templateRows, templateCols] = size(templateImage);
   [dtRows, dtCols] = size(dtImage);
   
   total = sum(templateImage, 'all');
   
   min = Inf;

   for i = 0: dtRows-templateRows
       for j = 0: dtCols-templateCols
           temp = zeros(dtRows, dtCols);
           temp(i+1 : i + templateRows, j+1 : j+templateCols) = templateImage;

           temp = temp .* dtImage;

           avg_sum = sum(temp, 'all')/ total;

           if avg_sum < min
               min = avg_sum;
               fitX = i+1;
               fitY = j+1;
           end
       end
   end
   
   best = zeros(dtRows, dtCols);
   best(fitX : fitX+templateRows-1, fitY: fitY+templateCols-1) = templateImage;

   non_zeros_indices = find(best);

   R = image(:,:,1);
   R(non_zeros_indices) = 0;
   G = image(:,:,2);
   G(non_zeros_indices) = 255;
   B = image(:,:,3);
   B(non_zeros_indices) = 0;

   output = cat(3, R,G,B);
end