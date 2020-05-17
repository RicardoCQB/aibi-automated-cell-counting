% Function that returns the positive locations of the cells obtained
% through manual segmentation, displaying it

function positive_locations = plotGroundTruth(i)
    % This function plots the ideal cell segmentation as a green rectangle.
    nameResultsDir = 'train-images\train';
    resultsFolderInfo = dir(nameResultsDir);
    results = load(strcat(nameResultsDir, '\', resultsFolderInfo(i).name));
    positive_locations = results.cell_roi_pos;
    
    % Creates a green rectangle around the cell.
    for n=1:size(positive_locations, 1)
        rectangle('Position', [positive_locations(n,1) positive_locations(n,2) positive_locations(n,3) positive_locations(n,4)], 'EdgeColor', 'g', 'LineWidth', 1)
    end
end