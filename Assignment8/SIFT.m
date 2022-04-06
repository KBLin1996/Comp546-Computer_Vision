function [class_descriptors_cnt, descriptors, class_image_cnt, all_descriptors] = ...
                    SIFT(folder_path, subfolder_names)
    class_cnt = length(subfolder_names);
    class_descriptors_cnt = zeros(1, class_cnt);
    class_image_cnt = zeros(1, class_cnt);
    descriptors = {};
    all_descriptors = [];
    cnt = 1;
    prev_descriptor_cnt = 0;
    prev_image_cnt = 0;

    for i = 1 : class_cnt
        image_path = folder_path + subfolder_names(i) + "/*.jpg";
        images = dir(image_path);
        
        class_image_cnt(i) = prev_image_cnt + length(images);
        class_descriptors_cnt(i) = prev_descriptor_cnt;

        % Read in all images within the directory
        for j = 1 : length(images)
            image_name = folder_path + subfolder_names(i) + "/" + string(images(j).name);
            image = im2single(imread(image_name));
            gray_image = rgb2gray(image);
        
            [f, d] = vl_sift(gray_image);
            descriptors{cnt} = im2double(d');
            all_descriptors = [all_descriptors, d];
            cnt = cnt + 1;
    
            % Accumulate the descriptors count for each separate class
            class_descriptors_cnt(i) = class_descriptors_cnt(i) + size(d, 2);
        end
        prev_descriptor_cnt = class_descriptors_cnt(i);
        prev_image_cnt = class_image_cnt(i);
    end

    all_descriptors = im2double(all_descriptors');
end