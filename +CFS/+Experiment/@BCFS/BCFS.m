classdef BCFS < CFS.Experiment.CFS
% Breaking continuous flash suppression.
%
% Derived from :class:`~+CFS.+Experiment.@CFS`.
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
        % :class:`~+CFS.+Element.+Screen.@CheckFrame` object.
        frame CFS.Element.Screen.CheckFrame
        % :class:`~+CFS.+Element.+Stimulus.@Masks` object.
        masks CFS.Element.Stimulus.Masks
        % :class:`~+CFS.+Element.+Evidence.@BreakResponse` object.
        stimulus_break CFS.Element.Evidence.BreakResponse
        
    end


    methods

        run(obj)
        
    end
    

    methods (Access = protected)

        load_parameters(obj)
        
    end

end

