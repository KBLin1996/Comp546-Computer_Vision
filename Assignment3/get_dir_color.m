function [deg, color] = get_dir_color(deg, color)
    red = [255, 0, 0];
    blue = [0, 0, 255];
    green = [0, 255, 0];
    yellow = [255, 255, 0];

    for i = 1 : size(deg, 1)
        for j = 1:size(deg, 2)
            if (deg(i, j) >= 0 && deg(i, j) < 22.5) || (deg(i, j) <= 180 && deg(i, j) >= 157.5)
                deg(i, j) = 0;
                color(i, j, :) = yellow;
            end
    
            if (deg(i, j) >= 22.5 && deg(i, j) < 67.5)
                deg(i, j) = 45;
                color(i, j, :) = green;
            end
    
            if (deg(i, j) >= 67.5 && deg(i, j) < 112.5)
                deg(i, j) = 90;
                color(i, j, :) = blue;
            end
    
            if (deg(i, j) >= 112.5 &&  deg(i, j) < 157.5)
                deg(i, j) = 135;
                color(i, j, :) = red;
            end
        end
    end
end