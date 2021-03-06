% Function that compares the automatic segmentation with the ground truth,
% manual segmentation, returning the number of counted cells, true positives, 
% false positives and false negatives and the values of recall, precision 
% and F-measure.
% results_locations - coordinates of the rectangles calculated by
% segmentation.
% positive_locations - coordinates of the rectangles from the ground
% truth.

function [autoNumCells, TP, FP, FN, R, P, F1] = evaluateSegmentation(results_locations, positive_locations)
    % Number of cells in the automatic and manual segmentation is equal to
    % the size of the corresponding array.
    autoNumCells = size(results_locations, 1);
    manualNumCells = size(positive_locations, 1);
    
    % Calculate the Jaccard index matrix for each combination of cells.
    jaccardFullMatrix = zeros(autoNumCells, manualNumCells);       
    for i = 1:autoNumCells    
        autoRectangle = [results_locations(i,2) results_locations(i,1) results_locations(i,3) results_locations(i,4)];        
        for j = 1:manualNumCells
            manualRectangle = [positive_locations(j,2) positive_locations(j,1) positive_locations(j,3) positive_locations(j,4)];            
            jaccardFullMatrix(i,j) = bboxOverlapRatio(autoRectangle,manualRectangle);
        end
    end
    
    % Jaccard Matrix with only the maximum jaccard indexes for each cell.
    jaccardMaxMatrixAuto = zeros(autoNumCells,1);
    for i = 1:autoNumCells        
        jaccardMaxMatrixAuto(i) = max(jaccardFullMatrix(i,:));
    end
    
    jaccardMaxMatrixManual = zeros(manualNumCells,1);
    for i = 1:manualNumCells
        jaccardMaxMatrixManual(i) = max(jaccardFullMatrix(:,i));
    end
    
    % Get the amount of true positives, false positives and false
    % negatives.
    TP = size(find(jaccardMaxMatrixAuto >= 0.5),1);
    FP = size(find(jaccardMaxMatrixAuto < 0.01),1);
    FN = size(find(jaccardMaxMatrixAuto < 0.5),1) + size(find(jaccardMaxMatrixManual < 0.01),1) - FP;    
    
    % Calculus of the recall - the same as sensitivity.
    R = round(TP/(TP+FN),4);
    
    % Calculus of the precision - percentage of object pixels that were
    % correctly segmented using as reference the total number of segmented
    % pixels.
    P = round(TP/(TP+FP),4);
    
    % Calculus of the F-measure -  combines the values of R and P, giving
    % it equal contributions (beta = 1).
    beta = 1;
    F1 = round((((beta^2)+1)*P*R)/(((beta^2)*P)+R),4);
end