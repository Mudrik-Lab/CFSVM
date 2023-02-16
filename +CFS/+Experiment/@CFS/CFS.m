classdef (Abstract) CFS < dynamicprops
    % CFS An abstract superclass for two types of Continuous Flash Suppression
    % experiments: Breaking and Visual Priming.
    % These are implemented in subclasses BCFS and VPCFS, respectively.
    %
    % See also CFS.Experiment.BCFS, CFS.Experiment.VPCFS

    
    properties

        vbl_recs % Variable for recording flip timestamps.

    end
    
    properties(Access = protected)
        dynpropnames % Variable for saving names of dynamic properties.
    end
    
    methods
        function addprop(obj,prop_name)
            % First add the property to the list of dynamic properties
            obj.dynpropnames{end+1} = prop_name;
            % Then call the addprop method of dynamicprops, which actually adds the dynamic property 
            addprop@dynamicprops(obj,prop_name);
        end

        function dynpropnames=get_dynamic_properties(obj)
            % Return a list of dynamic properties
            dynpropnames=obj.dynpropnames;
        end
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

