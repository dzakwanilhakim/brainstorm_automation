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

% Display the table
disp(recapTable);

%save
%filename = 'RS4-RS3_round.xlsx'; %rename the file
%writetable(recapTable, filename,'WriteRowNames', true);