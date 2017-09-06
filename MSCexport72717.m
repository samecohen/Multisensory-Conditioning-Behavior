% Export trial data to excel
% Note, will not work on mac bc MATLAB cannot open excel on macs

% Write all trials to export 
% trials = [59 61 63 65 66 67 68 69 70 71 75 76 89 90 91 95 97 98 100 101 104 106 108 109 110 111 112 116 117];
trials =[52 56 78 81 82 83 84 85 146 147 148 150]

% set filename (w/ directory if you don't want it in the matlab folder)
filename = '72817';
sheetname = 'control';

m = numel(trials); 

% loops through all trials
for i=1:m
    trial=trials(i);
    load(sprintf('Conditioning Trial %d.mat',trial)); %loads trial data
    % Makes a matrix of data to be exported
    % Add variables present in Trial files following comma
    % ex. to add timeLog --> A = cell2mat({[[trial;trial;trial;trial],[0;25;50;100],vMean,msMean,timeLog]});
    
    % Currently records trial number, contrast, mean for visual for each
    % contrast and mean for multisensory for each contrast
    A = cell2mat({[[trial;trial],[0;25],vMeanMSI1,vMeanMSI2,msMeanMSI1,msMeanMSI2]});

    % Writes file
      xlswrite(filename,A,sheetname,strcat('A',num2str(2*i))); %skips 2 lines so that it doesn't write over itself
    % xlswrite(filename,A,'comparison',strcat('A',num2str(i))); %skips a line so that it doesn't write over itself
    clear trial
end

