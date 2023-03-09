classdef (Abstract) Experiment < dynamicprops
    %EXPERIMENT Summary of this class goes here
    %   Detailed explanation goes here
    

    properties(Access = protected)

        dynpropnames  % Variable for saving names of dynamic properties.

    end
    
    methods

        addprop(obj, prop_name)
        dynpropnames = get_dyn_props(obj)
        initiate_window(obj)
        show_preparing_screen(obj)
        show_introduction_screen(obj)
        show_rest_screen(obj)
        show_farewell_screen(obj)
        wait_for_keypress(obj, key)

    end

end

