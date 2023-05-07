classdef VSM < CFSVM.Experiment.VM
% Visual sandwich masking.
%
% Contains forward and backward masks - f_mask and b_mask, respectively.
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
        f_mask CFSVM.Element.Stimulus.Mask
        % :class:`~CFSVM.Element.Stimulus.Mask` object.
        b_mask CFSVM.Element.Stimulus.Mask
        % :class:`~CFSVM.Element.Evidence.PAS` object.
        pas CFSVM.Element.Evidence.PAS
        % Either :class:`~CFSVM.Element.Evidence.ImgMAFC` or 
        % :class:`~CFSVM.Element.Evidence.TextMAFC` object.
        mafc {mustBeMAFC} = CFSVM.Element.Evidence.ImgMAFC()
        
    end

    methods
        
        flash(obj)

    end

    
end

function mustBeMAFC(a)
    if ~(isa(a,'CFSVM.Element.Evidence.ImgMAFC') || isa(a,'CFSVM.Element.Evidence.TextMAFC'))
        error("mafc object must be instantiated from one of the mAFC classes.")
    end
end