classdef (Abstract) CFS < CFSVM.Experiment.Experiment
% Base for :class:`~+CFSVM.+Experiment.@BCFS` and :class:`~+CFSVM.+Experiment.@VPCFS` classes.
% 
% Describes common methods for CFS experiments, e.g. initiate() for initiating CFS
% properties.
%
% Derived from :class:`~+CFSVM.+Experiment.@Experiment`.
%
    
    properties

        vbl_recs {mustBeNonnegative}  % An array for recording flip timestamps while flashing.

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

