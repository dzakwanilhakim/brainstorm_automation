function filePaths = get_file_paths(rootdir, pattern, parameter, addskippattern)
    %parameter: 0: filter out group analysis, intra study
        %1 : just intra study
        %2 : just group analysis
    filelist = dir(fullfile(rootdir, '**', pattern));  % Get list of files matching the specified pattern in any subfolder 
    filePaths = cell(length(filelist), 1);  % Initialize an empty cell array to store the file paths
    numFilteredPaths = 0;  % Counter for the number of filtered paths 
    if nargin < 4
        addskippattern = '';
    end

    if parameter == 0
    % filter out ('@intra', 'Group_analysis')
    % with or without addskippattern '0-Base'
        skipPatterns = {'Group_analysis', '@'};
        skipPatterns = [skipPatterns, addskippattern];
        for i = 1:length(filelist)
            filePath = fullfile(filelist(i).folder, filelist(i).name);
            if ~any(contains(filePath, skipPatterns))
                numFilteredPaths = numFilteredPaths + 1;
                filePaths{numFilteredPaths} = strrep(filePath, [rootdir, '\'], '');
            end
        end 
        
    elseif parameter == 1
    % filter in just intrastudy {'@intra'} filter out {'Group_analysis'}
        skipPatterns = {'Group_analysis'};
        includePatterns = {'intra'};
        for i = 1:length(filelist)
            filePath = fullfile(filelist(i).folder, filelist(i).name);
            if ~any(contains(filePath, skipPatterns)) && any(contains(filePath, includePatterns))
                numFilteredPaths = numFilteredPaths + 1;
                filePaths{numFilteredPaths} = strrep(filePath, [rootdir, '\'], '');
            end
        end
 
    elseif parameter == 2
        includePatterns = {'Group_analysis'};
        for i = 1:length(filelist)
            filePath = fullfile(filelist(i).folder, filelist(i).name);
            if any(contains(filePath, includePatterns))
                numFilteredPaths = numFilteredPaths + 1;
                filePaths{numFilteredPaths} = strrep(filePath, [rootdir, '\'], '');
            end
        end
    end
       

    % Remove unused preallocated cells and reshape to desired dimensions
    filePaths = filePaths(1:numFilteredPaths);
    filePaths = reshape(filePaths, [], 1);
    %for i = 1:length(filePaths)
    %    disp(filePaths{i});
    %end
end