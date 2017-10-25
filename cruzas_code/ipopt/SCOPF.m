% Author: Samuel A. Cruz Alegría.
% Version: 2017-10-13 (YYYY-MM-DD)
clc;
clear;
close all;

define_constants;

setenv('OMP_NUM_THREADS', '1')
% mpopt = mpoption('opf.ac.solver', 'MIPS', 'verbose', 2, 'mips.max_it', 100);
mpopt = mpoption('opf.ac.solver', 'IPOPT', 'verbose', 2);

% load MATPOWER case struct, see help caseformat
mpc = loadcase('case118');

% Path to save plots in.
pathToSavePlots = '/Users/samuelcruz/Documents/GitHub/bachelor-project/plots/';

runExperiment1 = 1;
runExperiment2 = 0;

%% Experiment 1.
if runExperiment1
   %% Settings for experiment 1.
   % Toggle on/off to save plots.
   savePlots = 0;
   % Toggle on/off to save workspace.
   saveWorkspace = 0;
   % Toggle on/off to load workspace.
   loadWorkspace = 0;
   % Toggle on/off to run until convergence
   untilConvergence = 1;
   
   % Path to save workspace in.
   if untilConvergence
      workspaceName = ['/Users/samuelcruz/Documents/GitHub/bachelor-project/'...
      'workspace/exp1_conv_data.mat'];
   else
      workspaceName = ['/Users/samuelcruz/Documents/GitHub/bachelor-project/'...
      'workspace/exp1_maxiter_data.mat'];
   end
   
   %% Run experiment 1.
   [SUCCESS, INFO] = myExperiment1(mpc, mpopt, savePlots, pathToSavePlots,...
      saveWorkspace, loadWorkspace, workspaceName, untilConvergence);
   
   %% Experiment 1 plots.
   numContingenciesArray = INFO.numContingenciesArray;
   avgIterWrtNumContingencies = INFO.avgIterWrtNumContingencies;
   avgTimeWrtNumContingencies = INFO.avgTimeWrtNumContingencies;
   stdAllTimes = INFO.stdAllTimes;
   stdAllIters = INFO.stdAllIters;
   
   % Plot average number of iterations vs number of contingencie, with
   % standard deviation.
%    plot(numContingenciesArray, avgIterWrtNumContingencies, '-o');
   errorbar(numContingenciesArray, avgTimeWrtNumContingencies, stdAllIters, '-o');
   title('Average no. of iterations vs No. of contingencies');
   xlabel('No. of contigencies');
   ylabel('Average no. of iterations');
   if savePlots
      print(strcat(pathToSavePlots, 'avgIterAndStdVsNumCont'), '-depsc');
   end
     
   % Plot average time taken vs number of contingencies, with standard
   % deviation.
   errorbar(numContingenciesArray, avgTimeWrtNumContingencies, stdAllTimes, '-o');
   title('Average time taken vs No. of contingencies');
   xlabel('No. of contigencies');
   ylabel('Average time taken (seconds)');
   if savePlots
      print(strcat(pathToSavePlots, 'avgTimeAndStdInSecsVsNumCont'), '-depsc');
   end
   
   % Plot average time normalized by average number of iterations.
   avgTimePerIter = avgTimeWrtNumContingencies ./ avgIterWrtNumContingencies;
   plot(numContingenciesArray, avgTimePerIter, '-o')
   title('Average time per iteration vs No. of contingencies');
   xlabel('No. of contigencies');
   ylabel('Average time per iteration (seconds)');
   if savePlots
      print(strcat(pathToSavePlots, 'avgTimePerIterInSecsVsNumCont'), '-depsc');
   end
end

%% Experiment 2.
if runExperiment2   
   %% Settings for experiment 2.
   % Toggle on/off to save plots.
   savePlots = 1;
   % Toggle on/off to save workspace.
   saveWorkspace = 1;
   % Toggle on/off to load workspace.
   loadWorkspace = 1;
   % Toggle on/off to run until convergence
   untilConvergence = 1;

   % Path to save workspace in.
   if untilConvergence
      workspaceName = ['/Users/samuelcruz/Documents/GitHub/bachelor-project/'...
      'workspace/exp2_conv_data.mat'];
   else
      workspaceName = ['/Users/samuelcruz/Documents/GitHub/bachelor-project/'...
      'workspace/exp2_maxiter_data.mat'];
   end
   
   %% Run experiment 2.
   [SUCCESS, INFO] = myExperiment2(mpc, mpopt, savePlots, pathToSavePlots,...
      saveWorkspace, loadWorkspace, workspaceName, untilConvergence);
   
   %% Experiment 2 plots
   % Plot average number of iterations vs number of contingencies.
   plot(INFO.tolValuesArray, INFO.avgIterWrtTol, '-o');
   title('Average no. of iterations vs Tolerance value');
   xlabel('-log(tolerance value)');
   ylabel('Average no. of iterations');
   if savePlots
      print(strcat(pathToSavePlots, 'avgIterVsTol'), '-depsc');
   end
end