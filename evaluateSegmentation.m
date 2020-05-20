% Function that compares the automatic segmentation with the ground truth,
% manual segmentation, returning the number of cells found in both of them,
% the number of true positives, false positives and false negatives and the
% values of recall, precision and F-measure

function [autoNumCells, manualNumCells, TP, FP, FN, R, P, F1] = evaluateSegmentation(results_locations, positive_locations)
    % Number of cells in the automatic and manual segmentation is equal to
    % the size of the corresponding array
    autoNumCells = size(results_locations, 1);
    manualNumCells = size(positive_locations, 1);
    
    TP = 0; FP = 0; FN = 0;
    % Runs the cells from the ground truth
    for i=1:manualNumCells
        positiveCell = positive_locations(i);
        for j=1:autoNumCells
            cell = results_locations(j);
            % CONDIÇÕES E TAL
        end
    end
    
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