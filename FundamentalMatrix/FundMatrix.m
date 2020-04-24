function F = FundMatrix(x_1, x_2, shape)
% x_1, x_2 are corresponding 3xn homogenous points
% return fundamental matrix F (3x3)
% requires at least 8 point pairs

num_points = size(x_1,2);

% normalise
N = [2/shape(1), 0, -1; 0, 2/shape(2), -1; 0, 0, 1];
x_1 = N*x_1;
x_2 = N*x_2;
x_1 = [x_1(1,:); x_1(2,:)];
x_2 = [x_2(1,:); x_2(2,:)];
%constraints
C = [x_2(1,:)'.*x_1(1,:)', x_2(1,:)'.*x_1(2,:)', x_2(1,:)', ...
    x_2(2,:)'.*x_1(1,:)', x_2(2,:)'.*x_1(2,:)', x_2(2,:)',...
    x_1(1,:)', x_1(2,:)', ones(num_points, 1)];
%single val decomp
[U,D,V] = svd(C); 
%fundamental from V
F = reshape(V(:,9),3,3)';
%apply constraints - rank 2 via SVD and reconstruct two largest sing vals
[U,V,D]=svd(F); 
F = U*diag([D(1,1), D(2,2), 0])*V';
%remove normalisation
F = N'*F*N;