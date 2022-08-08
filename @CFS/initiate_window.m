function [screenXpixels, screenYpixels, xCenter, yCenter, inter_frame_interval, window] = initiate_window()
    %initiate_window Calls basic Psychtoolbox settings and initiates window.
    % Adopted from Peter Scarfe's Psychtoolbox tutorial - it's really good.
    
    % Here we call some default settings for setting up Psychtoolbox
    PsychDefaultSetup(2);
    
    % Get the screen numbers. This gives us a number for each of the screens
    % attached to our computer.
    screens = Screen('Screens');
    
    % To draw we select the maximum of these numbers. So in a situation where we
    % have two screens attached to our monitor we will draw to the external
    % screen.
    screenNumber = max(screens);
    
    % Only for debugging. Do NOT uncomment next command in your studies 
    % unless "you want to qualify for the "Dumbest scientist on earth" contest"(c).
    %Screen('Preference','SkipSyncTests', 2);
    
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
    inter_frame_interval = Screen('GetFlipInterval', window);
end

