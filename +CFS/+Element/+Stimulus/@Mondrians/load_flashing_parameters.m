function load_flashing_parameters(obj, screen)
% Calculates parameters for flashing for the trial.
%
% Args:
%   screen: :class:`~+CFS.+Element.+Screen.@CustomScreen` object.
%

    obj.indices = arrayfun(@(n) (ceil(n/(screen.frame_rate/obj.temporal_frequency))), ...
        1:(screen.frame_rate*obj.duration + 1));

end