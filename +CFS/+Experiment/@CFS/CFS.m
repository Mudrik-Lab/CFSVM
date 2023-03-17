classdef (Abstract) CFS < CFS.Experiment.Experiment
% Base for :class:`~+CFS.+Experiment.@BCFS` and :class:`~+CFS.+Experiment.@VPCFS` classes.
% 
% Describes common methods for CFS experiments, e.g. initiate() for initiating CFS
% properties.
%
% Derived from :class:`~+CFS.+Experiment.@Experiment`.
%
    
    properties

        vbl_recs  % An array for recording flip timestamps while flashing.

    end
    
    
    methods (Abstract)

        run(obj)

    end


    methods (Abstract, Access = protected)

        load_parameters(obj)

    end


    methods (Access = protected)
        
        initiate(obj)
        preload_stim_and_masks_args(obj, stim_props)

    end

end

