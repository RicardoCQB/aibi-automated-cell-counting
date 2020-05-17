function plotGroundTruth(i, topLine, leftColumn)
% This function plots the ideal cell segmentation as a green rectangle.
    nameResultsDir = 'train-images\train';
    resultsFolderInfo = dir(nameResultsDir);
    results = load(strcat(nameResultsDir, '\', resultsFolderInfo(i).name));
    results = results.cell_roi_pos;
    
    % Creates a green rectangle around the cell.
    for n=1:size(results, 1)
        rectangle('Position', [results(n,1)-topLine results(n,2)-leftColumn results(n,3) results(n,4)], 'EdgeColor', 'g', 'LineWidth', 2)
    end
    
end