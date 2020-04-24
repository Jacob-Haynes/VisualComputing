%% load images
im1 = rgb2gray(im2double(imread('panoramaL.jpg')));
im2 = rgb2gray(im2double(imread('panoramaR.jpg')));
im1=imresize(im1,0.5);
im2=imresize(im2,0.5);

%% SURF features
surf1 = detectSURFFeatures(im1);
surf2 = detectSURFFeatures(im2);

%% For each descriptor first set, find closest in second set
[feat1,points1] = extractFeatures(im1,surf1);
[feat2,points2] = extractFeatures(im2,surf2);

% distances between each feature
D=zeros(size(feat1,1),size(feat2,1));
for i=1:size(feat1,1)
    for j=1:size(feat2,1)
        D(i,j)=pdist2(feat1(i,:),feat2(j,:));
    end
end
% shortest distance pair and second shortest
minA1=zeros(size(feat1,1),1);
minA2=zeros(size(feat1,1),1);
for i=1:size(feat1,1)
    [Y,idx]=min(D(i,:));
    minA1(i)=Y;
    D2=D;
    D2(i,idx)=NaN;
    minA2(i)=min(D2(i,:));
end
minB1=zeros(size(feat2,1),1);
for j=1:size(feat2,1)
    [Y,idx]=min(D(:,j));
    minB1(j)=Y;
end
% compare shortest distances so only keep if shortest 1 matches shortes 2
index_feature_pairs = [];
for i=1:size(feat1,1)
    for j=1:size(feat2,1)
        if (D(i,j) == minA1(i) && D(i,j) == minB1(j))
            indx = [i, j];
            index_feature_pairs = [index_feature_pairs ; indx];
        end
    end
end
% ratio test
    matched=[];
for n=1:size(index_feature_pairs,1)
    i = index_feature_pairs(n,1);
    r= minA1(i)/minA2(i);

    if r<0.6
        matched=[matched; index_feature_pairs(n,:)];
    end
end

%% extract feature vectors (descriptors)
[mfeat1,mpoints1] = extractFeatures(im1,surf1);
[mfeat2,mpoints2] = extractFeatures(im2,surf2);

%% match features
mpairs = matchFeatures(mfeat1,mfeat2);
mpoints1 = mpoints1(mpairs(:,1));
mpoints2 = mpoints2(mpairs(:,2));

%% display output
figure;
showMatchedFeatures(im1,im2,points1(matched(:,1)),points2(matched(:,2)),'montage');
figure(2)
showMatchedFeatures(im1,im2,mpoints1,mpoints2,'montage');