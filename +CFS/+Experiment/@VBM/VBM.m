classdef VBM < CFS.Experiment.Experiment
    %VBM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties

        % :class:`~+CFS.+Element.+Screen.@CustomScreen` object.
        screen CFS.Element.Screen.MonoScreen
        % :class:`~+CFS.+Element.+Data.@SubjectData` object.
        subject_info CFS.Element.Data.SubjectData
        % :class:`~+CFS.+Element.+Data.@TrialsData` object.
        trials CFS.Element.Data.TrialsData
        % :class:`~+CFS.+Element.+Stimulus.@Fixation` object.
        fixation CFS.Element.Stimulus.Fixation
        % :class:`~+CFS.+Element.+Stimulus.@Masks` object.
        mask CFS.Element.Stimulus.Mask

    end

    methods

        run(obj)

    end

    methods(Access=protected)

        initiate(obj)
        flash(obj)

    end
    
end

