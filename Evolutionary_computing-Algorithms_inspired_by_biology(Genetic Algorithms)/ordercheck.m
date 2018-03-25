function [result, flag, output] = ordercheck(Order,stock)

global orderlength;

a = polyshape();

order = repmat(a,[1 orderlength]);

nvars = 3 * orderlength;

fit = @fitnessfnc;
const = @constfnc;
options = optimoptions(@ga,'MaxTime',1800);

[test, fval, exitflag, output] = ga(fit,nvars,[],[],[],[],[],[],const,options)

figure;
hold on;

plot(stock);

for j = 1:orderlength
    order(j) = polyshape(Order(j).X,Order(j).Y);
    order(j) = translate(order(j),test(j*3-2),test(j*3-1));
    order(j) = rotate(order(j),test(j*3),[test(j*3-2) test(j*3-1)]);
    plot(order(j));
    order(j) = polybuffer(order(j),0.1);
end

enosi = union(order);
ipoloipo = subtract(stock,enosi);

axis equal;

result = ipoloipo;
flag = exitflag;
end