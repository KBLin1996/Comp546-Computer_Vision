function [bestInlierX, bestInlierY, iter] = RANSAC(x, y, minPoints, disThreshold, plotFig)
    cnt = length(x) + length(y);

    % probability of inlier
    inlierProb = 0.9999;

    % set initial iteraetion to a large value
    iter = 1.e1000;

    maxTotal = minPoints;
    drawX = [-4 4];
    sampleCnt=0;
    while iter > sampleCnt
        totalInlier = 0;

        % data represents one of the x and y respectively
        if size(x, 1) == 1
            % randomly select two indexes
            idx = randperm(length(x),2);

            randX = x(idx);
            randY = y(idx);

            a = (randY(2) - randY(1)) / (randX(2) - randX(1));
            b = randY(1) - a * randX(1);
            moveDis = sqrt(a^2 + 1) * disThreshold;

            clear inlierX;
            clear inlierY;
            for i = 1 : (cnt/2)
                %yVal = a * x(i) + b;
                [disX, disY] = getIntersectPnt(a, b, x(i), y(i));

                % compute the distance of original points and transformation
                % points respectively
                dis = sqrt((x(i) - disX) ^ 2 +(y(i) - disY) ^ 2);
                
                if dis < disThreshold
                    totalInlier = totalInlier + 1;
    
                    inlierX(totalInlier) = x(i);
                    inlierY(totalInlier) = y(i);
                end
            end

        % data contains (x, y) itself
        elseif size(x, 1) == 2
            % randomly select one index
            idx = randperm(length(x), 1);
            
            x1 = x(1, idx);
            y1 = x(2, idx);

            x2 = y(1, idx);
            y2 = y(2, idx);

            a = (y2 - y1) / (x2 - x1);
            b = y1 - a * x1;

            clear inlierX;
            clear inlierY;
            for i = 1 : (cnt/2)
                [originalX, originalY] = getIntersectPnt(a, b, x(1, i), x(2, i));
                [transformX, transformY] = getIntersectPnt(a, b, y(1, i), y(2, i));

                % compute the distance of original points and transformation
                % points respectively
                disOrig = sqrt((x(1, i) - originalX) ^ 2 +(x(2, i) - originalY) ^ 2);
                disTrans = sqrt((y(1, i) - transformX) ^ 2 +(y(2, i) - transformY) ^ 2);
                
                if disOrig < disThreshold && disTrans < disThreshold
                    totalInlier = totalInlier + 1;
    
                    inlierX(:, totalInlier) = x(:, i);
                    inlierY(:, totalInlier) = y(:, i);
                end
            end
        end


        if plotFig
            plot(x, y, 'k.', 'MarkerSize', 12);
    
            hold on;
            plot(inlierX, inlierY,'g.','MarkerSize', 12);
    
            hold on;
            plot(randX, randY,'r.','MarkerSize', 20);
    
            hold on;
            drayY = a * drawX + b;
            plot(drawX, drayY, 'Color', 'b','LineWidth', 1);
            ylim([-4 4]);
            
            hold on;
            plot(drawX, drayY + moveDis, '--m', 'LineWidth', 1);
            
            hold on;
            plot(drawX, drayY - moveDis, '--m', 'LineWidth', 1);        
            hold off;
        end


        % record the best result
        if totalInlier > maxTotal
            maxTotal = totalInlier;

            bestInlierX = inlierX;
            bestInlierY = inlierY;
    
            iter = log(1 - inlierProb) / log(1 - (totalInlier / cnt) ^ minPoints);

            if plotFig
                finalDrawY = drayY;
                finalMoveDis = moveDis;
            end
        end


        % early stopping
        if((totalInlier / (cnt/2)) > 0.7)
            break;
        end

        sampleCnt = sampleCnt + 1;
        pause(0.01);
    end

    % plot the final result for question 1
    if plotFig
        plot(x, y, 'k.','MarkerSize',12);
    
        hold on;
        plot(bestInlierX, bestInlierY,'g.','MarkerSize', 12);
    
        hold on;
        plot(drawX, finalDrawY,'Color', 'r','LineWidth', 2);
        ylim([-4 4]);
    
        hold on;
        plot(drawX, finalDrawY + finalMoveDis, '--m', 'LineWidth', 1);
            
        hold on;
        plot(drawX, finalDrawY - finalMoveDis, '--m', 'LineWidth', 1);        
        hold off;
    end
end