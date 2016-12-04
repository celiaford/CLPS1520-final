%% Object Segmentation: Human RCVCT Behavioral Experiment Analysis
% CLPS1520 Final Project

%% Load raw behavioral data
addpath('~/Dropbox/RVCT_CLPS1520/barwitherr');
datapath = '~/Dropbox/RVCT_CLPS1520/data';
datalist = dir(sprintf('%s/*.mat',datapath));
numSubjects = size(datalist,1);

%% Reads 'results' struct and calculates mean accuracy & RT for each subject
meanAccuracies = zeros(numSubjects,4,4);
meanRTs = zeros(numSubjects,4,4);
% rows = subjects
% columns = image category (col1 = humanbad_animal, col2 = humangood_animal, col3 = humanbad_nonanimal, col4 = humangood_nonanimal)
% sheets = image edit (sheet1 = original, sheet2 = blurred, sheet3 = colored, sheet4 = contrast)
numtrials = 400;

for subject = 1:numSubjects   
    full_datapath = strcat(datapath,'/',datalist(subject).name);
    results = load(full_datapath);
    
    % rows = images, columns = image category, sheets = image edit
    subAccuracies = NaN(numtrials,4,4);
    subRTs = NaN(numtrials,4,4);
    
    for trial = 1:numtrials               
        if results.blockSequence{trial,3}(1) == 1 % ANIMAL            
            if results.blockSequence{trial,3}(2) == 1 % HUMANGOOD
                if results.blockSequence{trial,3}(3) == 1 % ORIGINAL
                    subAccuracies(trial,2,1) = results.responseScores(trial);
                    subRTs(trial,2,1) = results.responseScores(trial);
                elseif results.blockSequence{trial,3}(3) == 2 % BLURRED
                    subAccuracies(trial,2,2) = results.responseScores(trial);
                    subRTs(trial,2,2) = results.responseScores(trial);
                elseif results.blockSequence{trial,3}(3) == 3 % COLORED 
                    subAccuracies(trial,2,3) = results.responseScores(trial);
                    subRTs(trial,2,3) = results.responseScores(trial);
                else % CONTRAST 
                    subAccuracies(trial,2,4) = results.responseScores(trial);
                    subRTs(trial,2,4) = results.responseScores(trial);
                end               
            else % HUMANBAD
                if results.blockSequence{trial,3}(3) == 1 % ORIGINAL
                    subAccuracies(trial,1,1) = results.responseScores(trial);
                    subRTs(trial,1,1) = results.responseScores(trial);
                elseif results.blockSequence{trial,3}(3) == 2 % BLURRED
                    subAccuracies(trial,1,2) = results.responseScores(trial);
                    subRTs(trial,1,2) = results.responseScores(trial);
                elseif results.blockSequence{trial,3}(3) == 3 % COLORED
                    subAccuracies(trial,1,3) = results.responseScores(trial);
                    subRTs(trial,1,3) = results.responseScores(trial);
                else % CONTRAST 
                    subAccuracies(trial,1,4) = results.responseScores(trial);
                    subRTs(trial,1,4) = results.responseScores(trial);
                end
            end              
        else % NONANIMAL            
            if results.blockSequence{trial,3}(2) == 1 % HUMAN GOOD
                if results.blockSequence{trial,3}(3) == 1 % ORIGINAL
                    subAccuracies(trial,4,1) = results.responseScores(trial);
                    subRTs(trial,4,1) = results.responseScores(trial);
                elseif results.blockSequence{trial,3}(3) == 2 % BLURRED
                    subAccuracies(trial,4,2) = results.responseScores(trial);
                    subRTs(trial,4,2) = results.responseScores(trial);
                elseif results.blockSequence{trial,3}(3) == 3 % COLORED 
                    subAccuracies(trial,4,3) = results.responseScores(trial);
                    subRTs(trial,4,3) = results.responseScores(trial);
                else % CONTRAST 
                    subAccuracies(trial,4,4) = results.responseScores(trial);
                    subRTs(trial,4,4) = results.responseScores(trial);
                end               
            else % HUMANBAD
                if results.blockSequence{trial,3}(3) == 1 % ORIGINAL
                    subAccuracies(trial,3,1) = results.responseScores(trial);
                    subRTs(trial,3,1) = results.responseScores(trial);
                elseif results.blockSequence{trial,3}(3) == 2 % BLURRED
                    subAccuracies(trial,3,2) = results.responseScores(trial);
                    subRTs(trial,3,2) = results.responseScores(trial);
                elseif results.blockSequence{trial,3}(3) == 3 % COLORED 
                    subAccuracies(trial,3,3) = results.responseScores(trial);
                    subRTs(trial,3,3) = results.responseScores(trial);
                else % CONTRAST 
                    subAccuracies(trial,3,4) = results.responseScores(trial);
                    subRTs(trial,3,4) = results.responseScores(trial);
                end
            end
        end
    end

    for cat = 1:4
        for edit = 1:4
            meanAccuracies(subject,cat,edit) = nanmean(subAccuracies(:,cat,edit));
            meanRTs(subject,cat,edit) = nanmean(subRTs(:,cat,edit));
        end
    end
       
end

%% TO DO: LOAD AND ORGANIZE CNN DATA 

%% TO DO: BETWEEN SUBJECT COMPARISONS & FIGURES 

%% TO DO: HUMAN VS. CNN COMPARISONS & FIGURES