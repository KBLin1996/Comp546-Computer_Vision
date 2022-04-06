function cluster_frequency = draw_hist(class_descriptors_cnt, cluster_cnt, ...
                                                                                      descriptors_to_cluster, descriptor_centroid_dist, ...
                                                                                      subfolder_names, threshold, normalize, draw_hist)
    class_cnt = 1;
    cluster_frequency = double(zeros(length(class_descriptors_cnt), cluster_cnt));

    prev_descriptor_cnt = 0;
    for descriptor_cnt = class_descriptors_cnt
        idx = descriptors_to_cluster(prev_descriptor_cnt + 1 : descriptor_cnt);
        dist = descriptor_centroid_dist(prev_descriptor_cnt + 1 : descriptor_cnt);
        
        max_idx = max(idx);
        for i = 1 : max_idx
            index = find(idx == i);

            if ~isempty(index)
                % Threshold algorithm (-1 means to skip the threshold algorithm)
                if threshold ~= -1
                    dist_threshold = threshold * median(dist(index));
                    filtered_index = dist(index) > dist_threshold;
                    index = index .* filtered_index;
                    index = index(index <= 0);
                end

                cluster_frequency(class_cnt, i) = length(index);
            end
        end

        class_cnt = class_cnt + 1;
        prev_descriptor_cnt = descriptor_cnt;
    end
    
    if normalize
        cnt = sum(cluster_frequency, 2);
        cluster_frequency = cluster_frequency ./ cnt;
    end

    if draw_hist
        for class_cnt = 1 : length(class_descriptors_cnt)
            % The size of BinCounts (length(cluster_frequency) must equal to the number
            % of BinEdges - 1 (length(BinEdges) - 1)
            edges = linspace(1, 1001, 1001);
            subplot(1, 3, class_cnt);
      
            histogram('BinEdges', edges, 'BinCounts', cluster_frequency(class_cnt, :));
        
            grid on;
            xlim([1 1000]);
            xlabel("Cluster Index", 'FontSize', 14);
            ylabel("Bin Counts (Frequency)", 'FontSize', 14);
            title(subfolder_names{class_cnt}, 'FontSize', 14);
        end
    end
end