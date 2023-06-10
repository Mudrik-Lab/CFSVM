function [display_width_cm, display_height_cm] = display_diag2aspects( ...
    display_diagonal_inches, ...
    display_ratio_width, ...
    display_ratio_height ...
    )
% Calculated display width and height in centimeters 
% given diagonal in inches and aspect ratio.
%
% Args:
%   display_diagonal_inches (float): Display diagonal in inches.
%   display_ratio_width (int): Display width aspect, e.g., 16 if ratio is 16:9
%   display_ratio_height (int): Display height aspect, e.g., 9 if ratio is 16:9
%
% Returns:
%   array: array containing:
%
%       display_width_cm (float): Display width in centimeters.
%       display_height_cm (float): Display height in centimeters.
%
    arguments
        display_diagonal_inches {mustBePositive}
        display_ratio_width {mustBeInteger, mustBePositive}
        display_ratio_height {mustBeInteger, mustBePositive}
    end
    cm2inch = @(x) x*2.54;
    display_factor = sqrt(display_diagonal_inches^2/(display_ratio_width^2+display_ratio_height^2));
    
    display_width_cm = cm2inch(display_ratio_width*display_factor);
    display_height_cm = cm2inch(display_ratio_height*display_factor);
end

