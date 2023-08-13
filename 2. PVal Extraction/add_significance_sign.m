% Assuming recapTable is already created and rounded
% recapTable = ...

% Create a new cell array to store the modified values
modifiedValues = cell(size(recapTable));

% Iterate through the recapTable and apply the condition
for i = 1:size(recapTable, 1)
    for j = 1:size(recapTable, 2)
        value = recapTable{i, j};
        if value < 0.01
            modifiedValues{i, j} = [num2str(value), '**'];
        elseif value < 0.05
            modifiedValues{i, j} = [num2str(value), '*'];
        else
            modifiedValues{i, j} = num2str(value);
        end
    end
end

% Create a new table with the modified values and the same row and column names
modifiedRecapTable = cell2table(modifiedValues, 'VariableNames', recapTable.Properties.VariableNames);
modifiedRecapTable.Properties.RowNames = recapTable.Properties.RowNames;

% Set the filename for the Excel file
filename = 'RS4-RS3_significance sign.xlsx';

% Write the modifiedRecapTable to Excel
writetable(modifiedRecapTable, filename,'WriteRowNames', true);
