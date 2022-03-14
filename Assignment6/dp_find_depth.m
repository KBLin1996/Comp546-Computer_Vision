function depth_image = dp_find_depth(left_image, right_image, patch_size, search_size, occ_cost, method)
    % Turn image into grayscale
    gray_left = rgb2gray(left_image);
    gray_right = rgb2gray(right_image);
    
    [gray_row, gray_col] = size(gray_left);
    
    process_bar = waitbar(0, "Finding Image Depth with Dynamic Programming ...");
    depth_image = zeros(gray_row, gray_col);
    half_patch_size = fix(patch_size / 2);
    
    for i = 1 + half_patch_size : gray_row - half_patch_size
        left_window = gray_left(i - half_patch_size : i + half_patch_size, :);
        right_window = gray_right(i - half_patch_size : i + half_patch_size, :);

        [row_window, col_window] = size(left_window);
        offset = zeros(1, col_window);

        patch_size_diff = (col_window - row_window + 1);
        match_map = zeros(patch_size_diff - search_size, gray_col - patch_size);
        
        for col= 1: patch_size_diff - search_size
            for row = col: min(patch_size_diff, col + search_size)
                if method == "SAD"
                    match_map(col, row) = sum(abs(right_window(:, col : col + row_window - 1) - ...
                        left_window(:, row : row + row_window - 1)), 'all');
                elseif method == "SSD"
                    match_map(col, row) = sum((right_window(:, col : col + row_window - 1) - ...
                        left_window(:, row : row + row_window - 1)) .^ 2, 'all');
                end
            end
        end

        match_map(match_map == 0) = Inf;
        
        [match_row, match_col] = size(match_map);
        for row = 2 : match_row
            for col = row : min(col_window, row + search_size)
                match_map(row, col) = match_map(row, col) + min(match_map(row-1,:)+ ...
                    occ_cost * abs((1 : match_col) - col + 1));
            end
        end
        
        for j = match_row : -1 : 1
            [~, min_idx] = min(match_map(j,:));
            offset(1, j) = min_idx - j;
        end
        
        depth_image(i,:) = offset;
        waitbar(i / (gray_row - half_patch_size), process_bar)
    end
    
    close(process_bar)
end