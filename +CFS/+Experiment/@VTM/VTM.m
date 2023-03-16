classdef VTM < CFS.Experiment.VM
    %VBM Summary of this class goes here
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
        mask CFS.Element.Stimulus.Mask
        % :class:`~+CFS.+Element.+Evidence.@PAS` object.
        pas CFS.Element.Evidence.PAS
        % Either :class:`~+CFS.+Element.+Evidence.@ImgMAFC` or 
        % :class:`~+CFS.+Element.+Evidence.@TextMAFC` object.
        mafc
        flash
    end

    methods
        
        b_flash(obj)
        f_flash(obj)
        s_flash(obj)

    end

    
end

