classdef (Abstract) Experiment < dynamicprops & matlab.mixin.Copyable
% Base for :class:`~CFSVM.Experiment.CFS` and :class:`~CFSVM.Experiment.VM` classes.
% 
% Describes very basic methods fomr initiation of PTB-3 window to
% comments containing screens shown to the subject.
%
    

    properties(Access = protected)

        dynpropnames  % Variable for saving names of dynamic properties.
        save_to_dir
        path_to_functions
    end
    

    methods

        function obj = Experiment(parameters)
            arguments
                parameters.save_to_dir {mustBeTextScalar} = "./Raw"
                parameters.path_to_functions = "./Examples/Greetings"
            end
            obj.save_to_dir = parameters.save_to_dir;
            obj.path_to_functions = parameters.path_to_functions;
        end

        

        addprop(obj, prop_name)
        dynpropnames = get_dyn_props(obj)
        
        initiate_window(obj)
        show_preparing_screen(obj)
        show_introduction_screen(obj)
        show_rest_screen(obj)
        show_farewell_screen(obj)
        
    end
    
    methods(Access = protected)
        % Override copyElement method:
        function copied_obj = copyElement(obj)
            % Make a shallow copy of all properties
            copied_obj = copyElement@matlab.mixin.Copyable(obj);
            % Make a deep copy of handle props
            props = properties(obj);
            for idx = 1:length(props)
                if isa(obj.(props{idx}), 'handle')
                    copied_obj.(props{idx}) = copy(obj.(props{idx}));
                end
            end
        end
    end

    methods(Static)

        wait_for_keypress(key)

    end

end

