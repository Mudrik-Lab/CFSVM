function cycles_per_deg = cycles_per_pixel2cycles_per_deg( ...
                                                          cycles_per_pix, ...
                                                          display_width_cm, ...
                                                          display_width_pixels, ...
                                                          viewing_distance_cm ...
                                                         )
    % Converts spatial frequency from cycles per pixel unit
    % to cycles per degree unit.
    %
    % Args:
    %   cycles_per_pix (float): Spatial frequency in cycles per pixel.
    %   display_width_cm (float): Display width in centimeters.
    %   display_width_pixels (int): Display width in pixels.
    %   viewing_distance_cm (float): Distance from eyes to center of the stimulus.
    %
    % Returns:
    %   float: Spatial frequency in cycles per degree.
    %
    arguments
        cycles_per_pix {mustBePositive}
        display_aspect_cm {mustBePositive}
        display_aspect_pixels {mustBeInteger, mustBePositive}
        viewing_distance_cm {mustBePositive}
    end
    pixel_size_cm = display_width_cm / display_width_pixels;
    cycles_per_rad = cycles_per_pix * viewing_distance_cm / pixel_size_cm;
    cycles_per_deg = cycles_per_rad * (pi / 180);

end
