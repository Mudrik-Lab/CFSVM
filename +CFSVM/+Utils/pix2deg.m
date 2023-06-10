function img_aspect_degree = pix2deg( ...
    img_aspect_pixels, ...
    display_aspect_cm, ...
    display_aspect_pixels, ...
    viewing_distance_cm ...
    )
% Converts image aspect length from pixels to degrees of visual angle. 
%
% Args:
%   img_aspect_pixels (int): Image aspect length in pixels.
%   display_width_cm (float): Display width in centimeters.
%   display_width_pixels (int): Display width in pixels.
%   viewing_distance_cm (float): Distance from eyes to center of the image.
%
% Returns:
%   float: Image aspect length in degrees of visual angle.
%
    arguments
        img_aspect_pixels {mustBeInteger, mustBePositive}
        display_aspect_cm {mustBePositive}
        display_aspect_pixels {mustBeInteger, mustBePositive}
        viewing_distance_cm {mustBePositive}
    end
    % Centimeters per pixel.
    pixel_size_cm = display_aspect_cm/display_aspect_pixels;

    % Image size in centimeters.
    img_size_cm = pixel_size_cm * img_aspect_pixels;

    % Image size in degrees of visual angle.
    img_aspect_degree = rad2deg(2 * atan(img_size_cm/(2 * viewing_distance_cm)));
    
end
