% Clear the workspace and the screen
Screen('CloseAll');
close all;
clear;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--------------------------------PARAMETERS-------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

WAITFRAME = 60; % Number of frames to wait when specifying good timing. 
% For example, by using waitframe = 2 one would flip on every other frame. 
% By using waitframe = 1 we flip every frame.
% By using 60 we flip every second (if the monitor's refresh rate is equal
% to 60Hz).
LEFT_SUPPRESSION = false; % By default suppressing pattern is on the right half of the window. true/false.
CFS_MASK_DURATION = 5; % Duration of suppressing pattern in seconds, basically duration of the experiment.
TARGET_IMAGE_LOCATION = 'Conf_Uncertain.png'; % Location of target image for import.
TARGET_POSITION = 'Top'; % Choose one of these: UpperLeft, Top, UpperRight, Left, Center, Right, LowerLeft, Bottom, LowerRight.
TARGET_SIZE = 0.5; % From 0 to 1, where 1 means 100% of the screen (half of the window).
TARGET_ROTATION = 0; % Rotation from 0 to 360 degrees (clockwise).
TARGET_TRANSPARENCY = 1; % Contrast from 0 (fully transparent) to 1 (fully opaque).
TARGET_APPEARANCE_DELAY = 2; % Delay after initation of the suppression pattern;
TARGET_FADE_IN_DURATION = 2; % Duration of fading in from 0 transparency to TARGET_TRANSPARENCY.
MASK_POSITION = 'Top'; % Choose one of these: UpperLeft, Top, UpperRight, Left, Center, Right, LowerLeft, Bottom, LowerRight.
MASK_SIZE = 0.5; % From 0 to 1, where 1 means 100% of the screen (half of the window).
MASK_TRANSPARENCY = 1; % Range is 0 = fully transparent to 1 = fully opaque.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%------------------------------BASIC SETTINGS-----------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Get the screen numbers. This gives us a number for each of the screens
% attached to our computer.
screens = Screen('Screens');

% To draw we select the maximum of these numbers. So in a situation where we
% have two screens attached to our monitor we will draw to the external
% screen.
screenNumber = max(screens);

% Do NOT uncomment next command in your studies unless "you want to qualify for the "Dumbest scientist on earth" contest"(c).
% Screen('Preference','SkipSyncTests', 2)

% Open an on-screen window using PsychImaging.
[window, windowRect] = PsychImaging('OpenWindow', screenNumber);

% Just hide the freaking cursor
HideCursor(window);

% Get the size of the on-screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the center coordinates of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Retreive the maximum priority number and set the priority to the maximum
% (concerning OS resources distribution)
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);

% Set up alpha-blending for smooth (anti-aliased) lines
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% Measure the vertical refresh rate of the monitor
ifi = Screen('GetFlipInterval', window);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------SUPPRESSING PATTERN---------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate the delay between masks.
flipSecs = WAITFRAME*ifi;

% Calculate number of mask images
masksNumber = CFS_MASK_DURATION/flipSecs;
masksNumberBeforeTarget = TARGET_APPEARANCE_DELAY/flipSecs;
masksNumberWhileFadeIn = TARGET_FADE_IN_DURATION/flipSecs;

% Generate masks and time it
% Parameters are:
% - Size of mask in x-dimension
% - Size of mask in y-dimension (large difference to sz_x may cause error)
% - Number of masks to be created
% - Shape of elements: 1 = square, 2 = circular, 3 = diamond (default: square)
% - Color style (1 = grayscale, 2 = BRGBYCMW, 3-15 other schemes
%   (try them out and let me know which work best!)
tstart = GetSecs;
masks = make_mondrian_masks(1920/2, 1080, masksNumber, 1, 3);
tend = GetSecs;

% Create an array of PsychToolBox textures from the masks.
texture = cell(1, masksNumber);
for n = 1 : masksNumber
    texture{n} = Screen('MakeTexture', window, masks{n});
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%------------------------------TARGET IMPORT------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load an image and make a texture from it.
theImage = imread(TARGET_IMAGE_LOCATION);
imageTexture = Screen('MakeTexture', window, theImage);

% Get the size of the image
[s1, s2, s3] = size(theImage);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-------------------------------POSITIONING-------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate shift of upperleft and lowerright verticies of target and
% mask image rectangles.
[x0, y0, x1, y1] = positions(TARGET_POSITION, TARGET_SIZE);
[k0, j0, k1, j1] = positions(MASK_POSITION, MASK_SIZE);

% Calculate coordinates for target and mask image rectangles.
if LEFT_SUPPRESSION==true
    targetRect = [(1+x0)*xCenter, y0*screenYpixels, (1+x1)*xCenter, y1*screenYpixels];
    patternRect = [k0*xCenter, j0*screenYpixels, k1*xCenter, j1*screenYpixels];
else
    targetRect = [x0*xCenter, y0*screenYpixels, x1*xCenter, y1*screenYpixels];
    patternRect = [(1+k0)*xCenter, j0*screenYpixels, (1+k1)*xCenter, j1*screenYpixels];
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--------------------------------GREETINGS--------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

INSTRUCTION = sprintf('READY\nIt took %0.1f secs to generate mondrian masks.', tend-tstart);
Screen('TextFont', window, 'Courier');
Screen('TextSize', window, 50);
Screen('TextStyle', window, 1+2);
DrawFormattedText(window, INSTRUCTION, 'center', 'center')
Screen('Flip', window);

% Wait for a key to START
while ~KbWait
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%----------------------------RUNNING EXPERIMENT---------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initiate the experiment, flip the screen with the mask and get timestamp.
Screen('DrawTexture', window, texture{1}, [], patternRect, 0, 1, MASK_TRANSPARENCY);
vbl = Screen('Flip', window);

% Save the experiment start time.
tstart = vbl;

% Flash the suppressing pattern until the target starts to fade in.
for mask = 2:masksNumberBeforeTarget
    Screen('DrawTexture', window, texture{mask}, [], patternRect, 0, 1, MASK_TRANSPARENCY);
    vbl = Screen('Flip', window, vbl + (WAITFRAME - 0.5) * ifi);
end

% Continue flashing the suppressing pattern while changing flip delay 
% for target in order to get smooth fade-in.
for n = 1:masksNumberWhileFadeIn*WAITFRAME
    mask = floor(masksNumberBeforeTarget+n/WAITFRAME);
    thisContrast = n/(masksNumberWhileFadeIn*WAITFRAME)*TARGET_TRANSPARENCY;
    Screen('DrawTexture', window, imageTexture, [], targetRect, TARGET_ROTATION, 1, thisContrast);
    Screen('DrawTexture', window, texture{mask}, [], patternRect, 0, 1, MASK_TRANSPARENCY);    
    vbl = Screen('Flip', window, vbl + (1 - 0.5) * ifi);
end

% After the fade-in return to normal flip delay until the end of the
% experiment.
for mask = masksNumberBeforeTarget + masksNumberWhileFadeIn + 1:masksNumber
    Screen('DrawTexture', window, imageTexture, [], targetRect, TARGET_ROTATION, 1, TARGET_TRANSPARENCY);
    Screen('DrawTexture', window, texture{mask}, [], patternRect, 0, 1, MASK_TRANSPARENCY);
    vbl = Screen('Flip', window, vbl + (WAITFRAME - 0.5) * ifi);
end
vbl = Screen('Flip', window, vbl + (WAITFRAME - 0.5) * ifi);

% Save the experiment end time 
tend = vbl;

% Wait for a key to close the window
KbStrokeWait;

% Calculate the experiment duration.
ttaken = tend-tstart;

% Clear the screen.
Screen('CloseAll');