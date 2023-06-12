function initiate_window(obj)
% Calls basic Psychtoolbox settings.
%
% Adopted and modified from `Peter Scarfe's Psychtoolbox tutorial <https://peterscarfe.com/ptbtutorials.html>`_.
%
    % Here we call some default settings for setting up Psychtoolbox
    PsychDefaultSetup(2);

    % Whether to skip the tests (Use only for debugging)
    Screen('Preference', 'SkipSyncTests', 0);
    
    % Get the screen numbers. This gives us a number for each of the screens
    % attached to our computer.
    screens = Screen('Screens');
    
    % To draw we select the maximum of these numbers. So in a situation where we
    % have two screens attached to our monitor we will draw to the external
    % screen.
    screen_number = max(screens);

    % Open an on-screen window using PsychImaging.
    % For video recording using OBS studio add the screen size argument [0,0,1920,1080]
    obj.screen.window = PsychImaging('OpenWindow', screen_number, obj.screen.background_color); 
    
    % Just hide the freaking cursor
    HideCursor(obj.screen.window);
    
    % Get the size of the on-screen window
    [obj.screen.size(1), obj.screen.size(2)] = Screen('WindowSize', obj.screen.window);
    
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