classdef BCFS < CFS.Experiment.CFS
    % BCFS Breaking continuous flash suppression.
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
        stimulus_break CFS.Element.Evidence.BreakResponse
        results CFS.Element.Data.Results
        
    end


    methods

        run(obj)

    end
    

    methods (Access = protected)

        load_parameters(obj)
        
    end

end

