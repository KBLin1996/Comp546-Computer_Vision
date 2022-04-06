function subfolder_names = data_preprocessing(folder_path, file_start_with)   
    % Get a list of all files and folders in this folder
    files = dir(folder_path);
    
    % Get a logical vector that tells which is a directory.
    dir_flags = [files.isdir];
    
    % Extract only those that are directories
    % 'subfolder_info' is a structure type data with extra info.
    subfolder_info = files(dir_flags);
    
    % Get only the folder names into a cell array.
    % Start at 3 to skip . and ..
    all_subfolder_names = {subfolder_info(3 : end).name};
    
    subfolder_names = {};
    subfolder_names = [subfolder_names, all_subfolder_names{ ...
                                             startsWith(all_subfolder_names, file_start_with)}];
end