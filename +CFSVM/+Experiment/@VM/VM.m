classdef (Abstract) VM < CFSVM.Experiment.Experiment
% Base for :class:`~+CFSVM.+Experiment.@VTM` and :class:`~+CFSVM.+Experiment.@VSM` classes.
% 
% Describes common methods for visual masking experiments, 
% e.g. initiate() for initiating VM properties or run()
% for running the experiment.
%
% Derived from :class:`~+CFSVM.+Experiment.@Experiment`.
%
    
    methods

        initiate(obj)
        load_parameters(obj)
        draw(obj)
        run(obj)

    end
end

