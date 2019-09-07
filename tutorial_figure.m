%% Hands-on tutorlal for fNIRS dataset: Figure
% This MATLAB script is a hands-on tutorial to draw the grand averages of
% temporal hemodynamic responses.
%  
% written by Jaeyoung Shin (jyshin34@wku.ac.kr) 08. Sep. 2019
%% 1. Run BBCI toolbox
format compact; close all;
disp('1. run BBCI toobox')

% set paths
WorkingDir = pwd;
MyToolboxDir = fullfile(WorkingDir,'BBCI'); % toolbox path
MyDatDir  = fullfile(WorkingDir,'data');
MyMatDir  = fullfile(MyDatDir,'matdata'); % fNIRS dataset path

% run BBCI toolbox
addpath(MyToolboxDir);
startup_bbci_toolbox('DataDir', MyDatDir, 'MatDir', MyMatDir,...
    'TmpDir','/tmp/','History', 0);

disp(BTB.MatDir);

%% 2. Load example fNIRS dataset

disp('2. load example fNIRS dataset')

% multiple file names
files = {'fNIRS 04.mat','fNIRS 14.mat'};

% load multiple fNIRS dataset files to MATLAB workspace
[cntHbs, mrks, mnt] = file_loadMatlab(files);

%% 3. Band-pass filtering to eliminate physiological noises  

disp('3. band-pass filtering')

% zero-order band-pass filtering using [ord]-order Butterworth IIR filter
% with passpand of [band]
ord = 3;
band = [0.01 0.1]/cntHbs.fs*2;

[b, a] = butter(ord, band, 'bandpass');
cntHbs = proc_filtfilt(cntHbs, b, a); % zero-order filtering
% 4. Segmentation and baseline correction

disp('4-1. segmentation')

% segment cntHb into epochs ranging [ival_epo]
ival_epo = [-1 25]*1000; % msec
epo = proc_segmentation(cntHbs, mrks, ival_epo);

disp('4-2. baseline correction')

% baseline correction using reference interval of [ival_base]
ival_base = [-1 0]*1000; % msec
epo = proc_baseline(epo, ival_base);

%% 5. Draw grand averages of temporal hemodynamic responses

disp('5. draw hemodynamic resopnses')

fig_set(3, 'Toolsoff', false, 'GridSize', [2 2])
grid_plot(epo, mnt)

%%
% remove toolbox path
rmpath(MyToolboxDir);