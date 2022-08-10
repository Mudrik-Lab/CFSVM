function [screen_x_pixels, screen_y_pixels, x_center, y_center, inter_frame_interval, window] = initiate_window()
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
    screen_number = max(screens);
    
    % Define black and white
    white = WhiteIndex(screen_number);
    black = BlackIndex(screen_number);

    % Only for debugging. Do NOT uncomment next command in your studies 
    % unless "you want to qualify for the "Dumbest scientist on earth" contest"(c).
    %Screen('Preference','SkipSyncTests', 2);
    
    % Open an on-screen window using PsychImaging.
    [window, window_rect] = PsychImaging('OpenWindow', screen_number);
    
    % Just hide the freaking cursor
    HideCursor(window);
    
    % Get the size of the on-screen window
    [screen_x_pixels, screen_y_pixels] = Screen('WindowSize', window);
    
    % Get the center coordinates of the window
    [x_center, y_center] = RectCenter(window_rect);
    
    % Retreive the maximum priority number and set the priority to the maximum
    % (concerning OS resources distribution)
    top_priority_level = MaxPriority(window);
    Priority(top_priority_level);
    
    % Set up alpha-blending for smooth (anti-aliased) lines
    Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    
    % Measure the vertical refresh rate of the monitor
    inter_frame_interval = Screen('GetFlipInterval', window);
end

