function display_confusion_matrix_expand(confusion_matrix, class_num)
    line = "-------------";
    for i = 1 : length(class_num)
        line = line + "-------------";
    end

    if length(class_num) == 12
        line = extractBetween(line, 1, strlength(line)-4);
    elseif length(class_num) == 25
        line = extractBetween(line, 1, strlength(line)-6);
    end
    line = line + "\n";
    
    fprintf(line);
    fprintf("|Class ID |");
    for i= 1: length(class_num)
        if mod(i, 5) == 0
            fprintf("     %s     |", string(class_num{i}));
        else
            fprintf("    %s    |", string(class_num{i}));
        end
    end
    fprintf("\n");
    
    sum = 0;
    fprintf(line);
    for i= 1 : length(class_num)
        fprintf("|    %s    |", string(class_num{i}));
        for j = 1: length(confusion_matrix)
            num = sprintf('%.2f', confusion_matrix(i,j));

            if strlength(num) == 4
                fprintf("  %s%%  |", num); 
            elseif strlength(num) == 5
                fprintf(" %s%% |", num);
            elseif strlength(num) == 6
                fprintf("%s%% |", num); 
            end

            if i == j
                sum = sum + confusion_matrix(i, j);
            end        
        end
        fprintf("\n");
        fprintf(line);
    end
    fprintf("Sum: %.2f%%\nAverage: %02.2f%%\n", sum, sum/length(class_num));
end