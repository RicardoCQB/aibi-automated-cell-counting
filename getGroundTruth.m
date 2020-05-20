% Function that returns the positive locations of the cells obtained
% through manual segmentation.

function positive_locations = getGroundTruth(i)
    % Get the ideal cell locations from the manual segmentation.
    nameResultsDir = 'train-images\train';
    resultsFolderInfo = dir(nameResultsDir);
    results = load(strcat(nameResultsDir, '\', resultsFolderInfo(i).name));
    positive_locations = results.cell_roi_pos;
    
    % Creates a green rectangle around the located cells. % ELIMINAR
    for n=1:size(positive_locations, 1)
        rectangle('Position', [positive_locations(n,1) positive_locations(n,2) positive_locations(n,3) positive_locations(n,4)], 'EdgeColor', 'g', 'LineWidth', 1)
    end
end