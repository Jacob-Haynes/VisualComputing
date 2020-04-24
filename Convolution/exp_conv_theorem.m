%% Exploiting convolution theorem
image = rgb2gray(im2double(imread('pears.png')));
s = 3; %std dev
Ksize = ceil(3*s)*2+1;

kernel = gaussian_blur(s, Ksize);
tic;
ec = extended_convolution(image, kernel);
tc = toc;
imshow(ec)
tic;
ft = fft_gaussian_blur(image, kernel, Ksize);
tf = toc;
figure(2)
imshow(ft);

err = immse(ec, ft(:, :, 1));
fprintf('\n the MSE is %0.4f\n', err);

%% FFT ---- do kernel also
function fftresult = fft_gaussian_blur(I, kernel,Ksize)
   padI=padarray(I, [Ksize,Ksize],'symmetric');
    [h, w] = size(padI);
    padkernel = zeros(h,w);
    padkernel(1:Ksize, 1:Ksize) = kernel;
    fI = fft2(padI);
    fK = fft2(padkernel);
    ft = fI.*fK;
    fftresult = ifft2(ft);
    fftresult = fftresult(ceil(1.5*Ksize): (ceil(1.5*Ksize-1)+size(I, 1)), ceil(1.5*Ksize):(ceil(1.5*Ksize-1)+size(I,2)));
end

%% Gaussian blur
function gaussian = gaussian_blur(sigma, Ksize)
    gaussian = zeros(Ksize, Ksize);
    for n=-(Ksize-1)/2:(Ksize-1)/2
        for m=-(Ksize-1)/2:(Ksize-1)/2
            n0=(Ksize+1)/2;
            m0=(Ksize+1)/2;
            nn=n+n0;
            mm=m+m0;
            exponent = -((n)^2 + (m)^2)/(2*sigma^2);
            amplitude = 1 / (2*pi*sigma^2);
            gaussian(nn, mm) = amplitude * exp(exponent);
        end
    end
end
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