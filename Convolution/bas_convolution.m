%%Basic convolution 

% choose image and kernel
image = rgb2gray(im2double(imread('pears.png')));
kernel = (1/9)*ones(3,3);

% run convolutions
basicconv = basic_convolution(image, kernel);
figure(1)
imshow(basicconv)
normconv=conv2(image, kernel, 'same');
figure(2)
imshow(normconv);
% calculate mean square error between convolutions
err = immse(basicconv, normconv);
fprintf('\n the MSE is %0.4f\n', err);

% func
function result = basic_convolution(I, K)

 for x=1:size(I,1)
     for y=1:size(I,2)
            sum=0;
            for i=-(size(K,1)-1)/2:(size(K,1)-1)/2
                for j=-(size(K,2)-1)/2:(size(K,2)-1)/2
                    i0= (size(K,1)+1)/2;
                    j0= (size(K,2)+1)/2;
                    u=x+i;
                    v=y+j;
                    ii=i0-i;
                    jj=j0-j;
                    if u<1 || v<1 || u>size(I,1) || v>size(I,2)
                        pixel=0;
                        window=K(ii,jj);
                        sum = sum + (pixel * window);
                    else
                        pixel=I(u,v);
                        window=K(ii,jj);
                        sum = sum + (pixel * window);
                    end
                end
            end
            R(x,y)=sum;
     end
    result = R;
 end
end