function load_flashing_parameters(obj, screen)
% LOAD_FLASHING_PARAMETERS Calculates parameters for flashing for the
% current trial.

    obj.indices = arrayfun(@(n) (ceil(n/(screen.frame_rate/obj.temporal_frequency))), ...
        1:(screen.frame_rate*obj.duration + 1));

end