im = rgb2gray(im2double(imread('building.jpg')));
k=0.05;
window = zeros(3,3);

%% Compute gradient maps Ix and Iy
Ix = imfilter(im, [-1, 0, 1], 'replicate', 'conv');
Iy = imfilter(im, [-1; 0; 1], 'replicate', 'conv');
Ix2 = Ix.*Ix;
Iy2 = Iy.*Iy;
Ixy = Ix.*Iy;

%% Compute structure tensor:
A=zeros(size(im,1),size(im,2),2,2);
for x = (size(window,1)-1):(size(im,1)-size(window,1)+1)
    for y = (size(window,2)-1):(size(im,2)-size(window,2)+1)
        sumIx2=0;
        sumIxy=0;
        sumIy2=0;
        for i=-floor(size(window,1)/2):floor(size(window,1)/2)
            for j=-floor(size(window,2)/2):floor(size(window,2)/2)
                sumIx2 = sumIx2 + Ix2(x+i,y+j);
                sumIxy = sumIxy + Ixy(x+i,y+j);
                sumIy2 = sumIy2 + Iy2(x+i,y+j);
            end
        end
        A(x,y,1,1)=sumIx2;
        A(x,y,1,2)=sumIxy;
        A(x,y,2,1)=sumIxy;
        A(x,y,2,2)=sumIy2;
    end
end
        
        
%% Compute ‘cornerness score’:
% -ve is edge, +ve is corner, ~0 is nothing
r=zeros(size(im,1),size(im,2));
for x = (size(window,1)-1):(size(im,1)-size(window,1)+1)
    for y=(size(window,2)-1):(size(im,2)-size(window,2)+1)
        B=[A(x,y,1,1), A(x,y, 1,2); A(x,y,2,1), A(x,y,2,2)];
        r(x,y) = det(B) - k*(trace(B))^2;
        if r(x,y) < 0.3
            r(x,y)=0; %as we are only interested in the corners
        end
    end
end

%% Find local maxima of ‘cornerness score’:
%Maximum values among surrounding pixels (8-neighbours)
mask = ones(3); mask(5) = 0;
dilate = imdilate(r, mask);
peaks = r > dilate;
%% Output binary map of corners
output=zeros(x,y);
for x = 1:size(im,1)
    for y=1:size(im,2)
        if peaks(x,y) > 0
            output(x,y) = 1;
        else
            output(x,y) = 0;
        end
    end
end
[x1, y1] = find(output>0);
figure(1)
imshow(im);
hold on;
scatter(y1,x1, 'o','red');
