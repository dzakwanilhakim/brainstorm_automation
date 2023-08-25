function fileGroups = grouping_files(files_intra, substract)
    % Initialize a cell array to hold the groups
    numGroups = substract;
    fileGroups = cell(numGroups, 1);
    
    % Loop through each file in the original array
    for i = 1:length(files_intra)
        filePath = files_intra{i}; % Extract the string
        
        % Extract the group identifier (e.g., '1-Rec', '2-Ada', etc.)
        groupIdentifier = strtok(filePath, '\');
        
        % Extract the numeric part of the identifier
        groupIndex = str2double(groupIdentifier(1));
        
        % Add the file to the appropriate group
        if isnan(groupIndex) || groupIndex < 1 || groupIndex > numGroups
            fprintf('Invalid group index in file: %s\n', filePath);
        else
            if isempty(fileGroups{groupIndex})
                fileGroups{groupIndex} = {filePath};
            else
                fileGroups{groupIndex} = [fileGroups{groupIndex}; {filePath}];
            end
        end
    end
    
    % Display the grouped files
    %for i = 1:numGroups
    %    fprintf('Group %d:\n', i);
    %    disp(fileGroups{i});
    %end
end