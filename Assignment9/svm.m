clear, clc;

resizeSize = 224;
clusters = 1000;


%% Append the current pwd with the target data folder
path = "./Assignment08_data/Assignment08_data_reduced";


%% Training
trainingPath = fullfile(path, 'TrainingDataset');

% Get a list of all files and folders in this folder.
folders = dir(trainingPath);

% Get a logical vector that tells which is a directory.
dirFlags = [folders.isdir];

% Extract only those that are directories.
categories = folders(dirFlags);

% Get only the folder names into a cell array.
categoryName = {categories(3:end).name}; % Start at 3 to skip . and ..

runSize = length(categoryName);


%% Load Image Datastore and make all images the same size
trainingSets = [];
for i = 1 : runSize
    trainingSets = [trainingSets, fullfile(trainingPath, categoryName{i})];
end


mkdir resized_training_image;
resizedPath = "./resized_training_image";

for i = 1 : length(trainingSets)
    setInfo = dir(trainingSets(i));
    currentPath = sprintf("./resized_training_image/%s", categoryName{i});
    mkdir(currentPath);

    for j = 1 : length(setInfo)
        if length(setInfo(j).name) > 2
            image = imread(fullfile(trainingSets(i), setInfo(j).name));
            image = imresize(image, [resizeSize resizeSize]);

            imwrite(image, fullfile(currentPath, setInfo(j).name));
        end
    end
end


trainIMDS = imageDatastore(resizedPath, 'IncludeSubfolders',true, 'LabelSource', 'foldernames');

% Extract SURF features from all training images and uses kmeans clustering
bag = bagOfFeatures(trainIMDS, 'VocabularySize', clusters);


%% Train SVM Classifier
opts = templateSVM('KernelFunction', 'polynomial', 'SaveSupportVectors', true, ...
    'kernelScale', 'auto', 'Solver', 'SMO');
classifier = trainImageCategoryClassifier(trainIMDS, bag, 'LearnerOptions', opts);
 

%% Create Collection for test image files
testSets = [];
for k = 1 : runSize
    folderName = "TestDataset_" + string(k);
    folderPath = fullfile(path, folderName);
    
    testSets = [testSets, folderPath];  

    imageInfo = dir(fullfile(folderPath, '*.jpg'));
end


% Resize testing images
mkdir resized_testing_image;
resizedPath = "./resized_testing_image";

for i = 1 : length(testSets)
    setInfo = dir(testSets(i));

    % setInfo(1) is '.' and setInfo(2) is '..'
    labelDirName = setInfo(3).name(1:3);
    currentPath = sprintf("./resized_testing_image/%s", labelDirName);
    mkdir(currentPath);

    for j = 1 : length(setInfo)
        if length(setInfo(j).name) > 2
            image = imread(fullfile(testSets(i), setInfo(j).name));
            image = imresize(image, [resizeSize resizeSize]);

            imwrite(image, fullfile(currentPath, setInfo(j).name));
        end
    end
end

testIMDS = imageDatastore(resizedPath, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');

% Evaluate the classifier
confMatrix = evaluate(classifier, testIMDS);
confMatrix = confMatrix .* 100;
accuracy = mean(diag(confMatrix));