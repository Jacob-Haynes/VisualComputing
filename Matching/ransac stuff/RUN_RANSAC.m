%% load images
im1 = rgb2gray(im2double(imread('hiresvancoverL.jpeg')));
im2 = rgb2gray(im2double(imread('hiresvancoverR.jpeg')));
%downscale images
im1=imresize(im1, 0.25);
im2=imresize(im2, 0.25);

%% pad image 1
pad_im1=padarray(im1,size(im1));
result_im = pad_im1;

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

%% RANSAC
[H ptindx]=RANSAC_Homo(points_in, points_out);

%% map im2 to padded im1
I=zeros(2);
for i=1:size(pad_im1,1)
    for j=1:size(pad_im1,2)
        in=[j;i;1];
        temp = H*in;
        out = temp./temp(3);
        
        if (floor(out(1))>1 && floor(out(2))>1)
            if (ceil(out(1))<size(im2,2)-1 && ceil(out(2))<size(im2,1)-1)
                I(1,1)=im2(floor(out(2)), floor(out(1)));
                I(1,2)=im2(ceil(out(2)), floor(out(1)));
                I(2,1)=im2(floor(out(2)), ceil(out(1)));
                I(2,2)=im2(ceil(out(2)), ceil(out(1)));
                b = out(1)-floor(out(1));
                a = out(2)-floor(out(2));
                result_im(i,j) = bi_lin_int(I, a, b);
            end
        end
    end
end
%% show result
figure(1)
showMatchedFeatures(pad_im1,im2,points1(matched(:,1)),points2(matched(:,2)),'montage');
figure(2)
imshow(result_im);