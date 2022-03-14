function depth_image = find_depth(image_l, image_r, filter_size, diff_method, threshold)
    half_filter = fix(filter_size / 2);
    pad_image_l = padarray(image_l, [half_filter, half_filter], "replicate", "both");
    pad_image_r = padarray(image_r, [half_filter, half_filter], "replicate", "both");

    pad_image_size = size(pad_image_l);
    row_points = zeros(2, pad_image_size(2)-2 * half_filter);
    depth_image = Inf(pad_image_size(1), pad_image_size(2));

    process_bar = waitbar(0, "Finding Image Depth ...");

    for i = half_filter+1 : pad_image_size(1)-half_filter
        for j = half_filter+1 : pad_image_size(2)-half_filter
            left_image_window = pad_image_l(i-half_filter:i+half_filter, j-half_filter:j+half_filter, :);

            for k = half_filter+1 : pad_image_size(2)-half_filter
                row_points(1, k - half_filter) = k - j;
                right_image_window = pad_image_r(i-half_filter:i+half_filter, k-half_filter:k+half_filter, :);

                % Sum of Absolute Difference or Sum of Square Difference
                if diff_method == "SAD"
                    row_points(2, k - half_filter) = sum(abs(right_image_window - left_image_window), "all");
        
                elseif diff_method == "SSD"
                    row_points(2, k - half_filter) = sum((right_image_window - left_image_window) .^ 2, "all");
                end
            end

            x = row_points(1, :);
            y = row_points(2, :);

            [~, minIdx] = min(y);
            minDelta = x(minIdx);

            % Customize condition to specified undefined pixels
            if minDelta <= 0 && minDelta >= -threshold
                depth_image(i - half_filter, j - half_filter) = abs(minDelta) / threshold;
            end
        end

        waitbar(i / (pad_image_size(1) - half_filter), process_bar)
    end

    depth_image = depth_image(1:pad_image_size(1)-2*half_filter, ...
        1:pad_image_size(2)-2*half_filter);

    close(process_bar)
end