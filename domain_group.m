function domain_group(files_avgsubj)
    groupedFiles = struct();
    for i = 1:numel(files_avgsubj)
        % Parse the file path using regular expression
        parts = regexp(files_avgsubj{i}, '(\d+-\w+)\\(\w+)_(\w+)_(\d+)\\', 'tokens');    
        % Extract the matched components
        category = parts{1}{1};
        subjectID = parts{1}{2};
        name = parts{1}{3};
        %index = parts{1}{4};    
        % Create a key based on the extracted components
        key = matlab.lang.makeValidName([category '_' subjectID '_' name]);  
        % Check if the key exists in the structure, if not, create it
        if ~isfield(groupedFiles, key)
            groupedFiles.(key) = {};
        end    
        % Add the file to the corresponding key
        groupedFiles.(key){end+1} = files_avgsubj{i};
    end
    % Now, you can access each grouped set of files by their respective keys
    keys = fieldnames(groupedFiles);
    for i = 1:numel(keys)
        % disp(['file ' num2str(i) ' =']);
        % Transpose the cell array to make it 2x1
        groupedFiles.(keys{i}) = groupedFiles.(keys{i}).';
        sFiles = groupedFiles.(keys{i});
        name = keys{i}(2:end);
        domain_average(sFiles, name);
    end
end


