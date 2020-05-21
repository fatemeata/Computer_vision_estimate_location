


%% Initializing
addpath('utils')
addpath('vlfeat-0.9.21\toolbox')
vl_setup
vl_version verbose

trainDirStr = 'Train';
queryDirStr = 'Query';
train_files = dir(fullfile(trainDirStr,'*.jpg'));
query_files = dir(fullfile(queryDirStr,'*.jpg'));

nBest = 10; % Number of best images selected for location determination

nTrain = size(train_files,1);
nTest = size(query_files,1);


%% Loading train data and extracting features
tic
for i = 1: nTrain
    tr_image = imread(fullfile(trainDirStr,train_files(i).name)) ;
    feat_db(i).names = strsplit(train_files(i).name,'_');    
    tr_image = single(rgb2gray(tr_image)) ;
    [feat_db(i).feature,feat_db(i).discript] = vl_sift(tr_image) ;
end
toc

%% Evaluation


preds_xy = zeros(nTest,2);
real_xy = zeros(nTest,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%---------for one test image-----------%%%%%%%%%%%%%%
% file = 'PCI_sp_1021_37.799991_-122.427879_937782821_0_670882217_26.5752_2.57514.jpg';
% [filepath,name,ext] = fileparts(file);
% 
% q_img = single(rgb2gray(imread(file)));
% temp = strsplit(file,'_');
% [x,y,~] = deg2utm(str2double(temp{1,4}),str2double(temp{1,5}));
% real_xy(1,1) = x;
% real_xy(1,2) = y;
%  tic
%    [preds_xy(1,:),picIdx] = predictCoordinates(q_img, feat_db, nBest);
%  toc
% fprintf('Squared error for this picture:%d\n', sum((real_xy(1,:)-preds_xy(1,:)).^2));
%  for j = 1:nBest
%         subplot(2,5,j);imshow(imread(fullfile(trainDirStr,train_files(picIdx(j)).name)))
%     end

%%%%%%%%%%%%%%--------------------loop for all test image------------------%%%
for i = 1:nTest
    temp = strsplit(query_files(i).name,'_');
    disp(query_files(i).name)
    [x,y,~] = deg2utm(str2double(temp{1,4}),str2double(temp{1,5}));
    real_xy(i,1) = x;
    real_xy(i,2) = y;
    
    q_img = single(rgb2gray(imread(fullfile(queryDirStr,query_files(i).name))));
    tic
    [preds_xy(i,:),picIdx] = predictCoordinates(q_img, feat_db, nBest);
    toc
    fprintf('Squared error for this picture:%d\n', sum((real_xy(i,:)-preds_xy(i,:)).^2))
    figure;imshow(imread(fullfile(queryDirStr,query_files(i).name)))
    figure
%     for j = 1:nBest
%         subplot(2,5,j);imshow(imread(fullfile(trainDirStr,train_files(picIdx(j)).name)))
%     end
end


% mean squared error
MSE = sum(sum((real_xy-preds_xy).^2))/nTest;
%%
for  k =1 : nTest
totalMSE = sum(sum((real_xy(k,:)-preds_xy(k,:)).^2))/nTest;
end