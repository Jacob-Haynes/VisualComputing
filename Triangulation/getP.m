function Ps = getP(E)
% decompose E as in matrix section to get R and t
[U,~,V] = svd(E);
W = [0,-1,0;1,0,0;0,0,1];

Ps = zeros(3,4,4);
R_1 = U*W*V;
R_2 = U*W'*V;
t_1 = U(:,3);
t_2 = -U(:,3);
% form potential Ps
Ps(:,:,1) = [R_1, t_1];
Ps(:,:,2) = [R_1, t_2];
Ps(:,:,3) = [R_2, t_1];
Ps(:,:,4) = [R_2, t_2];
end