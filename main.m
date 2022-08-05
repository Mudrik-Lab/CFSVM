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
% For example, by using waitframe = 2 one would flip on every other frame. 
% By using waitframe = 1 we flip every frame.
% By using 60 we flip every second (if the monitor's refresh rate is equal
% to 60Hz).
X.waitframe = 60; 

% Path to folder with target images.
X.target_images_path = './Images/Target_images'; 

% Duration of suppressing pattern in seconds, 
% basically means duration of the experiment.
X.cfs_mask_duration = 5; 

% By default (false) suppressing pattern is on the right half of the window; true/false.
X.left_suppression = false; 

% Choose one of these: UpperLeft, Top, UpperRight, Left, Center, Right, LowerLeft, Bottom, LowerRight.
X.target_position = 'Center';

% From 0 to 1, where 1 means 100% of the screen (half of the window).
X.target_size = 0.5; 

% Positive values represent clockwise rotation, 
% negative values represent counterclockwise rotation.
X.target_rotation = 0; 

% Contrast from 0 (fully transparent) to 1 (fully opaque).
X.target_transparency  = 1; 

% Delay after initation of the suppression pattern;
X.target_appearance_delay = 2; 

% Duration of fading in from zero transparency to target_transparency.
X.target_fade_in_duration = 2; 

% Choose one of these: UpperLeft, Top, UpperRight, Left, Center, Right, LowerLeft, Bottom, LowerRight.
X.mask_position = 'Center';

% From 0 to 1, where 1 means 100% of the screen (half of the window).
X.mask_size = 0.5; 

% Range is 0 = fully transparent to 1 = fully opaque.
X.mask_transparency = 1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------FUNCTIONS-------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X.initiate();
X.generate_mondrians(1,3);
X.introduction();
X.generate_textures();
X.import_target_images();
X.get_rects();
%for n = 1:10
    time = X.run_the_experiment();
%end

% Wait for a key to close the window
KbStrokeWait;

% Clear the screen.
Screen('CloseAll');