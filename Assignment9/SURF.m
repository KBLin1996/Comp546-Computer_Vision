function [class_descriptors_cnt, descriptors, class_image_cnt, all_descriptors] = ...
                    SURF(subfolder_names, class_num, dataset)

    if dataset == "expand_test"
        class_cnt = length(class_num);
    else
        class_cnt = length(subfolder_names);
    end

    class_descriptors_cnt = zeros(1, class_cnt);
    class_image_cnt = zeros(1, class_cnt);
    descriptors = {};
    all_descriptors = [];
    cnt = 1;
    prev_descriptor_cnt = 0;
    prev_image_cnt = 0;


    if dataset == "expand_test"
        test_images = subfolder_names + "*.jpg";
        images = dir(test_images);

        for i = 1 : length(class_num)
            for j = 1 : length(images)
                if images(j).name(1:3) == class_num(i)
                    % Read test image
                    image_name = subfolder_names + string(images(j).name);
                    image = im2single(imread(image_name));
                    gray_image = im2gray(image);
 
                    % SURF Operation
                    points = detectSURFFeatures(gray_image);
                    [features, ~] = extractFeatures(gray_image, points);
                    descriptors{cnt} = features;
                    cnt = cnt + 1;

                    % Accumulate image count for this class
                    class_image_cnt(i) = class_image_cnt(i) + 1;
                end
            end
        end
    else
        for i = 1 : class_cnt
            image_path = subfolder_names(i) + "/*.jpg";
            images = dir(image_path);
            
            class_image_cnt(i) = prev_image_cnt + length(images);
            class_descriptors_cnt(i) = prev_descriptor_cnt;

            % Read in all images within the directory
            for j = 1 : length(images)
                image_name = subfolder_names(i) + "/" + string(images(j).name);
                image = im2single(imread(image_name));
                gray_image = im2gray(image);
            
                points = detectSURFFeatures(gray_image);
                [features, ~] = extractFeatures(gray_image, points);
                descriptors{cnt} = features;
                all_descriptors = [all_descriptors, features'];
                cnt = cnt + 1;
        
                % Accumulate the descriptors count for each separate class
                class_descriptors_cnt(i) = class_descriptors_cnt(i) + size(features, 1);
            end

            prev_descriptor_cnt = class_descriptors_cnt(i);
            prev_image_cnt = class_image_cnt(i);
        end
    end

    all_descriptors = all_descriptors';
end