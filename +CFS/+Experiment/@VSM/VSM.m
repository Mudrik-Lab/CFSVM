classdef VSM < CFS.Experiment.VM
% Visual sandwich masking.
%
% Contains forward and backward masks - f_mask and b_mask, respectively.
%
% Derived from :class:`~+CFS.+Experiment.@VM`.
%
    
    properties

        % :class:`~+CFS.+Element.+Screen.@CustomScreen` object.
        screen CFS.Element.Screen.CustomScreen
        % :class:`~+CFS.+Element.+Data.@SubjectData` object.
        subject_info CFS.Element.Data.SubjectData
        % :class:`~+CFS.+Element.+Data.@TrialsData` object.
        trials CFS.Element.Data.TrialsData
        % :class:`~+CFS.+Element.+Stimulus.@Fixation` object.
        fixation CFS.Element.Stimulus.Fixation
        % :class:`~+CFS.+Element.+Stimulus.@Mask` object.
        f_mask CFS.Element.Stimulus.Mask
        % :class:`~+CFS.+Element.+Stimulus.@Mask` object.
        b_mask CFS.Element.Stimulus.Mask
        % :class:`~+CFS.+Element.+Evidence.@PAS` object.
        pas CFS.Element.Evidence.PAS
        % Either :class:`~+CFS.+Element.+Evidence.@ImgMAFC` or 
        % :class:`~+CFS.+Element.+Evidence.@TextMAFC` object.
        mafc
        
    end

    methods
        
        flash(obj)

    end

    
end