% This function gets the test image and feature database and predicts the
% location of the test image.

function [coordinates, maxIndex] = predictCoordinates(q_img,feature_db, nBest)

nTrain = length(feature_db);

[qf,qd] = vl_sift(q_img) ; % SIFT for the test image

 for i = 1: nTrain
    [matches{i,1}, scores{i,1}] = vl_ubcmatch(qd,feature_db(i).discript) ; % find match between test image and train image
    numMatches(i) = size(matches{i,1},2) ;
 end
 
[sortedValues,sortIndex] = sort(numMatches(:),'descend');  %Sort the values in descending order
maxIndex = sortIndex(1:nBest);  %Get a linear index into A of the 10 largest values


for k = 1 : nBest
    getScore(k) = scores(maxIndex(k));
    dlat(k) = cellfun(@str2double, feature_db(maxIndex(k)).names(4)) ;
    dlon(k) = cellfun(@str2double, feature_db(maxIndex(k)).names(5)) ;
    [x,y,z] = deg2utm(dlat,dlon); 
end

%ransac_demo
xMean = mean(x);
yMean = mean(y);
xStd = std(x);
yStd = std(y);
remove_idx =[];
if xStd>500
    for k=1:size(x,1)
        if abs(x(k)-xMean)>xStd
            remove_idx = cat(1,remove_idx,[k]);
        end
    end
end
if yStd>500
    for k=1:size(x,1)
        if abs(y(k)-yMean)>yStd
            remove_idx = cat(1,remove_idx,[k]);
        end
    end
end

if length(remove_idx)>0
    remove_idx = unique(remove_idx)
    x(remove_idx)=[];
    y(remove_idx)=[];
end


xMean = mean(x);
yMean = mean(y);

coordinates = [xMean, yMean]';
end