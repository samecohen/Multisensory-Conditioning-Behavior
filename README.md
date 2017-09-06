# Multisensory-Conditioning-Behavior

This repository contains the MATLAB code required for running the multisensory conditioning experiment and analysis. In addition to MATLAB, EthoVision XT is used to track motion of behavioral subjects. 

## How to Run Experiment

Open Multisensory_Conditioning_Assay_61917.m, which functions as the behavioral assay for the multisensory conditioning experiment. This assay has a run time of ~16 minutes and is comprised of a randomized series of four different stimulatory conditions (1. Auditory stimulus alone, 2. Visual stimulus alone, 3. Simultaneous auditory + visual stimulus, 4. Auditory + visual stimulus offset by 500 msec) that appear every 30 seconds. It is recommended that the assay run on an alternate monitor on which one can place a behavioral apparatus, so that the subject is directly exposed to the visual stimulus. In addition, speakers incorporated into the apparatus must also be connected to the monitor running the MATLAB script.
  
Input trial number in line 9, which should match the trial number in EthoVision. In this order (recommended): run Multisensory_Conditioning_Assay61917.m, place subject in behavioral apparatus, then begin trial in EthoVision. 

## How to Run Analysis
### Individual:

Use conditioning_analysis72717.m when analyzing individual trials. Input trial number in line 10 and the "marker" (time that first series of contrasting vertical bars appears in Multisensory_Conditioning_Assay_61917.m) in line 14. Run script. Output contains trial, marker, and four different variables (vMeanMSI1, vMeanMSI2, msMeanMSI1, and msMeanMSI2). Each variable contains two separate values: the average velocity (in mm/sec) at 0% visual contrast or 25% visual contrast, listed in this order.
 
### Combined:

Use conditioning_combined_analysis.m when analyzing multiple trials at once. *These trials must have already been analyzed individually using conditioning_analysis72717.m* Input array of trials in line 6. Output contains a plot of four new variables (vMeanMSI1All, vMeanMSI2All, msMeanMSI1All, msMeanMSI2All) which also contain two separate values: the average velocity at 0% visual contrast or 25% visual contrast. These new variables are simply the mean values of vMeanMSI1, vMeanMSI2, msMeanMSI1, and msMeanMSI2 over the specified number of trials.


## Exporting Trial Data to Excel

  Use MSCexport72717.m to export trial data to Excel. Input array of trials in line 6. Set file name and sheet name in lines 9 and 10, respectively. 
