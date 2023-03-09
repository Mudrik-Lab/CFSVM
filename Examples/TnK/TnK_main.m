%Major script


% Clear the workspace and the screen
Screen('CloseAll');
close all;
clear;

import CFS.Experiment.* ...
    CFS.Element.Screen.* ...
    CFS.Element.Data.*


% Initiate an object, for visual priming CFS use experiment = VPCFS(),
% for breaking CFS use experiment = BCFS().

experiment = BCFS();

experiment.subject_info = SubjectData( ...
    dirpath='./!SubjectInfo');

experiment.trials = TrialsData( ...
    filepath='./TrialMatrix/experiment.mat');

experiment.screen = StereoScreen( ...
    initial_left_screen_rect=[30, 270, 930, 810], ...
    initial_right_screen_rect=[990, 270, 1890, 810], ...
    background_color='#AEAEAE');

% Execute the experiment.
experiment.run()

% Clear the screen.
Screen('CloseAll')
