function plotGroundTruth(i, topLine, leftColumn)
    nameResultsDir = 'C:\Users\maria\Documents\GitHub\aibi-automated-cell-counting\train-images\train';
    resultsFolderInfo = dir(nameResultsDir);
    results = load(strcat(nameResultsDir, '\', resultsFolderInfo(i).name))
    results = results.cell_roi_pos;
    for n=1:size(results, 1)
        rectangle('Position', [results(n,1)-topLine results(n,2)-leftColumn results(n,3) results(n,4)], 'EdgeColor', 'g', 'LineWidth', 2)
    end
end