classdef (Abstract) VM < CFS.Experiment.Experiment
% Base for :class:`~+CFS.+Experiment.@VTM` and :class:`~+CFS.+Experiment.@VSM` classes.
% 
% Describes common methods for visual masking experiments, 
% e.g. initiate() for initiating VM properties or run()
% for running the experiment.
%
% Derived from :class:`~+CFS.+Experiment.@Experiment`.
%
    
    methods

        initiate(obj)
        load_parameters(obj)
        draw(obj)
        run(obj)

    end
end

