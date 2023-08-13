%% Important command
% Quit Brainstorm
% >brainstorm stop      
% Delete existing protocol
% >gui_brainstorm('DeleteProtocol', ProtocolName);
% Get info of current protocol
% >bst_get('ProtocolInfo')
% further information https://neuroimage.usc.edu/brainstorm/Tutorials/Scripting

%% 0. Preparing
ProtocolName = 'TEST12345'; % Masukkan nama protocol
directory = 'C:\MATLAB\ITDRI\ITDRI PPF';
%EEGDirectory = 'D:\1-LOCAL STORAGE\Brainstorm_DB' % directory of files .set and .fdt 
UseDefaultAnat = 1; % 1: use protocol's default anatomy, 0: else
UseDefaultChannel = 0; % 0: use one channel per acquisition 
subjectNames = {'0-Base', '1-Rec', '2-Ada', '3-Cre', '4-Int', '5-Prog', '6-Self', '7-Emp', '8-Coll'}; % Add more subject names as needed
%BrainstormDbDir = 'D:\1-LOCAL STORAGE\Brainstorm_DB'; % Path to a Brainstorm database (= a folder that contains one or more Brainstorm protocols)

%% 1. Start BST
if ~brainstorm('status')
    brainstorm nogui
end
%% 2. Protocol
iProtocol = bst_get('Protocol', ProtocolName); % Get the protocol index
if isempty(iProtocol) % check if the protocol is available
    gui_brainstorm('CreateProtocol', ProtocolName, UseDefaultAnat, UseDefaultChannel); % Create protocol
    fprintf('Created protocol %s .\n', ProtocolName);
else
    fprintf('Protocol %s already exists.\n', ProtocolName);
end
gui_brainstorm('SetCurrentProtocol', iProtocol); % Select the current procotol

%% 3. Subject
for i = 1:length(subjectNames) % Loop through the subject names
    currentSubject = subjectNames{i};
    iSubject = bst_get('Subject', currentSubject);  
    if isempty(iSubject)
        db_add_subject(currentSubject, [], UseDefaultAnat, UseDefaultChannel);
        fprintf('Subject %s created.\n', currentSubject);
    else
        fprintf('Subject %s already exists.\n', currentSubject);
    end
end

%% 4. Import 
% Define the directory and file pattern
fileToSubjectMapping = {'0-Base', '1-Rec', '1-Rec', '2-Ada', '2-Ada', '3-Cre', ...
    '3-Cre', '4-Int', '4-Int', '5-Prog', '5-Prog', '6-Self', '6-Self', ...
    '7-Emp', '7-Emp', '8-Coll', '8-Coll'};
folder_entries = dir(directory);
for i = 1:length(folder_entries)
    folder = folder_entries(i);
    if folder.isdir
        path_folder = fullfile(directory, folder.name);
        files_set = dir(fullfile(path_folder, '*.set'));
        for j = 1:length(files_set)
            % manipulate file
            sFiles = [];
            fileSet = files_set(j);
            filenameSet = fileSet.name;
            fullFilePath = fullfile(path_folder, filenameSet) ;
            filenameWoSet = strrep(filenameSet, '.set', '');
            % manipulate suject
            subjectName = fileToSubjectMapping{j};
            % check wheter the study is already exsist or not
            StudyFileName = fullfile(subjectName, filenameWoSet);
            iStudy = bst_get('StudyWithCondition', StudyFileName);
            if isempty(iStudy)
                % Process: Import MEG/EEG: Existing epochs
                sFiles = bst_process('CallProcess', 'process_import_data_epoch', sFiles, [], ...
                    'subjectname',   subjectName, ...
                    'condition',     '', ...
                    'datafile',      {{fullFilePath}, 'EEG-EEGLAB'}, ...
                    'iepochs',       [], ...
                    'eventtypes',    '', ...
                    'createcond',    0, ...
                    'channelalign',  1, ...
                    'usectfcomp',    1, ...
                    'usessp',        1, ...
                    'freq',          256, ...
                    'baseline',      [], ...
                    'blsensortypes', 'MEG, EEG');
                fprintf('Imported: %s, subject: %s \n', filenameWoSet, subjectName);
            else
                fprintf('%s already exists in subject %s.\n', filenameWoSet, subjectName);
            end 
            %disp(['i = ' num2str(i) ', j = ' num2str(j) ', Folder: ' folder.name ', File: ' file.name]);
            %disp(['i = ' num2str(i) ', j = ' num2str(j) ', Folder: ' folder.name ', File: ' file.name]);
        end
    end
end

%% 5. TimeFreq Analysis

%% 6. Averaging
