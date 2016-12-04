%% Object Segmentation: Human RCVCT Behavioral Experiment (TEST VERSION)
% CLPS1520 Final Project
% Debugging version of task, using only 100 images.
%%% ------------------------- TO DO ----------------------------------- %%%
% MERGE DATA SAVING STUFF INTO ACTUAL TASK

%% Startup & participant information
sca; clc; clear;
rng('default'); rng('shuffle'); % randomizes the seed for pseudorandomization
KbName('UnifyKeyNames'); % ensures that grabbing key names works on all operating systems 

% Prompts for subject information in command window, and saves responses in final data struct ('results').
results.subjectID = input('Enter Subject ID (NUM_INIT): ','s');
results.speed = input('Enter Speed (1 = fast, 2 = slow): '); % 1 = 50ms flash, 500ms response; 2 = 100ms flash, 1000ms response
screenSize = input('Full Screen Mode (0 = small, 1 = full): '); % 0 = small screen (for debugging), 1 = full screen (for experiment)

%% Display welcome screen while task is prepared
Screen('Preference', 'SkipSyncTests', 1)
whichscreen = 0;
smallScreen = [0 0 750 500];
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
Screen('TextSize', window, 20);
Screen('TextFont',window,'Helvetica');

[~, ~, ~] = DrawFormattedText(window, 'Preparing the task...' , 'center', 'center', black );
Screen(window, 'Flip');
WaitSecs(1);

%% Specify experiment parameters

if results.speed == 1 % fast version
    stimDuration = 0.05; %50ms image presentation
    respWindow = 0.5; % 500ms to respond
else % slow version
    stimDuration = 0.1; %100ms image presentation
    respWindow = 1; % 1000ms to respond
end
ISI = 0.5; % 500ms regardless of task speed

% '<' (left) = animal, '>' (right) = nonanimal

respKeys = [KbName(',<') KbName('.>')];
escape = KbName('escape');
spacebar = KbName('space');

fixcrossSize = 100;
textSize = 30;
fontColor = black;
leftLocation = [xcenter-380,ycenter]; % adjust as necessary, depending on image sizes
rightLocation = [xcenter+300,ycenter];

%% Retrieves image data
% loads everything one at a time, to minimize any possible confusion with folder names etc. later

% HUMANBAD_ANIMAL (hba)
hba_original_path = '~/Dropbox/RVCT_CLPS1520/humanbad_animal/original';
hba_blurred_path = '~/Dropbox/RVCT_CLPS1520/humanbad_animal/blurred';
hba_colored_path = '~/Dropbox/RVCT_CLPS1520/humanbad_animal/colored';
hba_contrast_path = '~/Dropbox/RVCT_CLPS1520/humanbad_animal/contrast';
addpath(hba_original_path,hba_blurred_path,hba_colored_path,hba_contrast_path);
hba_orig_folder = dir(hba_original_path); hba_orig_folder = hba_orig_folder(3:end);
hba_blur_folder = dir(hba_blurred_path); hba_blur_folder = hba_blur_folder(3:end);
hba_color_folder = dir(hba_colored_path); hba_color_folder = hba_color_folder(3:end);
hba_con_folder = dir(hba_contrast_path); hba_con_folder = hba_con_folder(3:end);

% HUMANGOOD_ANIMAL (hga)
hga_original_path = '~/Dropbox/RVCT_CLPS1520/humangood_animal/original';
hga_blurred_path = '~/Dropbox/RVCT_CLPS1520/humangood_animal/blurred';
hga_colored_path = '~/Dropbox/RVCT_CLPS1520/humangood_animal/colored';
hga_contrast_path = '~/Dropbox/RVCT_CLPS1520/humangood_animal/contrast';
addpath(hga_original_path,hga_blurred_path,hga_colored_path,hga_contrast_path);
hga_orig_folder = dir(hga_original_path); hga_orig_folder = hga_orig_folder(3:end);
hga_blur_folder = dir(hga_blurred_path); hga_blur_folder = hga_blur_folder(3:end);
hga_color_folder = dir(hga_colored_path); hga_color_folder = hga_color_folder(3:end);
hga_con_folder = dir(hga_contrast_path); hga_con_folder = hga_con_folder(3:end);

% HUMANBAD_NONANIMAL (hbna)
hbna_original_path = '~/Dropbox/RVCT_CLPS1520/humanbad_nonanimal/original';
hbna_blurred_path = '~/Dropbox/RVCT_CLPS1520/humanbad_nonanimal/blurred';
hbna_colored_path = '~/Dropbox/RVCT_CLPS1520/humanbad_nonanimal/colored';
hbna_contrast_path = '~/Dropbox/RVCT_CLPS1520/humanbad_nonanimal/contrast';
addpath(hbna_original_path,hbna_blurred_path,hbna_colored_path,hbna_contrast_path);
hbna_orig_folder = dir(hbna_original_path); hbna_orig_folder = hbna_orig_folder(3:end);
hbna_blur_folder = dir(hbna_blurred_path); hbna_blur_folder = hbna_blur_folder(3:end);
hbna_color_folder = dir(hbna_colored_path); hbna_color_folder = hbna_color_folder(3:end);
hbna_con_folder = dir(hbna_contrast_path); hbna_con_folder = hbna_con_folder(3:end);

% HUMANGOOD_NONANIMAL (hgna)
hgna_original_path = '~/Dropbox/RVCT_CLPS1520/humangood_nonanimal/original';
hgna_blurred_path = '~/Dropbox/RVCT_CLPS1520/humangood_nonanimal/blurred';
hgna_colored_path = '~/Dropbox/RVCT_CLPS1520/humangood_nonanimal/colored';
hgna_contrast_path = '~/Dropbox/RVCT_CLPS1520/humangood_nonanimal/contrast';
addpath(hgna_original_path,hgna_blurred_path,hgna_colored_path,hgna_contrast_path);
hgna_orig_folder = dir(hgna_original_path); hgna_orig_folder = hgna_orig_folder(3:end);
hgna_blur_folder = dir(hgna_blurred_path); hgna_blur_folder = hgna_blur_folder(3:end);
hgna_color_folder = dir(hgna_colored_path); hgna_color_folder = hgna_color_folder(3:end);
hgna_con_folder = dir(hgna_contrast_path); hgna_con_folder = hgna_con_folder(3:end);

%% Prepares trials
% randomly shuffle images and prepare all trials BEFORE beginning experiment, to prevent lags in image presentation

trialnums = 400; 
imginfo = cell(trialnums,3);
for i = 1:trialnums
    imginfo{i,3} = zeros(1,4);
end
results.trialnum = (1:trialnums)';
results.imgID = randperm(trialnums)';

for i = 1:trialnums
    j = results.imgID(i);
    
    % HUMANBAD_ANIMAL (hba)
    if j >= 1 && j <= 100
        imginfo{i,3}(1) = 2; % HUMAN BAD
        imginfo{i,3}(2) = 1; % ANIMAL
        imginfo{i,3}(4) = respKeys(1); % ANIMAL = CORRECT 
        if j <= 25
            imginfo{i,1} = hba_orig_folder(j).name;
            imginfo{i,2} = imread(hba_orig_folder(j).name); 
            imginfo{i,3}(3) = 1; % ORIGINAL IMAGE
        elseif j > 25 && j <= 50
            j = j - 25;
            imginfo{i,1} = hba_blur_folder(j).name;
            imginfo{i,2} = imread(hba_blur_folder(j).name); 
            imginfo{i,3}(3) = 2; % BLURRED IMAGE
        elseif j > 50 && j <= 75
            j = j - 50;
            imginfo{i,1} = hba_color_folder(j).name;
            imginfo{i,2} = imread(hba_color_folder(j).name); 
            imginfo{i,3}(3) = 3; % COLORED IMAGE
        elseif j > 75 && j <= 100
            j = j - 75;
            imginfo{i,1} = hba_con_folder(j).name;
            imginfo{i,2} = imread(hba_con_folder(j).name); 
            imginfo{i,3}(3) = 4; % CONTRAST IMAGE
        end   
        
    % HUMANGOOD_ANIMAL (hga)
    elseif j > 100 && j <= 200
        imginfo{i,3}(1) = 1; % HUMAN GOOD
        imginfo{i,3}(2) = 1; % ANIMAL
        imginfo{i,3}(4) = respKeys(1); % ANIMAL = CORRECT 
        if j <= 125
            j = j - 100;
            imginfo{i,1} = hga_orig_folder(j).name;
            imginfo{i,2} = imread(hga_orig_folder(j).name); 
            imginfo{i,3}(3) = 1; % ORIGINAL IMAGE
        elseif j > 125 && j <= 150
            j = j - 125;
            imginfo{i,1} = hga_blur_folder(j).name;
            imginfo{i,2} = imread(hga_blur_folder(j).name); 
            imginfo{i,3}(3) = 2; % BLURRED IMAGE
        elseif j > 150 && j <= 175
            j = j - 150;
            imginfo{i,1} = hga_color_folder(j).name;
            imginfo{i,2} = imread(hga_color_folder(j).name); 
            imginfo{i,3}(3) = 3; % COLORED IMAGE
        elseif j > 175 && j <= 200
            j = j - 175;
            imginfo{i,1} = hga_con_folder(j).name;
            imginfo{i,2} = imread(hga_con_folder(j).name); 
            imginfo{i,3}(3) = 4; % CONTRAST IMAGE
        end   
     
    % HUMANBAD_NONANIMAL (hbna)    
    elseif j > 200 && j <= 300
        imginfo{i,3}(1) = 2; % HUMAN BAD
        imginfo{i,3}(2) = 2; % NONANIMAL
        imginfo{i,3}(4) = respKeys(2); % NONANIMAL = CORRECT 
        if j <= 225
            j = j - 200;
            imginfo{i,1} = hbna_orig_folder(j).name;
            imginfo{i,2} = imread(hbna_orig_folder(j).name); 
            imginfo{i,3}(3) = 1; % ORIGINAL IMAGE
        elseif j > 225 && j <= 250
            j = j - 225;
            imginfo{i,1} = hbna_blur_folder(j).name;
            imginfo{i,2} = imread(hbna_blur_folder(j).name); 
            imginfo{i,3}(3) = 2; % BLURRED IMAGE
        elseif j > 250 && j <= 275
            j = j - 250;
            imginfo{i,1} = hbna_color_folder(j).name;
            imginfo{i,2} = imread(hbna_color_folder(j).name); 
            imginfo{i,3}(3) = 3; % COLORED IMAGE
        elseif j > 275 && j <= 300
            j = j - 275;
            imginfo{i,1} = hbna_con_folder(j).name;
            imginfo{i,2} = imread(hbna_con_folder(j).name); 
            imginfo{i,3}(3) = 4; % CONTRAST IMAGE
        end   
        
    % HUMANGOOD_NONANIMAL (hgna)
    elseif j > 300 && j <= 400
        imginfo{i,3}(1) = 1; % HUMAN GOOD
        imginfo{i,3}(2) = 2; % NONANIMAL
        imginfo{i,3}(4) = respKeys(2); % NONANIMAL = CORRECT 
        if j <= 325
            j = j - 300;
            imginfo{i,1} = hgna_orig_folder(j).name;
            imginfo{i,2} = imread(hgna_orig_folder(j).name); 
            imginfo{i,3}(3) = 1; % ORIGINAL IMAGE
        elseif j > 325 && j <= 350
            j = j - 325;
            imginfo{i,1} = hgna_blur_folder(j).name;
            imginfo{i,2} = imread(hgna_blur_folder(j).name); 
            imginfo{i,3}(3) = 2; % BLURRED IMAGE
        elseif j > 350 && j <= 375
            j = j - 350;
            imginfo{i,1} = hgna_color_folder(j).name;
            imginfo{i,2} = imread(hgna_color_folder(j).name); 
            imginfo{i,3}(3) = 3; % COLORED IMAGE
        elseif j > 375 && j <= 400
            j = j - 375;
            imginfo{i,1} = hgna_con_folder(j).name;
            imginfo{i,2} = imread(hgna_con_folder(j).name); 
            imginfo{i,3}(3) = 4; % CONTRAST IMAGE
        end          
    end
end

%%% ------------------------------------------------------------------- %%%

%% Display Experiment Instructions
instructions = imread('~/Dropbox/RVCT_CLPS1520/Slide1.jpg'); % make instructions as powerpoint slide, save as image
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

instructions = imread('~/Dropbox/RVCT_CLPS1520/Slide2.jpg'); % make instructions as powerpoint slide, save as image
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

%%% ---- save blockSequence as cell array (rows = trials) ------------- %%%
% column1 = image IDs (from 'blockFileIDs', created above)
% column2 = image matrices (from 'blockImages', created above)
% column3 = 1x4 matrix of image information
% column1: 1 = animal, 2 = nonanimal
% column2: 1 = humans > CNN, 2 = CNN > humans (according to Serre Lab paper)
% column3: 1 = original, 2 = blurred, 3 = colored, 4 = contrast
% column4: correct trial response (respKey(1) = animal, respKey(2) = nonanimal)
%%% ------------------------------------------------------------------- %%%

results.blockSequence = imginfo;

%% Display block startup screen

Screen('TextSize',window,textSize);
[~,~,~] = DrawFormattedText(window,'Press < (left) if ANIMAL, or > (right) if NON-ANIMAL','center','center',black);
[~,~,~] = DrawFormattedText(window,'Press the spacebar to start!','center',ycenter+75,black);
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
        [~,~,~] = DrawFormattedText(window,'Please take a quick break, then press spacebar to continue.','center','center',black);
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

% Save data
save(fullfile('~/Dropbox','RVCT_CLPS1520','data_test',sprintf('%s.mat',results.subjectID)),'-struct','results');

%% END OF EXPERIMENT %%
Screen('TextSize',window,textSize);
[~,~,~] = DrawFormattedText(window,'Great job, you finished! Thank you!','center','center',black);
Screen(window,'Flip');
WaitSecs(1.5);
Screen('Closeall')