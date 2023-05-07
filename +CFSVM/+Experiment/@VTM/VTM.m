classdef VTM < CFSVM.Experiment.VM
% Visual temporal masking.
%
% Depending on soa either forward, simultaneous or backward masking.
%
% Derived from :class:`~CFSVM.Experiment.VM`.
%
    
    properties

        % :class:`~CFSVM.Element.Screen.CustomScreen` object.
        screen CFSVM.Element.Screen.CustomScreen
        % :class:`~CFSVM.Element.Data.SubjectData` object.
        subject_info CFSVM.Element.Data.SubjectData
        % :class:`~CFSVM.Element.Data.TrialsData` object.
        trials CFSVM.Element.Data.TrialsData
        % :class:`~CFSVM.Element.Stimulus.Fixation` object.
        fixation CFSVM.Element.Stimulus.Fixation
        % :class:`~CFSVM.Element.Stimulus.Mask` object.
        mask CFSVM.Element.Stimulus.Mask
        % :class:`~CFSVM.Element.Evidence.PAS` object.
        pas CFSVM.Element.Evidence.PAS
        % Either :class:`~CFSVM.Element.Evidence.ImgMAFC` or 
        % :class:`~CFSVM.Element.Evidence.TextMAFC` object.
        mafc {mustBeMAFC} = CFSVM.Element.Evidence.ImgMAFC()
        % Handler for either forward, sim or backward masking flashing.
        flash 

    end

    methods
        
        b_flash(obj)
        f_flash(obj)
        s_flash(obj)

    end

    
end

function mustBeMAFC(a)
    if ~(isa(a,'CFSVM.Element.Evidence.ImgMAFC') || isa(a,'CFSVM.Element.Evidence.TextMAFC'))
        error("mafc object must be instantiated from one of the mAFC classes.")
    end
end