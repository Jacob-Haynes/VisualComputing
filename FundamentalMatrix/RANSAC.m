function [R, inindex] = RANSAC(x, y, n, k, t, d, findF, shape)
%     x,y – observed matched feature points
%     n - min num of points required
%     k - max num of iterations
%     t - threshold value for fitting
%     d - ratio of inliers
num_points=size(x,1);
inlirthresh = 0;
inlir_num = zeros(1,k);
Rlib = cell(1,k);

for i = 1:k
    % randomly select sample points
    random_pairs = randperm(size(x,2),n);
    %     sample = data(random_pairs, :);
    R1 = findF(x(:,random_pairs), y(:,random_pairs), shape);
    
    % count inliers, if more than inlier thresh, refit
    err = sum((y'.*(R1*x)'),2);
    inlir = size(find(abs(err)<=t),1);
    inlir_num(i) = inlir;
    if inlir_num(i) > inlirthresh
        Rlib{i} = R1;
    end
end
%choose the set with most inliers
[~,index] = max(inlir_num);
R = Rlib{index};
err = sum((y'.*(R*x)'),2);
inindex = find(err < t);
end