function subject_average(sFiles)
    bst_process('CallProcess', 'process_average', sFiles, [], ...
        'avgtype',       3, ...  % By folder (subject average)
        'avg_func',      1, ...  % Arithmetic average:  mean(x)
        'weighted',      0, ...
        'matchrows',     1, ...
        'iszerobad',     1);
    
end


