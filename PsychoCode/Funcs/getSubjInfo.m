function [subjectInfo] = getSubjInfo()
    % STARTTASK  Main file for initializing the experiment.
    %            In this first section, we collect subject information
    %            (ID, Age, Gender, and Handedness) and store it in a struct.

    % --- Prompt for subject info ---
    prompt = {'Subject Name:', 'Subject ID:', 'Age:', 'Gender (M/F):', 'Handedness (R/L):'};
    dlgtitle = 'Subject Information';
    dims = [1 35];  % Dimensions of input fields in the dialog
    definput = {'', '', '25', 'M', 'R'};  % Default inputs (optional)

    % Use inputdlg to create a dialog box
    answer = inputdlg(prompt, dlgtitle, dims, definput);

    % If user cancels dialog, exit the function gracefully
    if isempty(answer)
        error('Experiment canceled by user. No subject info was provided.');
    end

    % --- Store subject info in a struct ---
    subjectInfo.Name = answer{1};
    subjectInfo.ID = answer{2};
    subjectInfo.Age = str2double(answer{3});  % convert string to number
    subjectInfo.Gender = answer{4};
    subjectInfo.Handedness = answer{5};

    % --- You might also want to store the date/time for record-keeping ---
    subjectInfo.Date = date;          % Current date as a string
    subjectInfo.StartTime = clock;    % Timestamp for experiment start

    % The function returns subjectInfo to be used in subsequent sections
end
