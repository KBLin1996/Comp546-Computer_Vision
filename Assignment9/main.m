clear, clc
tic;
run('./vlfeat-0.9.21/toolbox/vl_setup');


%% Data Preprocessing
% Path of all training images
train_folder_path = "./Assignment08_data/Assignment08_data_reduced/TrainingDataset/";
subfolder_names = data_preprocessing(train_folder_path, "");
subfolder_names([1 2]) = subfolder_names([2 1]);


%% SURF Operation
[class_descriptors_cnt, ~, ~, all_descriptors] = SURF(subfolder_names, [], "");


%% KMeans Clustering
cluster_cnt = 1000;
% cluster_idx_list = kmeans(input_x, cluster_num)
[~, centers] = kmeans(all_descriptors, cluster_cnt, 'Distance', 'cityblock', 'MaxIter', 9000);

% Record each descriptors' distance to the centroid (Squared Euclidean distance)
[descriptors_to_cluster, descriptor_centroid_dist] = knnsearch(centers, all_descriptors);


% %% Draw histogram
% figure(1);
% % Threshold == -1 means not to set threshold value
% draw_hist(class_descriptors_cnt, cluster_cnt, descriptors_to_cluster, ...
%                        descriptor_centroid_dist, subfolder_names, -1, false, true);
% 
% 
% %% Remove some features that would not help
% threshold = 0.7;
% figure(2);
% draw_hist(class_descriptors_cnt, cluster_cnt, descriptors_to_cluster, ...
%                        descriptor_centroid_dist, subfolder_names, threshold, false, true);
% 
% 
% %% Normalized the bin counts
% figure(3);
% threshold = 0.7;
% train_cluster_frequency = draw_hist(class_descriptors_cnt, cluster_cnt, ...
%                                                           descriptors_to_cluster, descriptor_centroid_dist, ...
%                                                           subfolder_names, threshold, true, true);
    
save("reduce_var.mat", "class_descriptors_cnt", "cluster_cnt", "descriptors_to_cluster" ...
    , "descriptor_centroid_dist", "subfolder_names", "centers")

%load("reduce_var.mat")


%% Testing (with different thresholds, training threshold will differ too)
% Path of all testing images
best_sum=0; 
best_threshold = 0;
for threshold = 0.6 : 0.01 : 1
    current_sum = 0;

    train_cluster_frequency = draw_hist(class_descriptors_cnt, cluster_cnt, ...
                                                          descriptors_to_cluster, descriptor_centroid_dist, ...
                                                          subfolder_names, threshold, true, false);

    all_folder_path = "./Assignment08_data/Assignment08_data_reduced/";
    subfolder_names = data_preprocessing(all_folder_path, "TestDataset");
    
    % SURF operation
    [~, descriptors, class_image_cnt, ~] = SURF(subfolder_names, [], "");
    
    % KMeans clustering for each testing image
    confusion_matrix = test_knn(centers, class_image_cnt, descriptors, train_cluster_frequency, ...
                                                                  threshold, cluster_cnt);
    
    for i = length(class_image_cnt) : -1 : 2
        class_image_cnt(i) = class_image_cnt(i) - class_image_cnt(i-1);
    end
    confusion_matrix = confusion_matrix ./ (class_image_cnt') .* 100;
    
    for i = 1 : length(confusion_matrix)
        current_sum = confusion_matrix(i, i) + current_sum;
    end

    if current_sum > best_sum
        best_confusion_matrix = confusion_matrix;
        best_threshold = threshold;
        best_sum = current_sum;
    end

    fprintf("Current Threshold: %.2f, Current Sum: %.2f, Best Threshold: %.2f\n", ...
                      threshold, current_sum, best_threshold);
end


display_confusion_matrix(best_confusion_matrix);
fprintf("Best Sum: %.2f, Best Accuracy: %.2f, Best Threshold: %.2f\n", best_sum, ...
                (best_sum / 3), best_threshold);
toc;