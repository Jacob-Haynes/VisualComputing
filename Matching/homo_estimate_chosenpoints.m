function H = homo_estimate_chosenpoints(points_in, points_out)
%% Compute Homography
x_in=zeros(1,4);
y_in=zeros(1,4);
x_out=zeros(1,4);
y_out=zeros(1,4);
%generate matrix of homogenous points
i=1;
    while i~=5
        x_in(i) = points_in(i+3,1)';
        y_in(i) = points_in(i+3,2)';
        x_out(i) = points_out(i+3,1)';
        y_out(i) = points_out(i+3,2)';
        
        p{i}=[-x_in(i), -y_in(i), -1, 0, 0, 0, x_in(i)*x_out(i), y_in(i)*x_out(i), x_out(i);
            0, 0, 0, -x_in(i), -y_in(i), -1, x_in(i)*y_out(i), y_in(i)*y_out(i), y_out(i)];
        
        i=i+1;
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