load('WoodProblemDefinition.mat');

global currentOrder;
global currentstock;
global orderlength;

a = polyshape();

stock = repmat(a,[1 length(Stock)]);
output = repmat(a,[1 length(Stock)]);
order1 = repmat(a,[1 length(Order1)]);
order2 = repmat(a,[1 length(Order2)]);
order3 = repmat(a,[1 length(Order3)]);
sortorder1 = repmat(a,[1 length(Order1)]);
sortorder2 = repmat(a,[1 length(Order2)]);
sortorder3 = repmat(a,[1 length(Order3)]);
areaorder1 = zeros(1,length(Order1));
areaorder2 = zeros(1,length(Order2));
areaorder3 = zeros(1,length(Order3));
temp = zeros(1,7);
area1 = 0;
area2 = 0;
area3 = 0;

tempOrder = Order3;
temporder = order3;

for i = 1:length(Order1)
    order1(i) = polyshape(Order1(i).X,Order1(i).Y);
    areaorder1(i) = area(order1(i));
    area1 = area1 + areaorder1(i);
end

areaorder1 = sort(areaorder1);

for i = 1:length(Order1)
    for j = 1:length(Order1)
        if areaorder1(i) == area(order1(j))
            temp(i) = j;
        end
    end
end

for i = 1:length(Order1)
    temporder(i) = order1(temp(i));
    tempOrder(i) = Order1(temp(i));
end

for i = 1:length(Order1)
    order1(i) = temporder(i);
    Order1(i) = tempOrder(i);
end

for i = 1:length(Order2)
    order2(i) = polyshape(Order2(i).X,Order2(i).Y);
    areaorder2(i) = area(order2(i));
    area2 = area2 + areaorder2(i);
end

areaorder2 = sort(areaorder2);

for i = 1:length(Order2)
    for j = 1:length(Order2)
        if areaorder2(i) == area(order2(j))
            temp(i) = j;
        end
    end
end

for i = 1:length(Order2)
    temporder(i) = order2(temp(i));
    tempOrder(i) = Order2(temp(i));
end

for i = 1:length(Order2)
    order2(i) = temporder(i);
    Order2(i) = tempOrder(i);
end

for i = 1:length(Order3)
    order3(i) = polyshape(Order3(i).X,Order3(i).Y);
    areaorder3(i) = area(order3(i));
    area3 = area3 + areaorder3(i);
end

areaorder3 = sort(areaorder3);

for i = 1:length(Order3)
    for j = 1:length(Order3)
        if areaorder3(i) == area(order3(j))
            temp(i) = j;
        end
    end
end

for i = 1:length(Order3)
    temporder(i) = order3(temp(i));
    tempOrder(i) = Order3(temp(i));
end

for i = 1:length(Order3)
    order3(i) = temporder(i);
    Order3(i) = tempOrder(i);
end

for i = 1:length(Stock)
    stock(i) = polyshape(Stock(i).X,Stock(i).Y);
end

%order1

index2 = length(Order1);
count = 0;
i = 1;

while i <= length(stock)
    currentOrder = Order1;
    if count == 0
        orderlength = index2;
        stockarea = area(stock(i));
        for j = 1:index2
            diff = stockarea - areaorder1(j);
            if diff/stockarea <= 0.1
                count = j;
                orderlength = j -1;
                break;
            end
            print = ['Wood', num2str(j), ' of order1 fits in stock', num2str(i)];
            disp(print);
            stockarea = diff;
        end
    end
    if orderlength == 0
        print = ['Not enough space for order1 in stock', num2str(i)];
        disp(print);
        count = 0;
        i = i + 1;
        continue;
    end
    currentstock = stock(i);
    [result, flag, output] = ordercheck(Order1,currentstock);
    if output.maxconstraint >= 0.5
        count = orderlength;
        orderlength = orderlength - 1;
        print = ['Order1 does not fit in stock', num2str(i)];
        disp(print);
        continue;
    end
    stock(i) = result;
    if orderlength == index2
        disp('Order1 finished');
        break;
    end
    index = 0;
    for j = count:index2
        index = index + 1;
        Order1(index) = Order1(j);
        areaorder1(index) = areaorder1(j);
    end
    index2 = index;
    count = 0;
    i = i + 1;
end

%order2

index2 = length(Order2);
count = 0;
i = 1;

while i <= length(stock)
    currentOrder = Order2;
    if count == 0
        orderlength = index2;
        stockarea = area(stock(i));
        for j = 1:index2
            diff = stockarea - areaorder2(j);
            if diff/stockarea <= 0.1
                count = j;
                orderlength = j -1;
                break;
            end
            print = ['Wood', num2str(j), ' of order2 fits in stock', num2str(i)];
            disp(print);
            stockarea = diff;
        end
    end
    if orderlength == 0
        print = ['Not enough space for order2 in stock', num2str(i)];
        disp(print);
        count = 0;
        i = i + 1;
        continue;
    end
    currentstock = stock(i);
    [result, flag, output] = ordercheck(Order2,currentstock);
    if output.maxconstraint >= 0.5
        count = orderlength;
        orderlength = orderlength - 1;
        print = ['Order2 does not fit in stock', num2str(i)];
        disp(print);
        continue;
    end
    stock(i) = result;
    if orderlength == index2
        disp('Order2 finished');
        break;
    end
    index = 0;
    for j = count:index2
        index = index + 1;
        Order2(index) = Order2(j);
        areaorder2(index) = areaorder2(j);
    end
    index2 = index;
    count = 0;
    i = i + 1;
end

%order3

index2 = length(Order3);
count = 0;
i = 1;

while i <= length(stock)
    currentOrder = Order3;
    if count == 0
        orderlength = index2;
        stockarea = area(stock(i));
        for j = 1:index2
            diff = stockarea - areaorder3(j);
            if diff/stockarea <= 0.1
                count = j;
                orderlength = j -1;
                break;
            end
            print = ['Wood', num2str(j), ' of order3 fits in stock', num2str(i)];
            disp(print);
            stockarea = diff;
        end
    end
    if orderlength == 0
        print = ['Not enough space for order3 in stock', num2str(i)];
        disp(print);
        count = 0;
        i = i + 1;
        continue;
    end
    currentstock = stock(i);
    [result, flag, output] = ordercheck(Order3,currentstock);
    if output.maxconstraint >= 0.5
        count = orderlength;
        orderlength = orderlength - 1;
        print = ['Order3 does not fit in stock', num2str(i)];
        disp(print);
        continue;
    end
    stock(i) = result;
    if orderlength == index2
        disp('Order3 finished');
        break;
    end
    index = 0;
    for j = count:index2
        index = index + 1;
        Order3(index) = Order3(j);
        areaorder3(index) = areaorder3(j);
    end
    index2 = index;
    count = 0;
    i = i + 1;
end