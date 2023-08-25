%% Important command
% Quit Brainstorm
% >brainstorm stop      
% Delete existing protocol
% >gui_brainstorm('DeleteProtocol', ProtocolName);
% Get info of current protocol
% >bst_get('ProtocolInfo')
% further information https://neuroimage.usc.edu/brainstorm/Tutorials/Scripting

%% 0. Preparing
disp('ANI1 Group Analysis Brainstorm')
ProtocolName = input('Protocol name: ', 's'); % Masukkan nama protocol
directory = input('Data (.set) directory: ', 's');
%EEGDirectory = 'D:\1-LOCAL STORAGE\Brainstorm_DB' % directory of files .set and .fdt 
UseDefaultAnat = 1; % 1: use protocol's default anatomy, 0: else
UseDefaultChannel = 0; % 0: use one channel per acquisition 
subjectNames = {'0-Base', '1-Rec', '2-Ada', '3-Cre', '4-Int', '5-Prog', '6-Self', '7-Emp', '8-Coll'}; % Add more subject names as needed
substract = numel(subjectNames) - 1; % because 0-Base will not be subject average
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

dir_db = bst_get('BrainstormDbDir');
rootdir = fullfile(dir_db, ProtocolName, 'data');

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
numEEGfile = 0;
for i = 1:length(folder_entries)
    folder = folder_entries(i);
    if folder.isdir
        path_folder = fullfile(directory, folder.name);
        files_set = dir(fullfile(path_folder, '*.set'));
        for j = 1:length(files_set)
            % manipulate file
            numEEGfile = numEEGfile + 1;
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
% Assuming folder_entries is your original table
% Delete the first two rows
folder_entries(1:2, :) = [];

% Assign the modified table to the variable names
names = folder_entries;

%% 5. TimeFreq Analysis
pattern_tmfrq = 'timefreq_morlet*.mat';  % Replace with the desired pattern
pattern_data = 'data*.mat';
files_tmfrq = get_file_paths(rootdir, pattern_tmfrq, 0);
files_data = get_file_paths(rootdir, pattern_data, 0);
if numel(files_tmfrq) ~= numel(files_data)
    if ~isempty(files_tmfrq)
        disp('Replacing Timefreq Files...');
        bst_process('CallProcess', 'process_delete', files_tmfrq, [], 'target', 1);
        timefreq_analysis(files_data);
    else
        disp('Timefreq Analysis');
        timefreq_analysis(files_data);
    end
else
    disp('Skip: Timefreq Analysis')
end

%% 6. Averaging
% 6.1  Subject Averaging
pattern_avgsubj = 'timefreq_average*.mat';
files_tmfrq = get_file_paths(rootdir, pattern_tmfrq, 0 );
files_avgsubj = get_file_paths(rootdir, pattern_avgsubj, 0);
if numEEGfile ~= numel(files_avgsubj)
    if ~isempty(files_avgsubj)
        disp('Replacing Avg File per subject...');
        bst_process('CallProcess', 'process_delete', files_avgsubj, [], 'target', 1);
        subject_average(files_tmfrq);
    else
        disp('Subject Average');
        subject_average(files_tmfrq);
    end
else
    disp('Skip: subject average')
end

% 6.2 Domain Average

skipdir = '0-Base';
files_avgsubj = get_file_paths(rootdir, pattern_avgsubj, 0, skipdir);
files_intra = get_file_paths(rootdir, pattern_avgsubj, 1);
bst_process('CallProcess', 'process_delete', files_intra, [], 'target', 1);
domain_group(files_avgsubj);

% 6.3 Across domain average




