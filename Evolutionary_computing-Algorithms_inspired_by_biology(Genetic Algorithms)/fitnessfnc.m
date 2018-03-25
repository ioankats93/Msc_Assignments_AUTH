function fitness = fitnessfnc(x)

global currentOrder;
global currentstock;
global orderlength;

a = polyshape();
buffer = repmat(a,[1 orderlength]);
order = repmat(a,[1 orderlength]);

for j = 1:orderlength
    order(j) = polyshape(currentOrder(j).X,currentOrder(j).Y);
    order(j) = translate(order(j),x(j*3-2),x(j*3-1));
    order(j) = rotate(order(j),x(j*3),[x(j*3-2) x(j*3-1)]);
    buffer(j) = polybuffer(order(j),0.1);
end

enosibuffer = union(buffer);
ipoloipo = subtract(currentstock,enosibuffer);

if area(ipoloipo) == 0
    l = 0;
else
    chipoloipo = convhull(ipoloipo);
    prmipoloipo = perimeter(ipoloipo);
    prmchipoloipo = perimeter(chipoloipo);
    prmbuffer = perimeter(enosibuffer);
    %chbuffer = convhull(enosibuffer);
    l = prmchipoloipo + 2*prmipoloipo + prmbuffer;
    %l = (area(chipoloipo) - area(ipoloipo))/area(ipoloipo);
end

fitness = l;
end