%Major script


% Clear the workspace and the screen
Screen('CloseAll');
close all;
clear;

import CFS.Experiment.* ...
    CFS.Element.Screen.* ...
    CFS.Element.Data.*

experiment = VSM();

experiment.subject_info = SubjectData( ...
    dirpath='./!SubjectInfo');

experiment.trials = TrialsData( ...
    filepath='./TrialMatrix/vsm.mat');

experiment.screen = CustomScreen( ...
    is_stereo=false, ...
    initial_rect=[0,0,1920,1080], ...
    background_color='#AEAEAE');

% Execute the experiment.
experiment.run()

% Clear the screen.
Screen('CloseAll')
