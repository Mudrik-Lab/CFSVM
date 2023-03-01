classdef (Abstract) CFS < dynamicprops
% Base for :class:`~+CFS.+Experiment.@BCFS` and :class:`~+CFS.+Experiment.@VPCFS` classes.
% 
% Describes common methods for CFS experiments, e.g. flash() for 
% flashing stimuli/mondrians etc. or initiate() for initiating CFS
% properties.
%
    
    properties

        vbl_recs  % An array for recording flip timestamps while flashing.

    end
    
    properties(Access = protected)

        dynpropnames  % Variable for saving names of dynamic properties.

    end
    
    methods

        addprop(obj, prop_name)

        dynpropnames = get_dyn_props(obj)

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
        preload_stim_and_masks_args(obj, stim_props)
        show_preparing_screen(obj)
        show_introduction_screen(obj)
        show_rest_screen(obj)
        show_farewell_screen(obj)
        wait_for_keypress(obj, key)
        flash(obj, vbl)
        
    end

end

