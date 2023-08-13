data1 = pnpp.pmap;
data2 = pnpf.pmap;
data3 = pnph.pmap;
data4 = pnf.pmap;
data5 = pppf.pmap;
data6 = ppph.pmap;
data7 = ppf.pmap;
data8 = pfph.pmap;
data9 = pff.pmap;
data10 = phf.pmap;
%recap = zeros(3, 5);

for i = 1:10
    % Create the variable name dynamically using eval
    varName = ['data', num2str(i)];
    data = eval(varName);

    delta = round(min(data(:,:,1)), 3);
    theta = round(min(data(:,:,2)), 3);
    alpha = round(min(data(:,:,3)), 3);
    beta = round(min(data(:,:,4)), 3);
    gamma = round(min(data(:,:,5)), 3);
    
    recap(i,:) = [delta, theta, alpha, beta, gamma];
end

% Add headers to columns
colHeaders = {'Delta', 'Theta', 'Alpha', 'Beta', 'Gamma'};
recapTable = array2table(recap, 'VariableNames', colHeaders);

% Add headers to rows
rowHeaders = {'PN_PP',...
    'PN_PF', ...
    'PN_PH', ...
    'PN_F', ...
    'PP_PF', ...
    'PP_PH', ...
    'PP_F', ...
    'PF_PH', ...
    'PF_F', ...
    'PH_F'};
recapTable.Properties.RowNames = rowHeaders;

%add significance sign
modifiedValues = cell(size(recapTable));% Create a new cell array to store the modified values
for i = 1:size(recapTable, 1)% Iterate through the recapTable and apply the condition
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
filename = 'RS4-RS1_significance sign.xlsx'; %Rename new file
% Write the modifiedRecapTable to Excel
writetable(modifiedRecapTable, filename,'WriteRowNames', true);

