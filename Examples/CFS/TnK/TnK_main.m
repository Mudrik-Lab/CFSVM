%Major script


% Clear the workspace and the screen
Screen('CloseAll');
close all;
clear;

import CFSVM.Experiment.* ...
    CFSVM.Element.Screen.* ...
    CFSVM.Element.Data.*


% Initiate an object, for visual priming CFS use experiment = VPCFS(),
% for breaking CFS use experiment = BCFS().

experiment = BCFS(save_to_dir="../../../Raw Data/Behavioral");

experiment.subject_info = SubjectData( ...
    dirpath='../../../Raw Data/Demographics');

experiment.trials = TrialsData( ...
    filepath='../TrialMatrix/experiment.mat');

experiment.instructions = Instructions( ...
    "../Instructions/", ...
    backward_key='LeftArrow', ...
    forward_key='RightArrow');

experiment.screen = CustomScreen( ...
    is_stereo=true, ...
    initial_rect=[30, 90, 930, 990], ...
    background_color='#AEAEAE');

% Execute the experiment.
experiment.run()

% Clear the screen.
Screen('CloseAll')
