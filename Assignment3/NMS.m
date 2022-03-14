function [mag] = NMS(deg, mag)
    mag_copy = mag;

    for i = 2:size(mag, 1)-1
        for j = 2:size(mag, 2)-1
            if deg(i, j) == 0
                if mag_copy(i, j) == max([mag_copy(i, j-1), mag_copy(i, j), mag_copy(i, j+1)])
                    mag(i, j) = 0;
                else
                    mag(i, j) = 1;
                end
            end
    
            if deg(i, j) == 45
                if mag_copy(i, j) == max([mag_copy(i, j), mag_copy(i+1, j-1), mag_copy(i-1, j+1)])
                    mag(i,j) = 0;
                else
                    mag(i, j) = 1;
                end
            end
    
            if deg(i, j) == 90
                if mag_copy(i, j) == max([mag_copy(i-1, j), mag_copy(i, j), mag_copy(i, j+1)])
                    mag(i, j) = 0;
                else
                    mag(i, j) = 1;
                end
            end
    
            if deg(i, j) == 135
                if mag_copy(i, j) == max([mag_copy(i+1, j+1), mag_copy(i-1, j-1), mag_copy(i, j)])
                    mag(i, j) = 0;
                else
                    mag(i, j) = 1;
                end
            end
        end
    end
end