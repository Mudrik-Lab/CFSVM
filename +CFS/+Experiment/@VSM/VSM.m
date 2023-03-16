classdef VSM < CFS.Experiment.VM
    %VFBM Summary of this class goes here
    %   Detailed explanation goes here
    
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