function img_aspect_pixels = deg2pix( ...
                                     img_aspect_degree, ...
                                     display_aspect_cm, ...
                                     display_aspect_pixels, ...
                                     viewing_distance_cm ...
                                    )
    % Converts image aspect length from degrees of visual angle to pixels.
    %
    % Args:
    %   img_aspect_degree (float): Image aspect length in degrees of visual angle.
    %   display_width_cm (float): Display width in centimeters.
    %   display_width_pixels (int): Display width in pixels.
    %   viewing_distance_cm (float): Distance from eyes to center of the image.
    %
    % Returns:
    %   int: Image aspect length in pixels.
    %
    arguments
        img_aspect_degree {mustBeInteger, mustBePositive}
        display_aspect_cm {mustBePositive}
        display_aspect_pixels {mustBeInteger, mustBePositive}
        viewing_distance_cm {mustBePositive}
    end
    % Centimeters per pixel.
    pixel_size_cm = display_aspect_cm / display_aspect_pixels;

    % Image size in centimeters.
    img_size_cm = 2 * viewing_distance_cm * tan(deg2rad(img_aspect_degree) / 2);

    % Image size in pixels.
    img_aspect_pixels = round(img_size_cm / pixel_size_cm);

end
