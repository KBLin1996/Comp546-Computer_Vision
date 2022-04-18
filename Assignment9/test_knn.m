function confusion_matrix = test_knn(centers, class_image_cnt, descriptors, ...
                                                             train_cluster_frequency, threshold, cluster_cnt)
    % KMeans clustering for each testing image
    prev_class_cnt = 0;
    cluster_frequency = zeros(1, cluster_cnt);
    confusion_matrix = zeros(length(class_image_cnt));
    
    for class_idx = 1 : length(class_image_cnt)
        for image_idx = prev_class_cnt + 1 : class_image_cnt(class_idx)
            [idx, descriptors_dist] = knnsearch(centers, descriptors{image_idx});
            
            % Threshold algorithm
            max_idx = max(idx);
            min_idx = min(idx);
            for i = min_idx : max_idx
                index = find(idx == i);

                if ~isempty(index)
                    dist_threshold = threshold * max(descriptors_dist(index));
                    filtered_index = descriptors_dist(index) > dist_threshold;
                    index = index .* filtered_index;
                    index = index(index <= 0);
                    cluster_frequency(i) = length(index);
                end
            end
       
            bin_cnt = sum(cluster_frequency, 2);
            if bin_cnt ~= 0
                cluster_frequency = cluster_frequency ./ bin_cnt;
            end
    
            % Record classify result to confusion matrix
            [classify_idx, ~] = knnsearch(train_cluster_frequency, cluster_frequency);
            confusion_matrix(class_idx, classify_idx) = confusion_matrix(class_idx, classify_idx) + 1;
        end
    
        prev_class_cnt = class_image_cnt(class_idx);
    end
end