function row_points = point_correspondence(image_l, image_r, point, filter_size, diff_method)
    row = point(1);
    col = point(2);
    half_filter = fix(filter_size / 2);
    image_size = size(image_l);
    row_points = zeros(2, image_size(2) - 2 * half_filter);

    left_image_window = image_l(row, col-half_filter:col+half_filter, :);

    for i = half_filter+1 : image_size(2)-half_filter
        row_points(1, i - half_filter) = i - col;
        right_image_window = image_r(row, i-half_filter:i+half_filter, :);
            
        % Sum of Absolute Difference or Sum of Square Difference
        if diff_method == "SAD"
            row_points(2, i - half_filter) = sum(abs(right_image_window - left_image_window), "all");

        elseif diff_method == "SSD"
            row_points(2, i - half_filter) = sum((right_image_window - left_image_window) .^ 2, "all");
        end
    end
end