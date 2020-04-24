f = rgb2gray(im2double(imread('butterfly.jpg')));
s = sqrt(2); % std dev
hthresh = 0.1250;
lthresh = hthresh*0.4;


%% Gaussian blur the input image
Bf = imfilter(f, fspecial('gaussian',ceil(3*s)*2+1, s), 'replicate', 'conv');

%% Compute gradient magnitude maps in 4 directions: — \ | /
dfdx = imfilter(Bf, [1, 0, -1; 2, 0, -2; 1, 0, -1], 'conv');
dfdy = imfilter(Bf, [1, 2, 1; 0, 0, 0; -1, -2, -1], 'conv');
grad = sqrt(dfdx.^2 + dfdy.^2);
theta = atan2d(dfdy, dfdx);

%% Edge thinning: Non-maximum suppression

[h,w] = size(f);
edgethin = zeros(h,w);
for i=2:h-1
    for j=2:w-1
        % 0 deg (180)
        if (theta(i,j) >= -22.5 && theta(i,j) <= 22.5) || (theta(i,j) < -157.5 && theta(i,j) >= -180)
            if (grad(i,j) >= grad(i,j+1)) && (grad(i,j) >= grad(i,j-1))
                edgethin(i,j) = grad(i,j);
            end
            % 45 deg
        elseif (theta(i,j) >= 22.5 && theta(i,j) <= 67.5) || (theta(i,j) < -112.5 && theta(i,j) >= -157.5)
            if (grad(i,j) >= grad(i+1,j+1)) && (grad(i,j) >= grad(i-1,j-1))
                edgethin(i,j) = grad(i,j);
            end
            % 90 deg
        elseif (theta(i,j) >= 67.5 && theta(i,j) <= 112.5) || (theta(i,j) < -67.5 && theta(i,j) >= -112.5)
            if (grad(i,j) >= grad(i+1,j)) && (grad(i,j) >= grad(i-1,j))
                edgethin(i,j) = grad(i,j);
            end
            % 135 deg
        elseif (theta(i,j) >= 112.5 && theta(i,j) <= 157.5) || (theta(i,j) < -22.5 && theta(i,j) >= -67.5)
            if (grad(i,j) >= grad(i+1,j-1)) && (grad(i,j) >= grad(i-1,j+1))
                edgethin(i,j) = grad(i,j);
            end
        end
    end
end
edgethin = edgethin/max(edgethin(:));

%% Hysteresis thresholding:

% Identify strong edge pixels > high threshold
% Trace connected edge pixels > low threshold
strongpix = zeros(h,w);
weakpix = zeros(h,w);
thresh = edgethin;

%detects strong pixels and no edges, then identifies weakpixels
for i=1:h
    for j=1:w
        if thresh(i,j) > hthresh %strong edge
            strongpix(i,j)=1;
        elseif thresh(i,j) > lthresh %weak edge
            weakpix(i,j)=1;
        end
    end
end

%checks pixels neighboring to an identified weakpixel to see if its edge
for i = 2:(h-1)
    for j=2:(w-1)
        if weakpix(i,j) == 1
            for ib = -1:1
                for jb = -1:1
                    if strongpix(i+ib, j+jb) == 1
                        strongpix(i,j)=1;
                    end
                end
            end
        end
    end
end
for j = 2:(w-1)
    for i=2:(h-1)
        if weakpix(i,j) == 1
            for ib = -1:1
                for jb = -1:1
                    if strongpix(i+ib, j+jb) == 1
                        strongpix(i,j)=1;
                    end
                end
            end
        end
    end
end
for i = (h-1):-1:2
    for j= (w-1):-1:2
        if weakpix(i,j) == 1
            for ib = -1:1
                for jb = -1:1
                    if strongpix(i+ib, j+jb) == 1
                        strongpix(i,j)=1;
                    end
                end
            end
        end
    end
end
for j = (w-1):-1:2
    for i= (h-1):-1:2
        if weakpix(i,j) == 1
            for ib = -1:1
                for jb = -1:1
                    if strongpix(i+ib, j+jb) == 1
                        strongpix(i,j)=1;
                    end
                end
            end
        end
    end
end

%% Output binary map of Canny edges
result = strongpix;

%output result
figure(1)
imshow(edge(f,'Canny', hthresh, s));
figure(2)
imshow(result);
figure(3)
imshow(f);
