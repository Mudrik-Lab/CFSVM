classdef (Abstract) Experiment < dynamicprops
% Base for :class:`~+CFSVM.+Experiment.@CFS` and :class:`~+CFSVM.+Experiment.@VM` classes.
% 
% Describes very basic methods fomr initiation of PTB-3 window to
% comments containing screens shown to the subject.
%
    

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
        
    end


    methods(Static)

        rgb = hex2rgb(hex)
        wait_for_keypress(key)

    end

end
