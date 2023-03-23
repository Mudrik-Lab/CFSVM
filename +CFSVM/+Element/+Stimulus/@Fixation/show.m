function vbl = show(obj, experiment)
% Draws and shows fixation cross on the screen.
%
% Args:
%   experiment: An experiment object.
%
% Returns:
%   float: Onset time of the fixation.
%

    % Left screen cross
    Screen(obj.args{1}{:});
    % Right screen cross
    Screen(obj.args{2}{:});
    % Checkerboard frame
    Screen('FillRect', experiment.screen.window, experiment.frame.colors, experiment.frame.rects);
    % Flip to the screen
    obj.onset = Screen('Flip', experiment.screen.window);
    vbl = obj.onset;

end


