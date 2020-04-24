%% load images
im1 = rgb2gray(im2double(imread('panoramaL.jpg')));
im2 = rgb2gray(im2double(imread('panoramaR.jpg')));
im1 = imresize(im1,0.5);
im2 = imresize(im2,0.5);
pad_im1=padarray(im1,size(im1));
% test point to see if it maps correctly
input_point = [606;381;1];

%% SURF features
surf1 = detectSURFFeatures(pad_im1);
surf2 = detectSURFFeatures(im2);

%% extract feature vectors (descriptors)
[feat1,points1] = extractFeatures(pad_im1,surf1);
[feat2,points2] = extractFeatures(im2,surf2);

%% match features
matched = matchFeatures(feat1,feat2);
points_in = points1(matched(:,1)).Location;
points_out = points2(matched(:,2)).Location;

%% Compute Homography
H = homo_estimate_chosenpoints(points_in, points_out);

    %divide by eigenvalue
    temp = H*(input_point);
    output_point = temp./temp(3);
    output_point(3)=1;
    
%% show input and output image and input and calculated output point
%figure(1)
%showMatchedFeatures(pad_im1,im2,points1(matched(:,1)),points2(matched(:,2)),'montage');
figure(2)
subplot(1,2,1)
imshow(im1);
hold on
scatter(input_point(1)-size(im1,2), input_point(2)-size(im1,1), 'red', 'filled');
subplot(1,2,2)
imshow(im2);
hold on
scatter(output_point(1), output_point(2), 'red', 'filled');
