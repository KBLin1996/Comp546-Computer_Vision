function image = L1DisTransform(image)
    [row, col] = size(image);

    % Change values to binary
    for i = 1 : row
        for j = 1 : col
            if image(i, j) == 0
                image(i, j) = Inf;
            else
                image(i, j) = 0;
            end
        end
    end
    

    % Forward pass
    for i = 2 : row
        for j = 2 : col
            image(i, j) = min([image(i, j), image(i, j-1) + 1, image(i-1, j) + 1, image(i-1, j-1) + 1]);
        end
    end
    
    % Backward pass
    for i = row-1 : -1 : 1
        for j = col-1 : -1 : 1
            image(i, j) = min([image(i,j), image(i, j+1) + 1, image(i+1,j) + 1, image(i+1, j+1) + 1]);
        end
    end


     % Deal with the last column
    for i = row-1 : -1 : 1
        if image(i, col) == Inf
            image(i, col) = image(i+1, col);
        end
    end

     % Deal with the last row
    for i = col-1 : -1 : 1
        if image(row, i) == Inf
            image(row, i) = image(row, i+1);
        end
    end

end