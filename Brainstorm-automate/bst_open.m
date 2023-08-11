%% Important command
% Quit Brainstorm
% >brainstorm stop      
% Delete existing protocol
% >gui_brainstorm('DeleteProtocol', ProtocolName);
% Get info of current protocol
% >bst_get('ProtocolInfo')
% further information https://neuroimage.usc.edu/brainstorm/Tutorials/Scripting

%% 0. Preparing
ProtocolName = 'ITDRI'; % Masukkan nama protocol
EEGDirectory = 'D:\1-LOCAL STORAGE\Brainstorm_DB' % directory of files .set and .fdt 
UseDefaultAnat = 1; % 1: use protocol's default anatomy, 0: else
UseDefaultChannel = 0; % 0: use one channel per acquisition 
subjectNames = {'0-Base', '1-Rec', '2-Ada', '3-Cre', '4-Int', '5-Prog', '6-Self', '7-Emp', '8-Coll'}; % Add more subject names as needed
%BrainstormDbDir = 'D:\1-LOCAL STORAGE\Brainstorm_DB'; % Path to a Brainstorm database (= a folder that contains one or more Brainstorm protocols)

%% 1. Start BST
if ~brainstorm('status')
    brainstorm nogui
end
% 1.1 Protocol
iProtocol = bst_get('Protocol', ProtocolName); % Get the protocol index
if isempty(iProtocol) % check if the protocol is available
    gui_brainstorm('CreateProtocol', ProtocolName, UseDefaultAnat, UseDefaultChannel); % Create protocol
    fprintf('Created protocol %s .\n', ProtocolName);
else
    fprintf('Protocol %s already exists.\n', ProtocolName);
end
gui_brainstorm('SetCurrentProtocol', iProtocol); % Select the current procotol

% 1.2 Subject
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

% 1.3 Import 

