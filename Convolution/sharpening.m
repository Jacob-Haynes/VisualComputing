%% sharpening
blur = (1/9)*ones(3,3);
ammount = 1;

image = rgb2gray(im2double(imread('pears.png')));
kernel = blur;
ec = extended_convolution(image, kernel);
sharp = image + ((image-ec)*ammount);
figure(1)
imshow(sharp);
figure(2)
imshow(image)

%% convolution function
function result = extended_convolution(I, K)

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