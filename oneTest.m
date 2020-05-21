file = 'PCI_sp_932_37.800524_-122.423773_937782711_4_670882236_32.5081_35.4609.jpg';
[filepath,name,ext] = fileparts(file);

q_img = single(rgb2gray(imread(file)));
temp = strsplit(file,'_');
[x,y,~] = deg2utm(str2double(temp{1,4}),str2double(temp{1,5}));
real_xy(1,1) = x;
real_xy(1,2) = y;
 tic
    preds_xy(1,:) = predictCoordinates(q_img, feat_db, nBest);
 toc
fprintf('Squared error for this picture:%d\n', sum((real_xy(1,:)-preds_xy(1,:)).^2));