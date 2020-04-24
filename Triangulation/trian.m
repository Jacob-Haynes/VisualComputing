%import images
im1 = rgb2gray(imread('f3.jpg'));
im2 = rgb2gray(imread('f4.jpg'));
%Essencial and callibration matricies
E = [9.935068442389628e-05,5.407549603830622e-07,1.878286704138361e-04;...
    5.429991464766984e-07,2.956718708255639e-09,8.511062902439895e-07;...
    -5.977312241402861e-05,-4.345120594051463e-07,0.015417574854277];

K1 = [1.359314032225972e+02,0.742362746874094,1.124931935304834e+03;...
    0,0.011590889847024,-16.873729896078864;...
    0,0,1];
K2 = [1.359314032225972e+02,0.742362746874094,1.124931935304834e+03;...
    0,0.011590889847024,-16.873729896078864;...
    0,0,1];
%match features to get corresponding points
points1 = detectSURFFeatures(im1);
points2 = detectSURFFeatures(im2);
[feat1, vp1] = extractFeatures(im1, points1);
[feat2, vp2] = extractFeatures(im2, points2);
pairs = matchFeatures(feat1, feat2);
mpoints1 = vp1(pairs(:,1),:);
mpoints2 = vp2(pairs(:,2),:);
smpoints1 = mpoints1.selectStrongest(60);
smpoints2 = mpoints2.selectStrongest(60);
x_1 = [smpoints1.Location, ones(size(smpoints1.Location,1),1)]';
x_2 = [smpoints2.Location, ones(size(smpoints2.Location,1),1)]';

% USE THESE POINTS IF USING RANSAC INLIRES - RUN RANSAC FIRST THEN THIS
% COMMENT OUT THE FEATURE MATCHING SECTION
% x_1 = x_1(:,inindex);
% x_2 = x_2(:,inindex);

%make possible cam matrices
% 4 possible solutions from decomp of E
Ps = getP(E);
%make example point from both image
in_x = [x_1(:,1), x_2(:,1)];
% get the correct cam matrix from the possible ones (cam matrix func)
%cam matrix P_1 and P_2 for cam 1 (I|0) and cam 2 (solve cam matrix)
P_1 = [eye(3), zeros(3,1)];
P_2 = CamMatrix(Ps, K1, K2, in_x);
% triangulation
[tri] = tri_3D(x_1, K1*P_1, x_2, K2*P_2);
tri_x = tri(1,:);
tri_y = tri(2,:);
tri_z = tri(3,:);

figure(1);
plot3(tri_x, tri_y, tri_z, 'r+');
figure(2);
showMatchedFeatures(im1, im2, smpoints1, smpoints2, 'Montage');
