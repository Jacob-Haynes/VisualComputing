%% input calibration points
PlaneID=[1,2,3,4];
%import images
im1 = rgb2gray(imread('cal1cam1.jpg'));
im2 = rgb2gray(imread('cal2cam1.jpg'));
im3 = rgb2gray(imread('cal3cam1.jpg'));
im4 = rgb2gray(imread('cal4cam1.jpg'));
% get features
corn1 = detectHarrisFeatures(im1);
corn2 = detectHarrisFeatures(im2);
corn3 = detectHarrisFeatures(im3);
corn4 = detectHarrisFeatures(im4);
figure(1);
imshow(im1); hold on;
plot(corn1);
pause(0.1);
figure(2);
imshow(im2); hold on;
plot(corn2);
pause(0.1);
figure(3);
imshow(im3); hold on;
plot(corn3);
pause(0.1);
figure(4);
imshow(im4); hold on;
plot(corn4);
pause(0.1);
%%% PAUSE HERE %%%
% MEASURE PIXEL LOCATIONS MAUALY TO MAKE SURE SAME CORNERS ARE USED
% image 1
% world measured coordinates centimeters
X1 = 0; Y1 = 0;
X2 = 0; Y2 = 2.9;
X3 = 3.2; Y3 = 2.9;
X4 = 3.2; Y4 = 0;
RWcoord{1}=[X1,Y1;X2,Y2;X3,Y3;X4,Y4];
% image measured points
x1 = 1040; y1 = 1651;
x2 = 1036; y3 = 1398;
x3 = 1314; y4 = 1392;
x4 = 1319; y2 = 1638;
ImPoints{1}=[x1,y1;x2,y2;x3,y3;x4,y4];
% image 2
% world measured coordinates centimeters
RWcoord{2}=[X1,Y1;X2,Y2;X3,Y3;X4,Y4];
% image measured points
x1 = 1192; y1 = 1663;
x2 = 1186; y3 = 1421;
x3 = 1446; y4 = 1408;
x4 = 1451; y2 = 1642;
ImPoints{2}=[x1,y1;x2,y2;x3,y3;x4,y4];
%image 3
% world measured coordinates centimeters
RWcoord{3}=[X1,Y1;X2,Y2;X3,Y3;X4,Y4];
% image measured points
x1 = 1552; y1 = 1916;
x2 = 1410; y3 = 1781;
x3 = 1557; y4 = 1622;
x4 = 1699; y2 = 1755;
ImPoints{3}=[x1,y1;x2,y2;x3,y3;x4,y4];
%image 4
% world measured coordinates centimeters
RWcoord{4}=[X1,Y1;X2,Y2;X3,Y3;X4,Y4];
% image measured points
x1 = 805; y1 = 1811;
x2 = 768.6; y3 = 1594;
x3 = 985.1; y4 = 1560;
x4 = 1022; y2 = 1783;
ImPoints{4}=[x1,y1;x2,y2;x3,y3;x4,y4];

%% paramater solve
%[A, R, t] = CameraCal(RWcoord, ImPoints, PlaneID);
A = CameraCal(RWcoord, ImPoints, PlaneID);
say = 'intrinsic matrix, A =';
disp(say)
disp(A)
