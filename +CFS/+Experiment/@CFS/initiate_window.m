function initiate_window(obj)
% INITIATE_WINDOW Calls basic Psychtoolbox settings and initiates window.
%
% Adopted from Peter Scarfe's Psychtoolbox tutorial - it's really good.
    
    % Here we call some default settings for setting up Psychtoolbox
    PsychDefaultSetup(2);
    
    % Get the screen numbers. This gives us a number for each of the screens
    % attached to our computer.
    screens = Screen('Screens');
    
    % To draw we select the maximum of these numbers. So in a situation where we
    % have two screens attached to our monitor we will draw to the external
    % screen.
    screen_number = max(screens);

    %Screen('Preference','SkipSyncTests', 2);
    %Screen('Preference', 'VisualDebugLevel', 6);

    % Open an on-screen window using PsychImaging.
    obj.screen.window = PsychImaging('OpenWindow', screen_number, obj.screen.background_color); %[0,0,1960,1080]
    
    % Just hide the freaking cursor
    HideCursor(obj.screen.window);
    
    % Get the size of the on-screen window
    Screen('WindowSize', obj.screen.window);
    
    % Retreive the maximum priority number and set the priority to the maximum
    % (concerning OS resources distribution)
    top_priority_level = MaxPriority(obj.screen.window);
    Priority(top_priority_level);
    
    % Set up alpha-blending for smooth (anti-aliased) lines
    Screen('BlendFunction', obj.screen.window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

    % Display's Refresh Rate
    obj.screen.frame_rate = Screen('NominalFrameRate', obj.screen.window);
    
    % Measure the vertical refresh rate of the monitor
    obj.screen.inter_frame_interval = Screen('GetFlipInterval', obj.screen.window);
end