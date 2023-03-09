classdef (Abstract) CFS < CFS.Experiment.Experiment
% Base for :class:`~+CFS.+Experiment.@BCFS` and :class:`~+CFS.+Experiment.@VPCFS` classes.
% 
% Describes common methods for CFS experiments, e.g. flash() for 
% flashing stimuli/mondrians etc. or initiate() for initiating CFS
% properties.
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
        flash(obj, vbl)
        
    end

end

