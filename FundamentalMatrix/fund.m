% import 2 images
im1 = rgb2gray(im2double(imresize(imread('fun1cam1.jpg'),0.3)));
im2 = rgb2gray(im2double(imresize(imread('fun1cam2.jpg'),0.3)));
% detect features and get corresponding points
% Normally this is done with SURF and matched features
% just for elliminating unnessesary errors 9 points manually chosen
% from harris corners
corn1 = detectHarrisFeatures(im1);
corn2 = detectHarrisFeatures(im2);
figure(1);
imshow(im1); hold on;
plot(corn1.selectStrongest(100));
pause(0.1);
figure(2);
imshow(im2); hold on;
plot(corn2.selectStrongest(100));

% 3xn homogenous points as input - Normally matched SURF points
% here manual points for sake of proof
x_1 = [604.2, 601.1, 561.4, 699.1, 656.8, 570.1, 548.6, 652;...
    483.3, 448.8, 423.1, 319.7, 354.2, 380.9, 243.1, 203;...
    1,1,1,1,1,1,1,1];
x_2 = [449.3, 441.6, 388.9, 542.9, 496.6, 394.1, 364.1, 495.5;...
    536.7, 499.4, 472.2, 356.1, 394.7, 424.3, 266, 221.9;...
    1,1,1,1,1,1,1,1];

F = FundMatrix(x_1, x_2);
say = 'Fundamental matrix, F =';
disp(say)
disp(F)