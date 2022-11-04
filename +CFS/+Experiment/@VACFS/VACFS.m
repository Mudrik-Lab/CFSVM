classdef VACFS < CFS.Experiment.CFS
    % VACFS Visual adaptation continuous flash suppression.
    % Subclass of the CFS superclass.
    %
    % See also CFS.Experiment.CFS
    
    properties

        screen CFS.Element.Screen.CustomScreen
        subject_info CFS.Element.Data.SubjectData
        trials CFS.Element.Data.TrialsData
        fixation CFS.Element.Stimulus.Fixation
        frame CFS.Element.Screen.CheckFrame
        stimulus CFS.Element.Stimulus.SuppressedStimulus
        masks CFS.Element.Stimulus.Masks
        target CFS.Element.Stimulus.TargetStimulus
        pas CFS.Element.Evidence.PAS
        mafc
        stimulus_break CFS.Element.Evidence.BreakResponse
        results CFS.Element.Data.Results

    end
    
    methods
       
        run(obj)
        
    end

    methods (Access=protected)

        load_parameters(obj)

    end
end

