function [c,ceq] = constfnc(x)

global currentOrder;
global currentstock;
global orderlength;

a = polyshape();
order = repmat(a,[1 orderlength]);

for j = 1:orderlength
    order(j) = polyshape(currentOrder(j).X,currentOrder(j).Y);
    order(j) = translate(order(j),x(j*3-2),x(j*3-1));
    order(j) = rotate(order(j),x(j*3),[x(j*3-2) x(j*3-1)]);
end

temp = polyshape();
k = 0;

for y = 1:orderlength-1
    for j = y+1:orderlength
        k = k +1;
        temp(k) = intersect(order(y),order(j));
    end
end

tomiorder = union(temp);

enosiorder = union(order);
enosi = union(enosiorder,currentstock);
outside = subtract(enosi,currentstock);

ceq = [area(tomiorder) area(outside)];
c = [];
end