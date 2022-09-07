%Major script

% Clear the workspace and the screen
Screen('CloseAll');
close all;
clear;


% Initiate an object, for visual priming CFS use experiment = VPCFS(),
% for breaking CFS use experiment = BCFS(),
% for visual adaptation CFS use experiment = VACFS().
experiment = VPCFS();

%%                                                                       %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--------------------------------PARAMETERS-------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Change these%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Background color in hexadecimal color code (check this in google)
experiment.background_color = '#E8DAEF';

% Path to a directory with target images. 
% Please be aware of the nomenclature:
% For BCFS - target images (stimuli) are shown with mondrians.
% For VPCFS - prime images (stimuli) are shown with mondrians,
% whereas target images are shown succeeding them w/o suppression.
% For VACFS - adapter images (stimuli) are shown with mondrians, 
% whereas target images are used for mAFC.
experiment.target_images_path = './Images/Target_images';

experiment.trial_matrices_path = './TrialMatrices';

%--------MASKS PARAMETERS--------%

% Number of masks flashed per one second.
experiment.temporal_frequency = 10;

% Duration of suppressing pattern in seconds.
experiment.cfs_mask_duration = 5;

% Load pregenerated masks from folder? true/false
experiment.load_masks_from_folder = true;

% If previous parameter set to true - specify path, e.g. './Masks'
if experiment.load_masks_from_folder
    experiment.masks_path = './Masks';
end

% Masks position on the screen (half of the window).
% Expected values are 'UpperLeft', 'Top', 'UpperRight', 'Left', 
% 'Center', 'Right', 'LowerLeft', 'Bottom', 'LowerRight'.
experiment.mask_position = 'Center';

% From 0 to 1, where 1 means 100% of the screen (half of the window).
experiment.mask_size = 0.5;

% Contrast is from 0 = fully transparent to 1 = fully opaque.
experiment.mask_contrast = 1;

% Shape: 1 - squares, 2 - circles, 3 - diamonds.
experiment.mondrian_shape = 1;

% Color: 1 - BRGBYCMW, 2 - grayscale, 3 - all colors,
% for 4...15 see 'help CFS.generate_mondrians'.
experiment.mondrian_color = 1;


%--------STIMULUS PARAMETERS--------%

% Stimulus position on the screen (half of the window).
% Expected values are 'UpperLeft', 'Top', 'UpperRight', 'Left', 
% 'Center', 'Right', 'LowerLeft', 'Bottom', 'LowerRight'.
experiment.stimulus_position = "Left";

% From 0 to 1, where 1 means 100% of the screen (half of the window).
experiment.stimulus_size = 0.5; 

% Positive values represent clockwise rotation, 
% negative values represent counterclockwise rotation.
experiment.stimulus_rotation = 0; 

% Contrast is from 0 (fully transparent) to 1 (fully opaque).
experiment.stimulus_contrast = 1; 

% Delay after initation of the suppressing pattern.
% Floating point shoudn't be more precise than 1/temporal_frequency.
experiment.stimulus_appearance_delay = 0; 

% Duration of fading in from maximal transparency to stimulus_contrast.
experiment.stimulus_fade_in_duration = 2; 

experiment.stimulus_duration = 2; 


%--------FIXATION CROSS PARAMETERS--------%

% In seconds
experiment.fixation_cross_duration = 2;

% Size of the arms of the fixation cross in pixels.
experiment.fixation_cross_arm_length = 20;

% Line width of the fixation cross in pixels.
experiment.fixation_cross_line_width = 4;

% Fixation cross color in hexadecimal color code (check this in google)
experiment.fixation_cross_color = '#36C8CF';


%--------SUBJECT RESPONSE PARAMETERS--------%

% First item in an array will be a method name followed by key names for 
% the response. For example, {'4AFC', '1!', '2@', '3#', '4$'} or
% {'2AFC', 'LeftArrow', 'RightArrow'} or
% {'7AFC', '1!', '2@', '3#', '4$', '5%', '6^', '7&'}, etc.  :)
% For available key names please check KbName('KeyNames') or KbDemo.
experiment.objective_evidence = {'2AFC', 'LeftArrow', 'RightArrow'};
experiment.subjective_evidence = {'PAS', '1!', '2@', '3#', '4$'};

% Directory to save the subject response data in. 
% e.g. './!Results'
experiment.subject_response_directory = './!Results';

% Directory to save recorded subject info (age, hand, eye, etc.) in.
% e.g. './!SubjectInfo'
experiment.subject_info_directory = './!SubjectInfo';


%--------VPCFS ONLY--------%

if class(experiment) == "VPCFS"
    % Path to a directory with prime images.
    experiment.prime_images_path = './Images/Prime_images';

    experiment.target_image_index = 1;
    
    % For how long to show the target images after the suppression has
    % been stopped.
    experiment.target_presentation_duration = 0.9;
end

%--------VACFS ONLY--------%

if class(experiment) == "VACFS"
    % Path to a directory with adapter images.
    experiment.adapter_images_path = './Images/Adapter_images';
end


%--------BCFS and VACFS ONLY--------%
if class(experiment) == "VACFS" || class(experiment) == "BCFS"
    %For available key names please check KbName('KeyNames') or KbDemo.
    % You can use either numerical code or characters.
    experiment.breakthrough_key = 'space';
end

%%                                                                       %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--------------------------------EXPERIMENT-------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Show input dialog for subject info
experiment.get_subject_info();


% Initiate Psychtoolbox window, generate mondrians, show introduction
% screen, create masks textures from mondrians, import images and
% initiate response structure.
experiment.initiate();

% Enter the experiment loop and BLOW IT UP

experiment.run_the_experiment();


% Wait for a key to close the window.
KbStrokeWait;

% Clear the screen.
Screen('CloseAll');
