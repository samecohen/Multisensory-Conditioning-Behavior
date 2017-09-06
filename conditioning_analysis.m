%%Counterfacing_gratings analysis with full tracking information
% This code assumes that there is 1 arena.
clc
clear all %this clears any previous analysis.

% Trial number (should correspond to MATLAB, not ethovision for new file.
% ethovision will be 600 less than MATLAB trial file)
% if you want to reanalyze multiple trials --- make an array of and comment
% other stuff appropriately
trial = 112;

% If first time running this tad (only one at a time!!), insert marker.
% Otherwise comment it out to loop through multiple
marker= 28.061;

%m=numel(trials);
%for y=1:m % loops through all tads. Comment this line out and the last line of this file "end"
%trial = trials(y);

% Loads trial data
    % Filename -- add a directory if you to put the data somewhere other than
    % the folder with counterphasing_gratings_analysis
    Filename = sprintf('Raw data-Sam Acquisition 2017 Conditioning MS-Trial %d.xlsx',trial);

load(sprintf('Conditioning Trial %d.mat',trial))

% Load trial data
trial_start_times = timeLog+marker;

%Insert number of stimulus presentations
n = 40;

%Insert the number of seconds you want to average the speed over
avg_over_s = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data = xlsread(Filename, 'Track-Arena 1-Subject 1');

%Extract time from column 2, velocity from column 9
time = data(:,2);
velocity = data(:,9);

% Generate before and after speeds
% frame rate ~= 30
avg_over_rows=avg_over_s*30;
% convert to rows
if MSI ~= 0
   MSIrows = (MSI/1000)*30;
else
   MSIrows = 0;
end
for ii=1:n %over all stim presentations
    start_time_s= trial_start_times(ii);
    tol = 0.0325; %find nearest value
    start_row=find(abs(time(:)-start_time_s)<tol);
    MSI_row=start_row-MSIrows;
    trial_data(ii,1,1)=nanmean(velocity((MSI_row-avg_over_rows):(MSI_row-2),1)); %before avg speed.
    if MSI ~= 0
        trial_data(ii,1,2)=nanmean(velocity((start_row-MSI_row):(start_row-2))); %in between speed
    end
    trial_data(ii,1,3)=nanmean(velocity(start_row:(start_row+avg_over_rows))); %after avg speed
end

% Set variable names
contrastLog(:);
acousticLog(:);
msiLog(:);
average_before_speeds=trial_data(:,:,1); 
average_btwn_speeds=trial_data(:,:,2);
average_after_speeds=trial_data(:,:,3);

delta_speed=zeros(n,1);
check_speed=zeros(n,1);
% Generate delta_speed --- this is what is used for most of the
% analysis
for k=1:n
    if average_before_speeds(k)<=3 && average_after_speeds(k) <=3
        delta_speed(k)=NaN;
        check_speed(k)=NaN;
        else
        delta_speed(k)=abs(average_after_speeds(k)-average_before_speeds(k));
        if MSI ~= 0
            check_speed(k)=abs(average_btwn_speeds(k)-average_before_speeds(k));
        else
            check_speed(k)=abs(average_after_speeds(k)-average_before_speeds(k));
        end
    end
end

% The next two blocks separate the visual and multisensory conditions and
% MSI conditions

% visual
%general
vContrasts = contrastLog(acousticLog==0);
vDeltaSpeed = delta_speed(acousticLog==0);
v0mean = nanmean(vDeltaSpeed(vContrasts==0));
v0var = nanvar(vDeltaSpeed(vContrasts==0));
v25mean = nanmean(vDeltaSpeed(vContrasts==1));
v25var = nanvar(vDeltaSpeed(vContrasts==1));
vMean=[v0mean;v25mean];
vVar=[v0var;v25var];
vCheck_speed = check_speed(acousticLog==0);
v0btwnMean = nanmean(vCheck_speed(vContrasts==0));

%MSI1
vContrastsMSI1 = vContrasts(msiLog==1);
v0meanMSI1 = nanmean(vDeltaSpeed(vContrastsMSI1==0));
v0varMSI1 = nanvar(vDeltaSpeed(vContrastsMSI1==0));
v25meanMSI1 = nanmean(vDeltaSpeed(vContrastsMSI1==1));
v25varMSI1 = nanvar(vDeltaSpeed(vContrastsMSI1==1));

%MSI2
vContrastsMSI2 = vContrasts(msiLog==2);
v0meanMSI2 = nanmean(vDeltaSpeed(vContrastsMSI2==0));
v0varMSI2 = nanvar(vDeltaSpeed(vContrastsMSI2==0));
v25meanMSI2 = nanmean(vDeltaSpeed(vContrastsMSI2==1));
v25varMSI2 = nanvar(vDeltaSpeed(vContrastsMSI2==1));

% mean and variance 
vMeanMSI1=[v0meanMSI1;v25meanMSI1];
vVarMSI1=[v0varMSI1;v25varMSI1];

vMeanMSI2=[v0meanMSI2;v25meanMSI2];
vVarMSI2=[v0varMSI2;v25varMSI2];

% multisensory
%general
msContrasts = contrastLog(acousticLog==1);
msDeltaSpeed = delta_speed(acousticLog==1);
ms0mean = nanmean(msDeltaSpeed(msContrasts==0));
ms0var = nanvar(msDeltaSpeed(msContrasts==0));
ms25mean = nanmean(msDeltaSpeed(msContrasts==25));
ms25var = nanvar(msDeltaSpeed(msContrasts==25));
msMean=[ms0mean;ms25mean;ms50mean;ms100mean];
msVar=[ms0var;ms25var;ms50var;ms100var];
msCheck_speed = check_speed(acousticLog==1);
ms0btwnMean = nanmean(msCheck_speed(msContrasts==0));

%MSI1
msContrastsMSI1 = msContrasts(msiLog==1);
ms0meanMSI1 = nanmean(msDeltaSpeed(msContrastsMSI1==0));
ms0varMSI1 = nanvar(msDeltaSpeed(msContrastsMSI1==0));
ms25meanMSI1 = nanmean(msDeltaSpeed(msContrastsMSI1==1));
ms25varMSI1 = nanvar(msDeltaSpeed(msContrastsMSI1==1));

%MSI2
msContrastsMSI2 = msContrasts(msiLog==2);
ms0meanMSI2 = nanmean(msDeltaSpeed(msContrastsMSI2==0));
ms0varMSI2 = nanvar(msDeltaSpeed(msContrastsMSI2==0));
ms25meanMSI2 = nanmean(msDeltaSpeed(msContrastsMSI2==1));
ms25varMSI2 = nanvarmsDeltaSpeed(msContrastsMSI2==1);

% mean and variance 
msMeanMSI1=[ms0meanMSI1;ms25meanMSI1];
msVarMSI1=[ms0varMSI1;ms25varMSI1];

msMeanMSI2=[ms0meanMSI2;ms25meanMSI2];
msVarMSI2=[ms0varMSI2;ms25varMSI2];

% obtain MSIn
% MSIn = (Cm-Sm)/Sm
%general
MSIn= (msMean-vMean)./vMean;
%MSI1
MSIn1= (msMeanMSI1-vMeanMSI1)./vMeanMSI1;
%MSI2
MSIn2= (msMeanMSI2-vMeanMSI2)./vMeanMSI2;

% plot
figure('Color','white');
hold on;
plot(vContrasts,vDeltaSpeed,'om')
plot(msContrasts,msDeltaSpeed,'ob')
contrasts=[0 25];
% construct a 95% confidence interval
% where s = usable stimulus presentations --> s-1 dof
% t=tinv(.95,s-1);
% vError=t*sqrt(vVar)/sqrt(s);
% msError=t*sqrt(msVar)/sqrt(s);
% errorbar(contrasts,vMean,vError,'-xm')
% errorbar(contrasts,msMean,msError,'-xb')
plot(contrasts,vMean,'-xm')
plot(contrasts,msMean,'-xb')
hold off;
legend({'V stimuli presentations','MS stimuli presentations','V mean','MS mean'},'Location','NorthWest');
xlabel('Contrast'); ylabel('|Change in speed|');
title((sprintf('Trial %d',trial)));

% save trial data
save((sprintf('Trial %d',trial)),'marker','average_before_speeds','average_after_speeds',...
    'average_btwn_speeds','delta_speed','vContrasts','vDeltaSpeed','msContrasts',...
    'msDeltaSpeed','vMean','vVar','msMean','msVar','MSIn','ms0btwnMean','v0btwnMean',...
    'vContrastsMSI1','vContrastsMSI2','msContrastsMSI1','msContrastsMSI2',...
    'vMeanMSI1','vMeanMSI2','msMeanMSI1','msMeanMSI2',...
    'vVarMSI1','vVarMSI2','msVarMSI1','msVarMSI2','ms-append');
clearvars -except trials y m MSI

%end

