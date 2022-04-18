clear, clc
tic;
run('./vlfeat-0.9.21/toolbox/vl_setup');


%% Data Preprocessing
% Path of all training images
main_folder_path = "./Assignment08_data/Assignment08_data_expanded/";
[class_num, folder_path] = data_preprocessing_expand(main_folder_path);


%% SURF Operation
[class_descriptors_cnt, ~, ~, all_descriptors] = SURF(folder_path, class_num, "");


%% KMeans Clustering
cluster_cnt = 6000;
% cluster_idx_list = kmeans(input_x, cluster_num)
[~, centers] = kmeans(all_descriptors, cluster_cnt, 'Distance', 'cityblock', 'MaxIter', 16000);

% Record each descriptors' distance to the centroid (Squared Euclidean distance)
[descriptors_to_cluster, descriptor_centroid_dist] = knnsearch(centers, all_descriptors);

save("training_var.mat", "class_descriptors_cnt", "centers", "descriptors_to_cluster", "descriptor_centroid_dist")


%load("training_var.mat");


%% Testing (with different thresholds, training threshold will differ too)

% Path of all testing images
best_sum=0; 
best_threshold = 0;

% SURF Operation
folder_path = main_folder_path + "TestDataset/";
[~, descriptors, class_image_cnt, ~] = SURF(folder_path, class_num, "expand_test");

acc_class_image_cnt = class_image_cnt;
for i = 2 : length(acc_class_image_cnt)
    acc_class_image_cnt(i) = acc_class_image_cnt(i) + acc_class_image_cnt(i-1);
end

% Find out the best threshold
for threshold = 0.9 : 0.01 : 1
    current_sum = 0;

    train_cluster_frequency = draw_hist(class_descriptors_cnt, cluster_cnt, ...
                                                          descriptors_to_cluster, descriptor_centroid_dist, ...
                                                          class_num, threshold, true, false);
    
    % KMeans clustering for each testing image
    confusion_matrix = test_knn(centers, acc_class_image_cnt, descriptors, ...
                                                                train_cluster_frequency, threshold, cluster_cnt);

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
    

fprintf("Best Sum: %.2f, Best Threshold: %.2f\n", best_sum, best_threshold);
display_confusion_matrix_expand(best_confusion_matrix, class_num);
toc;