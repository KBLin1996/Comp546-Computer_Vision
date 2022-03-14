function mag = Hysteresis_Threshold(mag, low_thresh, high_thresh)
    low_thresh = low_thresh * max(max(mag));
    high_thresh = high_thresh * max(max(mag));
    mag_copy = mag;

    for i = 3 : size(mag, 1)-2
        for j = 3 : size(mag, 2)-2
            if mag_copy(i, j) < low_thresh
                mag(i, j) = 0;

            elseif mag_copy(i, j) > high_thresh
                mag(i, j) = 1;

            %Using 8-connected components
            elseif (mag_copy(i+1,j) > high_thresh || mag_copy(i-1,j) > high_thresh || ...
                    mag_copy(i,j+1) > high_thresh || mag_copy(i,j-1) > high_thresh || ...
                    mag_copy(i-1, j-1) > high_thresh || mag_copy(i-1, j+1) > high_thresh || ...
                    mag_copy(i+1, j+1) > high_thresh || mag_copy(i+1, j-1) > high_thresh)
                    mag(i, j) = 1;
            elseif (mag_copy(i+1,j) > low_thresh || mag_copy(i-1,j) > low_thresh || ...
                    mag_copy(i,j+1) > low_thresh || mag_copy(i,j-1) > low_thresh || ...
                    mag_copy(i-1, j-1) > low_thresh || mag_copy(i-1, j+1) > low_thresh || ...
                    mag_copy(i+1, j+1) > low_thresh || mag_copy(i+1, j-1) > low_thresh)
                if (mag_copy(i+2,j+2) > high_thresh || mag_copy(i+2,j+1) > high_thresh || ...
                    mag_copy(i+2,j) > high_thresh || mag_copy(i,j+2) > high_thresh || ...
                    mag_copy(i+1, j+2) > high_thresh || mag_copy(i-2, j-2) > high_thresh || ...
                    mag_copy(i-2, j-1) > high_thresh || mag_copy(i-2, j) > high_thresh || ...
                    mag_copy(i, j-2) > high_thresh || mag_copy(i-1, j-2) > high_thresh || ...
                    mag_copy(i+1, j-2) > high_thresh || mag_copy(i+2, j-2) > high_thresh || ...
                    mag_copy(i+2, j-1) > high_thresh || mag_copy(i-2, j+1) > high_thresh || ...
                    mag_copy(i-2, j+2) > high_thresh || mag_copy(i-1, j+2) > high_thresh)
                    mag(i, j) = 1;
                else
                    mag(i, j) = 0;
                end
            else
                mag(i, j) = 0;
            end
        end
    end
end