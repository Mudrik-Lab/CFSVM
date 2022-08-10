%Major script

% Clear the workspace and the screen
Screen('CloseAll');
close all;
clear;

% Initiate an object
X = VPCFS();


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--------------------------------PARAMETERS-------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Change these%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Number of frames to wait when specifying good timing. 
% By using waitframe = 60 - one would flip on every second (assuming that monitor's 
% refresh rate (RR) is equal to 60Hz).
% By using waitframe = 1 - every frame or every 1/60 second.
% Relation between waitframe (WF) and temporal frequency (TF) [Hz]
% is TF=RR/WF
X.waitframe = 60; 

% Path to folder with target images.
X.target_images_path = './Images/Target_images'; 

% Duration of suppressing pattern in seconds.
X.cfs_mask_duration = 5; 

% By default (false) suppressing pattern is on the right half of the window; true/false.
X.left_suppression = false; 

% Choose one of these: 'UpperLeft', 'Top', 'UpperRight', 'Left', 
% 'Center', 'Right', 'LowerLeft', 'Bottom', 'LowerRight'.
X.stimulus_position = 'Center';

% From 0 to 1, where 1 means 100% of the screen (half of the window).
X.stimulus_size = 0.5; 

% Positive values represent clockwise rotation, 
% negative values represent counterclockwise rotation.
X.stimulus_rotation = 0; 

% Contrast from 0 (fully transparent) to 1 (fully opaque).
X.stimulus_contrast = 1; 

% Delay after initation of the suppressing pattern;
X.stimulus_appearance_delay = 2; 

% Duration of fading in from maximal transparency to stimulus_contrast.
X.stimulus_fade_in_duration = 2; 

% Choose one of these: 'UpperLeft', 'Top', 'UpperRight', 'Left', 
% 'Center', 'Right', 'LowerLeft', 'Bottom', 'LowerRight'.
X.mask_position = 'Center';

% From 0 to 1, where 1 means 100% of the screen (half of the window).
X.mask_size = 0.5; 

% Range is 0 = fully transparent to 1 = fully opaque.
X.mask_contrast = 1;

% Size of the arms of the fixation cross in pixels.
X.fixation_cross_arm_length = 20;

% Line width of the fixation cross in pixels.
X.fixation_cross_line_width = 4;

% Shape: 1 - squares, 2 - circles, 3 - diamonds.
X.mondrian_shape = 1;
% Color: 1 - BRGBYCMW, 2 - grayscale, 3 - all colors,
% for 4...15 see 'help CFS.generate_mondrians'.
X.mondrian_color = 15;

X.number_of_trials = 1;

% First item in an array will be a method name followed by key names for 
% the response. For example, {'4AFC', '1!', '2@', '3#', '4$'} or
% {'7AFC', '1!', '2@', '3#', '4$', '5%', '6^', '7&'} etc.  :)
% For available key names see KbName('KeyNames').
X.objective_evidence = {'2AFC', 'LeftArrow', 'RightArrow'};
X.subjective_evidence = {'PAS', '1!', '2@', '3#', '4$'};

% VPCFS only
X.prime_images_path = './Images/Prime_images';
% VPCFS only
X.target_presentation_duration = 0.7; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------FUNCTIONS-------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initiate Psychtoolbox window, generate mondrians, show introduction
% screen, create masks textures from mondrians, import images and
% initiate response structure.
X.initiate();

% Enter the experiment loop and BLOW IT UP
for n = 1:X.number_of_trials
    ttrial = X.run_the_experiment();
end

% Wait for a key to close the window
KbStrokeWait;

% Clear the screen.
Screen('CloseAll');
