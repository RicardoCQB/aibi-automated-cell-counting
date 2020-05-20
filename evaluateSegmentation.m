% Function that compares the automatic segmentation with the ground truth,
% manual segmentation, returning the number of cells found in both of them,
% the number of true positives, false positives and false negatives and the
% values of recall, precision and F-measure

function [autoNumCells, manualNumCells, TP, FP, FN, R, P, F1] = evaluateSegmentation(results_locations, positive_locations)
    % Number of cells in the automatic and manual segmentation is equal to
    % the size of the corresponding array
    % results_locations - coordinates of the rectangles calculated by segmentation
    % positive_locations - coordinates of the rectangles from the ground truth
    
    autoNumCells = size(results_locations, 1);
    manualNumCells = size(positive_locations, 1);
    
    % Calculate the Jaccard index matrix for each combination of cells.
    jaccardFullMatrix = zeros(autoNumCells, manualNumCells);       
    
    TP = 0; FP = 0; FN = 0;
    % Runs the cells from the ground truth
    for i = 1:autoNumCells        
        autoCellMask = createCellMask(results_locations(i,1), results_locations(i,2),results_locations(i,3),results_locations(i,4));        
        for j = 1:manualNumCells
            manualCellMask = createCellMask(positive_locations(j,1), positive_locations(j,2),positive_locations(j,3),positive_locations(j,4));
            jaccardFullMatrix(i,j) = jaccard(autoCellMask, manualCellMask);
        end
    end
    
    % Jaccard Matrix with only the maximum jaccard indexes for each cell.
    jaccardMaxMatrixAuto = zeros(autoNumCells);
    jaccardMaxMatrixAuto(:) = max(jaccardFullMatrix(:));
    
    jaccardFullMatrixTranspose = transpose(jaccardFullMatrix);
    jaccardMaxMatrixManual(:) = max(jaccardFullMatrixTranspose(:));
    
    TP = size(find(jaccardMaxMatrixAuto >= 0.5));
    FP = size(find(jaccardMaxMatrixAuto));
    FN = size(find(jaccardMaxMatrixAuto < 0.5)) + size(find(jaccardMaxMatrixManual));    
    
    % Calculus of the recall - the same as sensitivity
    R = TP/(TP+FN);
    
    % Calculus of the precision - percentage of object pixels that were
    % correctly segmented using as reference the total number of segmented
    % pixels
    P = TP/(TP+FP);
    
    % Calculus of the F-measure -  combines the values of R and P, giving
    % it equal contributions (beta = 1)
    beta = 1;
    F1 = (((beta^2)+1)*P*R)/(((beta^2)*P)+R);
end