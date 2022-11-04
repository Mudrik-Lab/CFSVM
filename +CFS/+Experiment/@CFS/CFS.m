classdef (Abstract) CFS < handle
    % CFS An abstract superclass for three types of Continuous Flash Suppression
    % experiments: Breaking, Visual Priming and Visual Adaptation.
    % These are implemented in subclasses BCFS, VPCFS and VACFS, respectively.
    %
    % See also CFS.Experiment.BCFS, CFS.Experiment.VPCFS,
    % CFS.Experiment.VACFS

    
    properties (Access = protected)

        vbl % Timestamp for internal use in flashing.

    end


    methods (Abstract)

        run(obj)

    end


    methods (Abstract, Access = protected)

        load_parameters(obj)

    end


    methods (Access = protected)
        
        initiate(obj)
        initiate_window(obj)
        show_preparing_screen(obj)
        show_introduction_screen(obj)
        show_rest_screen(obj)
        flash(obj)
        
    end

end

