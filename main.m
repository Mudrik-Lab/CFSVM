%Major script


% Clear the workspace and the screen
Screen('CloseAll');
close all;
clear;

import CFS.Experiment.* ...
    CFS.Element.Screen.* ...
    CFS.Element.Data.* ...
    CFS.Element.Evidence.* ...
    CFS.Element.Stimulus.*


% Initiate an object, for visual priming CFS use experiment = VPCFS(),
% for breaking CFS use experiment = BCFS(),
% for visual adaptation CFS use experiment = VACFS().

experiment = VPCFS();

experiment.subject_info = SubjectData( ...
    dirpath="./!SubjectInfo");

experiment.trials = TrialsData( ...
    dirpath='./TrialMatrices/');

experiment.screen = CustomScreen( ...
    initial_left_screen_rect=[240, 270, 720, 810], ...
    initial_right_screen_rect=[1200, 270, 1680, 810], ...
    adjust_shift=15, ...
    background_color='#E8DAEF'); %'#E8DAEF'

experiment.frame = CheckFrame( ...
    checker_length=30, ...
    checker_width=15, ...
    hex_colors={'#FFFFFF', '#000000'});

experiment.fixation = Fixation( ...
    duration=1, ...
    arm_length=20, ...
    line_width=4, ...
    color='#525252');

experiment.stimulus = SuppressedStimulus( ...
    './Images/suppressed_images', ...
    appearance_delay=1, ...
    fade_in_duration=0, ...
    show_duration=3, ...
    fade_out_duration=0, ...
    position='Center', ...
    size=0.3, ...
    padding=0.5, ...
    xy_ratio=1, ...
    contrast=1, ...
    rotation=0, ...
    n_rotations_per_trial=1, ...
    rotations_variance=0);

experiment.masks = Masks( ...
    './Masks/', ...
    temporal_frequency=10, ...
    duration=5, ...
    mondrians_shape=1, ...
    mondrians_color=15, ...
    position='Center', ...
    size=1, ...
    padding=0, ...
    xy_ratio=1, ...
    contrast=1, ...
    rotation=0);


if class(experiment) == "CFS.Experiment.VPCFS" || class(experiment) == "CFS.Experiment.VACFS"
    
    experiment.target = TargetStimulus( ...
            './Images/Target_images', ...
            duration=0.9, ...
            position=experiment.stimulus.position, ...
            size=experiment.stimulus.size, ...
            padding=experiment.stimulus.padding, ...
            xy_ratio=experiment.stimulus.xy_ratio, ...
            contrast=experiment.stimulus.contrast, ...
            rotation=experiment.stimulus.rotation);

    experiment.mafc = ImgMAFC( ...
        keys={'LeftArrow', 'RightArrow'}, ...
        title='Which one have you seen?', ...
        position='Center', ...
        size=0.75, ...
        xy_ratio=1);

%     experiment.mafc = TextMAFC( ...
%         keys={'LeftArrow', 'RightArrow'}, ...
%         title='Which one have you seen?', ...
%         options={'Simulacra', 'Simulation'});

    experiment.pas = PAS( ...
        keys={'0)', '1!', '2@', '3#'}, ...
        title='How clear was the experience?',...
        options={ ...
        '0: No experience', ...
        '1: A weak experience', ... 
        '2: An almost clear experience', ...
        '3: A clear experience'});
    
end

if class(experiment) == "CFS.Experiment.BCFS" || class(experiment) == "CFS.Experiment.VACFS"

    experiment.stimulus_break = BreakResponse( ...
        keys={'LeftArrow', 'RightArrow'});

end

experiment.results = Results( ...
    experiment, ...
    dirpath='./!Results');


% Execute the experiment.
experiment.run()


% Wait for a key to close the window.
KbStrokeWait

% Clear the screen.
Screen('CloseAll')
