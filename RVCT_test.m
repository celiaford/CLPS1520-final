%% Object Segmentation: Human RCVCT Behavioral Experiment (TEST VERSION)
% CLPS1520 Final Project
% Debugging version of task, using only 100 images.
%%% ------------------------- TO DO ----------------------------------- %%%
% MERGE DATA SAVING STUFF INTO ACTUAL TASK

%% Startup & participant information
sca; clc; clear;
rng('default'); rng('shuffle'); % randomizes the seed for pseudorandomization

% Prompts for subject information in command window, and saves responses in final data struct ('results').
results.subjectID = input('Enter Subject ID (NUM_INIT): ','s');
results.speed = input('Enter Speed (1 = fast, 2 = slow): '); % 1 = 50ms flash, 500ms response; 2 = 100ms flash, 1000ms response
screenSize = input('Full Screen Mode (0/1): '); % 0 = small screen (for debugging), 1 = full screen (for experiment)

fnamebody = '_RVCT';
files.mat = fullfile(cd, 'data', [results.subjectID fnamebody '.mat']);
files.esc = fullfile(cd, 'data', ...
    sprintf('%s%s_esc_%s.mat', results.subjectID, fnamebody, ...
    datestr(now, 'mmddyy_HHMMSS') ) );

%% Display welcome screen while task is prepared
Screen('Preference', 'SkipSyncTests', 1)
whichscreen = 0;
smallScreen = [0 0 1000 750];
switch screenSize
    case 0 % opens smallScreen (debugging)
        [window, rect] = Screen(whichscreen,'OpenWindow', [], smallScreen);
    case 1 % opens fullScreen (experiment)
        [window, rect] = Screen(whichscreen,'OpenWindow');
        HideCursor(window);
        ListenChar(2)
end

white = WhiteIndex(window); % white pixel intensity
black = BlackIndex(window); % black pixel intensity
xcenter = rect(3)/2; % x coordinate of center
ycenter = rect(4)/2; % y coordinate of center
Screen('TextSize', window, 30);
Screen('TextFont',window,'Helvetica');

[~, ~, ~] = DrawFormattedText(window, 'Preparing the task...' , 'center', 'center', black );
Screen(window, 'Flip');
WaitSecs(1);

%% Specify experiment parameters

if results.speed == 1 % fast version
    stimDuration = 0.05; %50ms image presentation
    respWindow = 0.5; % 500ms to respond
else % slow version
    stimDuraction = 0.1; %100ms image presentation
    respWindow = 1; % 1000ms to respond
end
ISI = 0.5; % 500ms regardless of task speed

% '<' (left) = animal, '>' (right) = nonanimal

respKeys = [KbName('<') KbName('>')];
escape = [KbName('escape')];
spacebar = KbName('space');

fixcrossSize = 100;
textSize = 30;
fontColor = black;
leftLocation = [xcenter-380,ycenter]; % adjust as necessary, depending on image sizes
rightLocation = [xcenter+380,ycenter];

%% Retrieves image data
% adds image folders to path
humangood_animal_path = '~/Dropbox/RVCT_CLPS1520/humangood_animal';
humanbad_animal_path =  '~/Dropbox/RVCT_CLPS1520/humanbad_animal';
humangood_nonanimal_path = '~/Dropbox/RVCT_CLPS1520/humangood_nonanimal';
humanbad_nonanimal_path =  '~/Dropbox/RVCT_CLPS1520/humanbad_nonanimal';
addpath(genpath(humangood_animal_path));
addpath(genpath(humanbad_animal_path));
addpath(genpath(humangood_nonanimal_path));
addpath(genpath(humanbad_nonanimal_path));


%% Prepares trials
% randomly shuffle images and prepare all trials BEFORE beginning
% experiment, to prevent lags in image presentation

% Build the trial results (TR) table early on so that the task can reference it instead of building task structure online.

trialnums = 100; % replace this later so it matches with total # of images
imginfo = cell(trialnums,3);
for i = 1:trialnums
    imginfo{i,3} = zeros(1,4);
end
results.trialnum = 1:trialnums';
results.imgID = randperm(trialnums, trialnums)';

for i = 1:trialnums
    imgID = results(i).imgID;
    j = imgID;
    j = j - 100;
    imginfo{i,3}(1) = 2; % HUMAN BAD
    imginfo{i,3}(2) = 1; % ANIMAL
    imginfo{i,3}(4) = respKeys(1); % ANIMAL
    if j <= 25
        folder = dir('~/Dropbox/RVCT_CLPS1520/humanbad_animal/original');
        folder = folder(4:end);
        imginfo{i,1} = folder(j).name;
        imginfo{i,2} = imread(folder(j).name); %% FIX THIS AND THEN MAKE IT UNIFORM DOWN THERE
        imginfo{i,3}(3) = 1; % ORIGINAL IMAGE
    end
    if j > 25 && j <= 50
        j = j - 25;
        folder = dir('~/Dropbox/RVCT_CLPS1520/humanbad_animal/blurred');
        folder = folder(4:end);
        imginfo{i,1} = blurred(j).name;
        imginfo{i,2} = imread(blurred(j).name); %% FIX THIS AND THEN MAKE IT UNIFORM DOWN THERE
        imginfo{i,3}(3) = 2; % BLURRED IMAGE
    end
    if j > 50 && j <= 75
        j = j - 50;
        folder = dir('~/Dropbox/RVCT_CLPS1520/humanbad_animal/colored');
        folder = folder(4:end);
        imginfo{i,1} = blurred(j).name;
        imginfo{i,2} = imread(blurred(j).name); %% FIX THIS AND THEN MAKE IT UNIFORM DOWN THERE
        imginfo{i,3}(3) = 3; % COLORED IMAGE
    end
    if j > 75 && j <= 100
        j = j - 75;
        folder = dir('~/Dropbox/RVCT_CLPS1520/humanbad_animal/contrast');
        folder = folder(4:end);
        imginfo{i,1} = blurred(j).name;
        imginfo{i,2} = imread(blurred(j).name); %% FIX THIS AND THEN MAKE IT UNIFORM DOWN THERE
        imginfo{i,3}(3) = 4; % CONTRAST IMAGE
    end
    
end

% repeat for each block (if more than one block...?)

%%% ------------------------------------------------------------------- %%%

%% Display Experiment Instructions
instructions = imread('~/instructions.jpg'); % make instructions as powerpoint slide, save as image
imageTexture = Screen('MakeTexture', window, instructions);
Screen('DrawTexture', window, imageTexture, [], [], 0);
Screen(window,'Flip')

% captures keyboard until spacebar is pressed
[~,~,keycode] = KbCheck;
while (~keycode(spacebar));
    [~,~,keycode] = KbCheck;
    WaitSecs(0.001); % ensures that loop doesn't hog CPU
    if find(keycode) == escape; % closes screen if escape key is pressed
        Screen('Closeall')
    end
end;
while KbCheck;
end;

%% TRIAL LOOP %%

%%% ---- save block sequence as cell array (rows = trials) ----- %%%
% column1 = image IDs (from 'blockFileIDs', created above)
% column2 = image matrices (from 'blockImages', created above)
% column3 = 1x4 matrix of image information
% column1: 1 = animal, 2 = nonanimal
% column2: 1 = humans > CNN, 2 = CNN > humans (according to Serre Lab paper)
% column3: 1 = original, 2 = blurred, 3 = colored, 4 = contrast
% column4: correct trial response (respKey(1) = animal, respKey(2) = nonanimal)
%%% --------------------------------------------------------------- %%%

results.blockSequence = imginfo;

%% Display block startup screen

Screen('TextSize',window,textSize);
[~,~,~] = DrawFormattedText(window,'Press < (left) if ANIMAL, or > (right) if NON-ANIMAL','center','center',black);
[~,~,~] = DrawFormattedText(window,'Press the spacebar to continue!','center',ycenter+75,black);
Screen(window,'Flip');

% captures keyboard until spacebar is pressed
[~,~,keycode] = KbCheck;
while (~keycode(spacebar));
    [~,~,keycode] = KbCheck;
    WaitSecs(0.001); % ensures that loop doesn't hog CPU
    if find(keycode) == escape; % closes screen if escape key is pressed
        Screen('Closeall')
    end
end;
while KbCheck;
end;

% once spacebar is pressed, display text and move on
[~,~,~] = DrawFormattedText(window,'get ready!','center','center',black);
Screen(window,'Flip');
WaitSecs(3);

%% TRIAL LOOP %%

for trialNumber = 1:trialnums
    if mod(trialNumber,50) ~= 0
        
        % load current image and prepare on back buffer
        trialImg = imginfo{trialNumber,2};
        imageTexture = Screen('MakeTexture', window, trialImg);
        Screen('DrawTexture', window, imageTexture, [], [], 0);
        
        % prepare text on back buffer
        Screen('TextSize',window,textSize);
        [~,~,~] = DrawFormattedText(window,'Animal',leftLocation(1),leftLocation(2),black);
        [~,~,~] = DrawFormattedText(window,'Non-Animal',rightLocation(1),rightLocation(2),black);
        
        % show stimulus and text
        Screen(window,'Flip');
        WaitSecs(stimDuration);
        
        % prepare fixation cross on back buffer
        Screen('TextSize',window,fixcrossSize);
        [~,~,~] = DrawFormattedText(window,'+','center','center',black);
        
        %% Determine trial accuracy and present feedback
        start_time = GetSecs; % records start time
        [~,secs,keycode] = KbCheck; % secs = time passed since start of KbCheck
        
        flipped = 0; % 0 = response window hasn't passed yet (no fixation cross), 1 = flipped to fixation cross
        
        while ((isempty(find(keycode(respKeys))) || length(find(keycode))>1) && (secs-start_time)<respWindow); % Waits for subject to respond with either of the appropriate keys
            [~,secs,keycode] = KbCheck;
            WaitSecs(0.001);
            if find(keycode)==escape; % close everything if the escape key is pressed
                Screen('Closeall')
            end
            if ~flipped && (secs-start_time >= stimDuration) % flip to blank screen, if stimDuration has passed
                Screen(window,'Flip');
                flipped = 1;
            end
        end
        
        if flipped == 0
            Screen(window,'Flip');
        end
        
        responseMade = find(keycode); % records response made
        
        Screen('TextSize',window,textSize)
        
        if ~isempty(responseMade)
            responseTime=(secs-start_time)*1000;
            if imginfo{trialNumber,3}(4) == responseMade
                responseScore = 1;
            else
                responseScore = 0;
            end
        elseif isempty(responseMade)
            responseMade = 0;
            responseTime = 0;
            responseScore = 0;
            [~,~,~] = DrawFormattedText(window,'Respond Faster!','center','center',[228,25,25]);
        end
        
        Screen(window,'Flip');
        WaitSecs(ISI);
        
        %% Save trial responses in 'results' struct
        results.correctResponses(trialNumber) = imginfo{trialNumber,3}(4);
        results.responsesMade(trialNumber) = responseMade;
        results.responseScores(trialNumber) = responseScore;
        results.responseTimes(trialNumber) = responseTime;
        
    elseif mod(trialNumber,100) == 0 && trialNumber ~= 400
        [~,~,~] = DrawFormattedText(window,'Please take a quick break, then press spacebar to continue.','center',ycenter+200,black);
        Screen(window,'Flip');
        WaitSecs(1.5);
        
        % captures keyboard until spacebar is pressed
        [~,~,keycode] = KbCheck;
        while (~keycode(spacebar));
            [~,~,keycode] = KbCheck;
            WaitSecs(0.001); % ensures that the loop doesn't hog the CPU
            if find(keycode) == escape; % closes screen if escape key is pressed
                Screen('Closeall')
            end
        end;
        while KbCheck;
        end
    end
end

save(files.mat, 'subject', 'results');

% Save data



%% END OF EXPERIMENT %%
Screen('TextSize',window,textSize);
[~,~,~] = DrawFormattedText(window,'Great job, you finished! Thank you!','center','center',black);
Screen(window,'Flip');
WaitSecs(1.5);
Screen('Closeall')
