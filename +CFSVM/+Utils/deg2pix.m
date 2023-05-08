function img_aspect_pixels = deg2pix( ...
    img_aspect_degree, ...
    display_aspect_cm, ...
    display_aspect_pixels, ...
    viewing_distance ...
    )
    arguments
        img_aspect_degree {mustBeInteger, mustBePositive}
        display_aspect_cm {mustBePositive}
        display_aspect_pixels {mustBeInteger, mustBePositive}
        viewing_distance {mustBePositive}
    end
    % Centimeters per pixel.
    pixel_size_cm = display_aspect_cm/display_aspect_pixels;

    % Image size in centimeters.
    img_size_cm = 2*viewing_distance*tan(deg2rad(img_aspect_degree)/2);
    
    % Image size in pixels.
    img_aspect_pixels = round(img_size_cm/pixel_size_cm);
    
end
