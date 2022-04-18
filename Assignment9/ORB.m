function [class_descriptors_cnt, descriptors, class_image_cnt, all_descriptors] = ...
                    ORB(subfolder_names)
    class_cnt = length(subfolder_names);
    class_descriptors_cnt = zeros(1, class_cnt);
    class_image_cnt = zeros(1, class_cnt);
    descriptors = {};
    all_descriptors = [];
    cnt = 1;
    prev_descriptor_cnt = 0;
    prev_image_cnt = 0;

    for i = 1 : class_cnt
        image_path = subfolder_names(i) + "/*.jpg";
        images = dir(image_path);
        
        class_image_cnt(i) = prev_image_cnt + length(images);
        class_descriptors_cnt(i) = prev_descriptor_cnt;

        % Read in all images within the directory
        for j = 1 : length(images)
            image_name = subfolder_names(i) + "/" + string(images(j).name);
            image = im2single(imread(image_name));
            gray_image = rgb2gray(image);
        
            points = detectORBFeatures(gray_image);
            [features, ~] = extractFeatures(gray_image, points);
            features = im2single(features.Features);
            descriptors{cnt} = features;
            all_descriptors = [all_descriptors, features'];
            cnt = cnt + 1;
    
            % Accumulate the descriptors count for each separate class
            class_descriptors_cnt(i) = class_descriptors_cnt(i) + size(features, 1);
        end
        prev_descriptor_cnt = class_descriptors_cnt(i);
        prev_image_cnt = class_image_cnt(i);
    end

    all_descriptors = all_descriptors';
end