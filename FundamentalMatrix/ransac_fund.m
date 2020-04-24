% import 2 images
im1 = rgb2gray(imread('f3.jpg'));
im2 = rgb2gray(imread('f4.jpg'));
shape = size(im1);
% detect features and get corresponding points
points1 = detectSURFFeatures(im1);
points2 = detectSURFFeatures(im2);
[f1, pts1] = extractFeatures(im1,points2);
[f2, pts2] = extractFeatures(im2,points2);
indxPairs = matchFeatures(f1,f2);
matchedPoints1 = pts1(indxPairs(:,1),:);
matchedPoints2 = pts2(indxPairs(:,2),:);
figure(1); showMatchedFeatures(im1, im2, matchedPoints1, matchedPoints2, 'Montage');

% 3xn homogenous points as input - matched SURF points
x_1 = [matchedPoints1.Location,ones(size(matchedPoints1.Location,1),1)]';
x_2 = [matchedPoints2.Location,ones(size(matchedPoints2.Location,1),1)]';
n = 9; % min num of points required
k = 1000; % max num of iterations
t = 0.05; % threshold value for fitting
d = 0.05; % ratio of inliers

[F, inindex] = RANSAC(x_1, x_2, n, k, t, d, @FundMatrix, shape);
say = 'Fundamental matrix, F =';
disp(say)
disp(F)