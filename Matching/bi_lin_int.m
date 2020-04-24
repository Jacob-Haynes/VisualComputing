function bilin_val = bi_lin_int(I, a, b)
f1 = I(1,1);
f2 = I(1,2);
f3 = I(2,1);
f4 = I(2,2);

f12 = (1-a)*f1 + a*f2;
f34 = (1-a)*f3 + a*f4;
f1234 = (1-b)*f12 + b*f34;

bilin_val = f1234;

end

%% swap the dimensions
