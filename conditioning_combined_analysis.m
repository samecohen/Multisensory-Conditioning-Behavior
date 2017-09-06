%% Combined analysis

% Trials to consider for combined analysis 

% S46 tads
trials = [59 61 63 65 66 67 68 69 70 71 75 76 89 90 91 95 97 98 100 101 104 106 108 109 110 111 112 116 117];
% trials = [52 56 78 81 82 83 84 85 146 147 148 150]

% [Inc,Ex] = exclusionMS(trials,MSI); %calls exclusionMS -- excludes trials

m = numel(trials); % counts includable trials

% initializes arrays for the sum of the means for each condition
% vTot=[0;0;0;0];
% msTot=[0;0;0;0];
vTotMSI1=[0;0];
vTotMSI2=[0;0];
msTotMSI1=[0;0];
msTotMSI2=[0;0];

for i=1:m
    trial=trials(i);
    load(sprintf('Conditioning Trial %d.mat',trial));
    
    % ************comment this block out if you don't want to make graphs for each tad
    
    % Plots for each tad
    
%     figure('Color','white');
%     hold on;
%     plot(vContrasts+3,vDeltaSpeed,'om')
%     plot(msContrasts-3,msDeltaSpeed,'ob')
%     contrasts=[0 25 50 100];
%     plot(contrasts,vMean,'-xm')
%     plot(contrasts,msMean,'-xb')
%     hold off;
%     legend({'V stimuli presentations','MS stimuli presentations','V mean','MS mean'},'Location','NorthWest');
%     xlabel('Contrast'); ylabel('|Change in speed|');
%     title((sprintf('Trial %d',trial)));
    
    % ***********end commenting: LEAVE next two lines in - they add the mean of the
    % current tad to the running sum
 %  vTot=vTot+vMean;
 %  msTot=msTot+msMean;
    % next four lines - also add mean of current tad to running sum BUT
    % this time for conditions MSI1 and MSI2 (four conditions total)
    vTotMSI1=vTotMSI1+vMeanMSI1
    vTotMSI2=vTotMSI2+vMeanMSI2
    msTotMSI1=msTotMSI1+msMeanMSI1
    msTotMSI2=msTotMSI2+msMeanMSI2
    

end
% vMeanAll=vTot/(m);
% msMeanAll=msTot/(m)
vMeanMSI1All=vTotMSI1/(m);
vMeanMSI2All=vTotMSI2/(m);
msMeanMSI1All=msTotMSI1/(m);
msMeanMSI2All=msTotMSI2/(m);

vMeans=[];
msMeans=[];
MSIs=[];
for i=1:m
    trial=trials(i);
    load(sprintf('Conditioning Trial %d.mat',trial));
    vMeans=[vMeans; vMean'];
    msMeans=[msMeans; msMean'];
    MSIs=[MSIs;MSIn'];
   
    
end

% Obtain variance
% vVar=var(vMeans);
% msVar=var(msMeans);

%Average plot

figure('Color','white');
hold on;
contrasts=[0 25]; ylim([0 15])
% construct a confidence interval
% where n = 5 --> 4 dof m
% t=tinv(.95,m-1);
% vError=t*sqrt(vVar)/sqrt(m);
% msError=t*sqrt(msVar)/sqrt(m);
% plots means with errorbars
% errorbar(contrasts,vMeanAll,vError,'-xg')
% errorbar(contrasts,msMeanAll,msError,'-xm')
% plots data points for each tadpole for each condition offset
% plot(contrasts+3,vMeans,'ob')
% plot(contrasts-3,msMeans,'or')

%plots means for MSI Conditioning
plot(contrasts, vMeanMSI1All,'-xg')
plot(contrasts, vMeanMSI2All,'-xm')
plot(contrasts, msMeanMSI1All,'-xb')
plot(contrasts, msMeanMSI2All,'-xr')
hold off;
% legend({'V mean','MS mean','V trial means (blue)','MS trial means (red)'},'Location','NorthWest');
xlabel('Contrast'); ylabel('|Change in speed|');
title(sprintf('Average of %d trials',m)); % title
legend({'vMeanMSI1','vMeanMSI2','msMeanMSI1','msMeanMSI2'},'Location','NorthWest') %legend for MSI Conditioning data

