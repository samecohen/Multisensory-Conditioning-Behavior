%% Multisensory Conditioning Assay
% Sets up gratings
% Present rectangles on a gray background
% Clear the workspace
close all;
clear all;

% Trial number (fill in each time)
trial= 161;

Screen('Preference', 'SkipSyncTests', 1);
% Define arena space
screen_size = [1400, 770];
grating_width = 7; %pixels
num_bars_tot = round(screen_size(1)/grating_width);

%Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);
% Get the screen numbers
screens = Screen('Screens');

% Draw to the external screen if avaliable
%JN = switched to 1: max(screens)
screenNumber = max(screens);

% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
gray = white/2;

% Generate timing information for flipping grating back and forth
init_blank_time = 0;	% initial blank time (sec)
final_blank_time = 0;	% blank time at end (sec)
flicker_freq = 4;	%flicker frequency for full black-white cycle (hz)
stim_dur = 2;	% length of stimulus alternation (sec)
nalts = stim_dur*flicker_freq;	% number of alterations

% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, gray); %edit gray to change background color

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Make a base Rect (generate bar)
baseRect = [-500 0 grating_width screen_size(1,2)];

% Screen X positions of our multiple
% This should represent the center of where you want the rectangle in X (so
% for 2 squares, you want 0.25 and 0.75 of screen width, not 0 and .5).
for i = 1:num_bars_tot
    squareXpos(1,i) = (xCenter-(screen_size(1,2)/2))+(grating_width*i);
end

numSqaures = length(squareXpos);

% Set the colors to black and white
% This is a vertical matrix - a square's color is set by the column, so it
% must have number of columns = number of squares.

% 100% contrast
for j=1:num_bars_tot
    if mod(j,2) == 0 % even
        allColors1_100(:,j) = [0; 0; 0];
    else %odd
        allColors1_100(:,j) = [1; 1; 1];
    end
end
% Grating 2 (opposite phase)
for j=1:num_bars_tot
    if mod(j,2) == 0 % odd
        allColors2_100(:,j) = [1; 1; 1];
    else %odd
        allColors2_100(:,j) = [0; 0; 0];
    end
end

% 25% contrast
for j=1:num_bars_tot
    if mod(j,2) == 0 % even
        allColors1_25(:,j) = [.375; .375; .375];
    else %odd
        allColors1_25(:,j) = [.625; .625; .625];
    end
end
% Grating 2 (opposite phase)
for j=1:num_bars_tot
    if mod(j,2) == 0 % odd
        allColors2_25(:,j) = [.625; .625; .625];
    else %odd
        allColors2_25(:,j) = [.375; .375; .375];
    end
end

% Make our rectangle coordinates
allRects = nan(4, num_bars_tot);

for i = 1:numSqaures
    allRects(:, i) = CenterRectOnPointd(baseRect, squareXpos(i), yCenter);
end

% Trial parameters

% Number of repetitions, stimuli per rep
reps = 5; % number of repetitions of all stimuli (should be an even number so
% that acoustic stimulus can be presented half the time
stimRep = 8; % number of stimuli presentations in each repetition
ISI = 20; %interstimulus interval in seconds
MSI1 = 0; % number of seconds before visual stim ulus when audio should be played
MSI2 = .500; % alternate MSI value

% Creates the sound vector (code from clicker.m)
S.f = 44100;                % Sampling frequency (44100 is the default value)
S.volume = .4;               % Overall signal amplitude
S.isi = 100;                % ISI in ms (can be a vector)
S.stepL = 1;                % How many times the waveformshoudl be repeated
S.modF = 200;               % Modulation frequency for the signal, Hz
S.kicksPerISI = 100;        % For ISI sampling

S.lenS = (S.isi+S.stepL*3)/1000;     % Length of the sound vector, s
S.nF = ceil(S.lenS*S.f);                    % Length of the full vector, points
S.nS = round(S.f/S.modF*S.stepL);           % Length of the signal, points

s = zeros(S.nF,1);
wavy = sin((1:(S.nS*S.stepL))/S.nS*2*pi);                   % Wavy curve that needs to be placed correctly
s(round(S.isi/1000*S.f)-1+(1:length(wavy))) = wavy;  % Pulse
s2 = s;                                                     % Start to cook single-pulse variant
s2 = [s2 -s2]*S.volume;
S.s2 = s2;                                                  % Store the single stimulus in the structure.
 
% Present stimuli
WaitSecs(5);
start=tic;
for i=1:3
    Screen('FillRect', window, allColors1_100, allRects);
    Screen('flip', window);
    WaitSecs(1/flicker_freq);
    Screen('FillRect', window, allColors2_100, allRects);
    Screen('flip', window);
    WaitSecs(1/flicker_freq);
end
Screen('FillRect', window, gray, allRects);
Screen('flip', window,0);
WaitSecs(30); % pauses after warning sign, allows time to insert tadpole and close tent
contrastLog={}; % set up variable to store the order of stimuli contrasts
acousticLog={}; % set up variable to store the order of acoustic stimuli
msiLog={}; % set up variable to store the order of msi stimuli
timeLog=[]; % set up variable to store the time elapsed from LED light
for j=1:reps
    p = randperm(stimRep); % randomize stimuli order within each repetition
    for k=1:stimRep;
        if p(k)==1 % gray, MSI1, noA
                contrastLog{end+1}=0;
                acousticLog{end+1}=0;
                msiLog{end+1}=1;
                WaitSecs(MSI1);
                timeLog=[timeLog toc(start)];
                WaitSecs(stim_dur+1)% do nothing -- stays gray
                disp('gray, MSI1') % in command window
        elseif p(k)==2 % gray, MSI1, A
                sound(S.s2,S.f)
                contrastLog{end+1}=0;
                acousticLog{end+1}=1;
                msiLog{end+1}=1;
                WaitSecs(MSI1);
                timeLog=[timeLog toc(start)];
                WaitSecs(stim_dur+1)% do nothing -- stays gray
                disp('gray, MSI1, acoustic') % in command window
        elseif p(k)==3 % gray, MSI2
                contrastLog{end+1}=0;
                acousticLog{end+1}=0; 
                msiLog{end+1}=2;
                WaitSecs(MSI2);
                timeLog=[timeLog toc(start)];
                WaitSecs(stim_dur+1)% do nothing -- stays gray
                disp('gray, MSI2') % in command window
        elseif p(k)==4 % gray, MSI2, A
                sound(S.s2,S.f)
                contrastLog{end+1}=0;
                acousticLog{end+1}=1;
                msiLog{end+1}=2;
                WaitSecs(MSI2);
                timeLog=[timeLog toc(start)];
                WaitSecs(stim_dur+1)% do nothing -- stays gray
                disp('gray, MSI2, acoustic') % in command window
        elseif p(k)== 5 
                % 25, MSI1, noA
                contrastLog{end+1}=1;
                acousticLog{end+1}=0;
                msiLog{end+1}=1;
                WaitSecs(MSI1);
                timeLog=[timeLog toc(start)];
                for i=1:nalts/2
                    Screen('FillRect', window, allColors1_25, allRects);
                    Screen('flip', window);
                    WaitSecs(1/flicker_freq);
                    Screen('FillRect', window, allColors2_25, allRects);
                    Screen('flip', window);
                    WaitSecs(1/flicker_freq);
                end
                disp('25%, MSI1') % in command window
        elseif p(k)== 6  % 25, MSI1, A
                sound(S.s2,S.f)
                contrastLog{end+1}=1;
                acousticLog{end+1}=1;
                msiLog{end+1}=1;
                WaitSecs(MSI1);
                timeLog=[timeLog toc(start)];
                for i=1:nalts/2
                    Screen('FillRect', window, allColors1_25, allRects);
                    Screen('flip', window);
                    WaitSecs(1/flicker_freq);
                    Screen('FillRect', window, allColors2_25, allRects);
                    Screen('flip', window);
                    WaitSecs(1/flicker_freq);
                end
                disp('25%, MSI1, acoustic') % in command window
        elseif p(k)== 7 
                % 25, MSI2, noA
                contrastLog{end+1}=1;
                acousticLog{end+1}=0;
                msiLog{end+1}=2;
                WaitSecs(MSI2);
                timeLog=[timeLog toc(start)];
                for i=1:nalts/2
                    Screen('FillRect', window, allColors1_25, allRects);
                    Screen('flip', window);
                    WaitSecs(1/flicker_freq);
                    Screen('FillRect', window, allColors2_25, allRects);
                    Screen('flip', window);
                    WaitSecs(1/flicker_freq);
                end
                disp('25%, MSI2') % in command window
        elseif p(k)== 8  % 25, MSI2, A
                sound(S.s2,S.f)
                contrastLog{end+1}=1;
                acousticLog{end+1}=1;
                msiLog{end+1}=2;
                WaitSecs(MSI2);
                timeLog=[timeLog toc(start)];
                for i=1:nalts/2
                    Screen('FillRect', window, allColors1_25, allRects);
                    Screen('flip', window);
                    WaitSecs(1/flicker_freq);
                    Screen('FillRect', window, allColors2_25, allRects);
                    Screen('flip', window);
                    WaitSecs(1/flicker_freq);
                end
                disp('25%, MSI2, acoustic') % in command window
        end
        save(sprintf('Conditioning Trial %d',trial),'timeLog','acousticLog','contrastLog','msiLog');
        Screen('FillRect', window, gray, allRects); % gray in between stimuli
        Screen('flip', window);
        if msiLog{end}==1
             WaitSecs(ISI-MSI1); % wait interstimulus interval before next stimulus
        elseif msiLog{end}==2
            WaitSecs(ISI-MSI2); % wait interstimulus interval before next stimulus
        end
    end
end
Screen('CloseAll')

