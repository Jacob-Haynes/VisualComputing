%% Gaussian kernels
sigma = 2;
Ksize = 10;
gaus = zeros(Ksize, Ksize);

for n=-(Ksize-1)/2:(Ksize-1)/2
    for m=-(Ksize-1)/2:(Ksize-1)/2
        n0=(Ksize+1)/2;
        m0=(Ksize+1)/2;
        nn=n+n0;
        mm=m+m0;
        exponent = -((nn-n0)^2 + (mm-m0)^2)/(2*sigma^2);
        amplitude = 1 / (2*pi*sigma^2);
        gaus(nn, mm) = amplitude * exp(exponent);
    end
end

image = rgb2gray(im2double(imread('pears.png')));
kernel = gaus;
ec = extended_convolution(image, kernel);
imshow(ec)
imf = imfilter(image, kernel, 'replicate', 'conv');
figure(2)
imshow(imf);

err = immse(ec, imf);
fprintf('\n the MSE is %0.4f\n', err);
%% convolution function
function result = extended_convolution(I, K)

 for x=1:size(I,1)
     for y=1:size(I,2)
            sum=0;
            for i=ceil(-(size(K,1)-1)/2):ceil((size(K,1)-1)/2)
                for j=ceil(-(size(K,2)-1)/2):ceil((size(K,2)-1)/2)
                    i0= ceil((size(K,1)+1)/2);
                    j0= ceil((size(K,2)+1)/2);
                    u=x+i;
                    v=y+j;
                    ii=i0-i;
                    jj=j0-j;
                    if u<1 ||  u>size(I,1)
                        if v<1 || v>size(I,2)
                            pixel=I(x,y);
                            window=K(ii,jj);
                            sum = sum + (pixel * window);
                        else
                            pixel=I(x,v);
                            window=K(ii,jj);
                            sum = sum + (pixel * window);
                        end
                    elseif v<1 || v>size(I,2)
                        pixel=I(u,y);
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