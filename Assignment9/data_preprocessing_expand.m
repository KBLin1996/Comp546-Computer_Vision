function [class_num, folder_path] = data_preprocessing_expand(expand_path)   
    class_num = [];
    folder_path = [];
    
    % Get a list of all files and folders in this folder
    files = dir(expand_path);
    
    % Get a logical vector that tells which is a directory.
    dir_flags = [files.isdir];
    
    % Extract only those that are directories
    % 'subfolder_info' is a structure type data with extra info.
    subfolder_info = files(dir_flags);
    subfolders = {subfolder_info(3 : end).name};
    
    for i = 1 : length(subfolders)
        if subfolders(i) == "TrainingDataset"
            train_folder_path = expand_path + subfolders(i) + '/';
            training_folders = dir(train_folder_path);

            for j = 1 : length(training_folders)
                if length(training_folders(j).name) >= 3
                    folder_name = training_folders(j).name;
                    folder_num = str2double(folder_name(1:3));

                    if folder_num <= 1000 && folder_num >= 0
                        folder_path = [folder_path, train_folder_path + folder_name];
                        class_num = [class_num, string(folder_name(1:3))];
                    end
                end
            end
        end
    end

end