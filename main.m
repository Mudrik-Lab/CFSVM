%Major script

% Clear the workspace and the screen
Screen('CloseAll');
close all;
clear;

% Initiate an object
X = CFS();


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--------------------------------PARAMETERS-------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Number of frames to wait when specifying good timing. 
% By using waitframe = 60 - one would flip on every second (assuming that monitor's 
% refresh rate is equal to 60Hz).
% By using waitframe = 1 - every frame or every 1/60 second.
% Et cetera.
X.waitframe = 60; 

% Path to folder with target images.
X.target_images_path = './Images/Target_images'; 

% Duration of suppressing pattern in seconds, 
% basically means duration of the experiment.
X.cfs_mask_duration = 5; 

% By default (false) suppressing pattern is on the right half of the window; true/false.
X.left_suppression = false; 

% Choose one of these: 'UpperLeft', 'Top', 'UpperRight', 'Left', 
% 'Center', 'Right', 'LowerLeft', 'Bottom', 'LowerRight'.
X.target_position = 'Center';

% From 0 to 1, where 1 means 100% of the screen (half of the window).
X.target_size = 0.5; 

% Positive values represent clockwise rotation, 
% negative values represent counterclockwise rotation.
X.target_rotation = 0; 

% Contrast from 0 (fully transparent) to 1 (fully opaque).
X.target_contrast = 1; 

% Delay after initation of t  he suppression pattern;
X.target_appearance_delay = 2; 

% Duration of fading in from maximal transparency to target_contrast.
X.target_fade_in_duration = 2; 

% Choose one of these: 'UpperLeft', 'Top', 'UpperRight', 'Left', 
% 'Center', 'Right', 'LowerLeft', 'Bottom', 'LowerRight'.
X.mask_position = 'Center';

% From 0 to 1, where 1 means 100% of the screen (half of the window).
X.mask_size = 0.5; 

% Range is 0 = fully transparent to 1 = fully opaque.
X.mask_contrast = 1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------FUNCTIONS-------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initiate Psychtoolbox window
X.initiate();

% Start mondrian masks generation.
% The function takes two arguments: shape and color.
% Shape: 1 - squares, 2 - circles, 3 - diamonds.
% Color: 1 - BRGBYCMW, 2 - grayscale, 3 - all colors,
% for 4...15 see 'help CFS.generate_mondrians'.
X.generate_mondrians(1, 15);

% Show introduction screen while masks are being generated.
X.introduction();

% Generate PTB textures
X.generate_textures();

% Import images from the provided directory and make their PTB textures.
X.import_target_images();

% Calculate target and masks coordinates on screen.
X.get_rects();

% Run the experiment
%for n = 1:10
    time = X.run_the_experiment();
%end

% Wait for a key to close the window
KbStrokeWait;

% Clear the screen.
Screen('CloseAll');