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
        masks CFS.Element.Stimulus.Masks
        stimulus_break CFS.Element.Evidence.BreakResponse
        
    end


    methods

        run(obj)
        
    end
    

    methods (Access = protected)

        load_parameters(obj)
        
    end

end

