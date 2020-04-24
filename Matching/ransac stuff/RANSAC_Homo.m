function [H ptindx] = RANSAC_Homo(points_in, points_out)
%find homo between matched points using ransac
%points=[x1,y1;x2,y2; etc]
%ptindx = inlier index
points_in = points_in;
points_out = points_out;
n = 4; % min num of points required
k = 30; % number of iterations
t = 4; % inlier threshold
d = 0.1; % ratio of inliers
[H ptindx] = ransac_func(points_in, points_out, n, k, t, d, @homo_estimate, @dist_func);
end

function dist = dist_func(H, points_in, points_out)
n = size(points_in, 1);
points_temp = H*[points_in';ones(1,n)];
points_temp = points_temp(1:2,:)./repmat(points_temp(3,:),2,1);
dist = sum((points_out' - points_temp).^2,1);
end

function H = homo_estimate(points_in, points_out)
x_in=zeros(1,4);
y_in=zeros(1,4);
x_out=zeros(1,4);
y_out=zeros(1,4);
%generate matrix of homogenous points
for i=1:4
    x_in(i) = points_in(i,1)';
    y_in(i) = points_in(i,2)';
    x_out(i) = points_out(i,1)';
    y_out(i) = points_out(i,2)';
    
    p{i}=[-x_in(i), -y_in(i), -1, 0, 0, 0, x_in(i)*x_out(i), y_in(i)*x_out(i), x_out(i);
        0, 0, 0, -x_in(i), -y_in(i), -1, x_in(i)*y_out(i), y_in(i)*y_out(i), y_out(i)];
end
P=[];
for i=1:4
    P=[P;p{i}];
end
% single value decomp
[~, ~, V] =svd(P);
for i=1:size(V,1)
    h(i)=V(i, end);
end
%asign to H
H=[h(1), h(2), h(3); h(4), h(5), h(6); h(7), h(8), h(9)];
end