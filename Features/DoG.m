im = rgb2gray(im2double(imread('butterfly2.jpg')));
s = 1.5; %sigma
scale = 2;
k = scale+3; %scales
thresh = 0.09;
o = 4; %octaves

for oct=0:o-1
    img=imresize(im,((1/2)^oct));
    % gaussian
    [X, Y] = meshgrid(1:size(img,1), 1:size(img,2));
    for z=0:k-1
        g{z+1}=fspecial('gaussian',size(img),((2^(1/scale))^z)*s);
    end
    for z=1:k
        l{z}= imfilter(img,g{z},'same','conv');
    end
    d{1}=img-l{1};
    for z=2:k
        d{z}=l{z-1}-l{z};
    end
    
    % max/min detection
    x1=[];
    y1=[];
    for z=2:k
        for i=2:size(img,1)-1
            for j=2:size(img,2)-1
                num=1;
                comparison=zeros(1,27);
                for zz=z-1:z+1
                    for ii=i-1:i+1
                        for jj=j-1:j+1
                            comparison(num)=d{z}(ii,jj);
                            num=num+1;
                        end
                    end
                end
                cmax=max(comparison);
                cmin=min(comparison);
                %if  cmin == d{z}(i,j) %uncomment this for minima
                %    if cmin < -thresh 
                if  cmax == d{z}(i,j)
                    if cmax > thresh 
                        x1=[x1,i];
                        y1=[y1,j];
                    end
                end
            end
        end
        blobs=[x1;y1];
        octres{oct+1,z}=blobs;
    end
end

% check for scale repetition
for oct=1:o
    for z= 2:k-1
        hi_z = octres{oct,z+1};
        lo_z = octres{oct,z};
        for m=1:size(hi_z,2)
            comp_z = hi_z(:,m);
            [indxm_row, indxm_col] = find(lo_z == comp_z);
            for n=1:size(indxm_col)
                octres{oct,z}(indxm_row(n),indxm_col(n))=NaN;
            end
        end
    end
end

% check blobs on each octave above and below - large octave
% replaces lower octave - pixels map over eachother 1-2.
for oct=1:o-1
    for z=1:k
        for m=1:size(octres{oct+1,z},2)
            largepix = octres{oct+1,z}(:,m);
            for n=1:size(octres{oct,z},2)
                smallpix = octres{oct,z}(:,n);
                if (smallpix(1,1) == largepix(1,1)*2 && smallpix(2,1)==largepix(2,1)*2)
                    octres{oct,z}(:,n)=NaN;
                end
                if smallpix(1,1) < largepix(1,1)*2 + (((2^0.5)^z)*s) ...
                        && smallpix(1,1) > largepix(1,1)*2 - (((2^0.5)^z)*s) ...
                        && smallpix(2,1) < largepix(2,1)*2 + (((2^0.5)^z)*s) ...
                        && smallpix(2,1) > largepix(2,1)*2 - (((2^0.5)^z)*s)
                    octres{oct,z}(:,n)=NaN;
                end
            end
        end
    end
end

% scale each octave blobs to image size
for oct=0:o-1
    for z=1:k
        for i=1:size(octres{oct+1,z},1)
            for j=1:size(octres{oct+1,z},2)
                octres{oct+1,z}(i,j) = (octres{oct+1,z}(i,j)*(2^oct))-(2^(oct)/2);
            end
        end
    end
end

figure(1)
imshow(im);
hold on;
for oct=1:o
    for z=1:k
        if octres{oct,z} ~= 0
            y1=octres{oct,z}(2,:);
            x1=octres{oct,z}(1,:);
            z1=pi*((2^oct-1)*((2^0.5)^z)*s);
            scatter(y1,x1, z1, 'red');
        end
    end
end