function load_flashing_parameters(obj, screen)
% Calculates parameters for flashing for the trial.
%
% Args:
%   screen: :class:`~CFSVM.Element.Screen.CustomScreen` object.
%
    if obj.crafter_masks
        obj.indices = 1:screen.frame_rate*obj.duration + 1;
    else
        obj.indices = arrayfun(@(n) (ceil(n/(screen.frame_rate/obj.temporal_frequency))), ...
            1:(screen.frame_rate*obj.duration + 1));
    end
    

end