%% Object Segmentation: Human RCVCT Behavioral Experiment (SKELETON - V1)
% CLPS1520 Final Project

%% Startup & participant information 
sca; clc; clear; 
rng('default'); rng('shuffle'); % randomizes the seed for pseudorandomization

% Prompts for subject information in command window, and saves responses in final data struct ('results'). 
results.subjectID = input('Enter Subject ID (NUM_INIT): ','s');
results.speed = input('Enter Speed (1 = fast, 2 = slow): '); % 1 = 50ms flash, 500ms response; 2 = 100ms flash, 1000ms response
screenSize = input('Full Screen Mode (0/1): '); % 0 = small screen (for debugging), 1 = full screen (for experiment)
computer = input('Computer? (1 = windows, 2 = mac, 3 = linux): '); % used to determine keycodes (allows experiment to be run on variety of computers)

%% Display welcome screen while task is prepared
Screen('Preference', 'SkipSyncTests', 1)
whichscreen = 0;
smallScreen = [0 0 1000 750]; 
switch screenSize
    case 0 % opens smallScreen (debugging) 
        [window, rect] = Screen(whichscreen,'OpenWindow', [], smallScreen); 
    case 1 % opens fullScreen (experiment) 
        [window, rect] = Screen(whichscreen,'OpenWindow');  
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
numBlocks = x; % specify number of blocks (however we choose to do this?) 

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

%if computer == 1 % windows
%    respKeys = [188 190];
%    spacebar = 32;
%    escape = 27;
%elseif computer == 2 % mac
%    respKeys = []; % check with KbDemo
%    spacebar = [];
%    escape = [];
%else % linux
%    respKeys = []; % check with KbDemo
%    spacebar = [];
%    escape = [];
%end 

fixcrossSize = 100;
textSize = 30;
fontColor = black;
leftLocation = [xcenter-380,ycenter]; % adjust as necessary, depending on image sizes
rightLocation = [xcenter+380,ycenter];

%% Retrieves image data 
% adds image folders to path
nonanimalHuman_path = '~/nonanimal/human_good';
nonanimalCNN_path =  '~/nonanimal/CNN_good';
animalHuman_path = '~/animal/human_good';
animalCNN_path = '~/animal/CNN_good';
addpath(nonanimalHuman_path,nonanimalCNN_path,animalHuman_path,animalCNN_path);

% Build the trial results (TR) table early on so that the task can reference it instead of building task structure online.

trialnums = 400; % replace this later so it matches with total # of images
results = table;
results.trialnum = 1:trialnums';
results.folderID = randperm(4,trialnums)'; % so animal HG, animal CNNG, non-animal HG, non-animal CCNG
results.imgID = randperm(trialnums, trialnums)';

% saves lists of folder contents and saves image filenames
nonanimalHuman_folder = dir(nonanimalHuman_path);
for img = length(nonanimalHuman_folder)
    nhImages{img} = nonanimalHuman_folder(img).name;
end

nonanimalCNN_folder = dir(nonanimalCNN_path);
for img = length(nonanimalCNN_folder)
    ncImages{img} = nonanimalCNN_folder(img).name;
end

animalHuman_folder = dir(animalHuman_path);
for img = length(animalHuman_folder)
    ahImages{img} = animalHuman_folder(img).name;
end

animalCNN_folder = dir(animalCNN_path);
for img = length(animalCNN_folder)
    acImages{img} = animalCNN_folder(img).name;
end

% loads all images
for i = 1:length(acImages) % assumes all folders contain the same number of image filenames
    imread(nhImages{i});
    imread(ncImages{i});
    imread(ahImages{i});
    imread(acImages{i});
end

%%% ------------------------- TO DO ----------------------------------- %%%
%% Oranizes Image Data 
% organize loaded images so that they can be shuffled and randomly
% presented in experiment, and still identified as belonging to their image
% category (nonanimal/humans good, nonanimal/CNNs good, etc.) 

% further separate images by editing (blurred, sharpened, etc.) 

% SAVE IMAGE MATRICES FOR EACH BLOCK HERE (cell array, numTrials x 1)
blockImages = [];
results.blockImages = blockImages; 
    % repeat for each block (if more than one block...?)

%% Prepares trials 
% randomly shuffle images and prepare all trials BEFORE beginning
% experiment, to prevent lags in image presentation 

% SAVE IMAGE IDs FOR EACH BLOCK HERE (cell array, numTrials x 1)
blockFileIDs = [];
results.blockFileIDs = blockFileIDs;
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

%% BLOCK LOOP %% 

%%% -------------------------- TO DO ---------------------------------- %%%
% determine how blocks are going to be organized (if at all). Give breaks
% after x number of images? Just have participants go straight through? 
%%% ------------------------------------------------------------------- %%%

numBlocks = [];
numTrials = [];

for blockNumber = 1:numBlocks
    
    %%% ---- save block sequence as cell array (columns = trials) ----- %%%
    % column1 = image IDs (from 'blockFileIDs', created above) 
    % column2 = image matrices (from 'blockImages', created above)
    % column2 = 1x4 matrix of image information
            % column1: 1 = animal, 2 = nonanimal
            % column2: 1 = humans > CNN, 2 = CNN > humans (according to Serre Lab paper)
            % column3: 1 = blurred, 2 = lightened, 3 = colored, 4 = darkened, 5 = original
            % column4: correct trial response (respKey(1) = animal, respKey(2) = nonanimal)
    %%% --------------------------------------------------------------- %%%
            
    imageInfo = cell(numTrials,1);
    for trial = 1:numTrials
        imageInfo{trial} = zeros(1,4); % fill with actual information somehow?
    end
           
    % column1: imageID, column2: concept = 1 (positive) or 2 (negative), column3: correctKey = 188 (yes) or 190 (no) 
    blockSeq = horzcat(blockFileIDs,imageInfo);
    results.blockSequence = blockSeq; 
    
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
    for trialNumber = 1:numTrials
        
        % load current image and prepare on back buffer 
        trialImg = blockSeq{trialNumber,2};
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
        
        Screen('FillRect', window, white);
        flipped = 0; % 0 = response window hasn't passed yet (no fixation cross), 1 = flipped to fixation cross 

        while ((isempty(find(keycode(respKeys))) || length(find(keycode))>1) && (secs-start_time)<respWindow);                                  % Waits for subject to respond with either of the appropriate keys
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
            if blockRandSeq(trialNumber,3) == responseMade 
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
        results.correctResponses(trialNumber,blockNumber) = blockRandSeq(trialNumber,3);
        results.responsesMade(trialNumber,blockNumber) = responseMade;
        results.responseScores(trialNumber,blockNumber) = responseScore;
        results.responseTimes(trialNumber,blockNumber) = responseTime;
    end

%% End-of-block transition
    if blockNumber < numBlocks % if the current block isn't the last block
        Screen('TextSize',window,textSize)
        [~,~,~] = DrawFormattedText(window,sprintf('End of block %d',blockNumber),'center',ycenter-100,black); 
        
        % displays mean response accuracy for block 
        percentCorrect = round(nanmean(results.responseScores(:,blockNumber))*100);
        [~,~,~] = DrawFormattedText(window,sprintf('You answered %d%% percent of trials correctly.',percentCorrect),'center','center',black);
        if percentCorrect < 55 
            [~,~,~] = DrawFormattedText(window,'Please try your best next time!','center',ycenter+75,black);
        else 
            [~,~,~] = DrawFormattedText(window,'Good job!','center',ycenter+100,black);
        end      
        
        [~,~,~] = DrawFormattedText(window,'Press spacebar to go to the next block.','center',ycenter+200,black);
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
        end;
    end
end

%% END OF EXPERIMENT %% 
Screen('TextSize',window,textSize);
[~,~,~] = DrawFormattedText(window,'Great job, you finished! Thank you!','center','center',black); 
Screen(window,'Flip');
WaitSecs(1.5);
Screen('Closeall') 
