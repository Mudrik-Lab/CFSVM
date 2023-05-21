classdef VPCFS < CFSVM.Experiment.CFS
% Visual priming continuous flash suppression.
%
% Derived from :class:`~CFSVM.Experiment.CFS`.
%
    
    properties

        % :class:`~CFSVM.Element.Screen.CustomScreen` object.
        screen CFSVM.Element.Screen.CustomScreen
        % :class:`~CFSVM.Element.Data.SubjectData` object.
        subject_info CFSVM.Element.Data.SubjectData
        % :class:`~CFSVM.Element.Data.Instructions` object.
        instructions CFSVM.Element.Data.Instructions
        % :class:`~CFSVM.Element.Data.TrialsData` object.
        trials CFSVM.Element.Data.TrialsData
        % :class:`~CFSVM.Element.Stimulus.Fixation` object.
        fixation CFSVM.Element.Stimulus.Fixation
        % :class:`~CFSVM.Element.Screen.CheckFrame` object.
        frame CFSVM.Element.Screen.CheckFrame
        % :class:`~CFSVM.Element.Stimulus.Mondrians` object.
        masks CFSVM.Element.Stimulus.Mondrians
        % :class:`~CFSVM.Element.Stimulus.TargetStimulus` object.
        target CFSVM.Element.Stimulus.TargetStimulus
        % :class:`~CFSVM.Element.Evidence.PAS` object.
        pas CFSVM.Element.Evidence.PAS
        % Either :class:`~CFSVM.Element.Evidence.ImgMAFC` or 
        % :class:`~CFSVM.Element.Evidence.TextMAFC` object.
        mafc {mustBeMAFC} = CFSVM.Element.Evidence.ImgMAFC()

    end
    
    methods

        run(obj)

    end

    methods (Access=protected)

        load_parameters(obj)
        flash(obj, vbl)
    end
end

function mustBeMAFC(a)
    if ~(isa(a,'CFSVM.Element.Evidence.ImgMAFC') || isa(a,'CFSVM.Element.Evidence.TextMAFC'))
        error("mafc object must be instantiated from one of the mAFC classes.")
    end
end