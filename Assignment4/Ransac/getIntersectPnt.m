function [x2, y2] = getIntersectPnt(a, b, x, y)
    invSlope = -1 / a;

    b2 = y - invSlope * x;

    x2 = (b - b2) / (invSlope - a);

    y2 = a * x2 + b;
end