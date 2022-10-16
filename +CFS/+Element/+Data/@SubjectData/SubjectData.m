classdef SubjectData < CFS.Element.DataTableElement
    %SUBJECTDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        code
        is_left_suppression
    end
    
    methods
        function obj = SubjectData(parameters)
            %SUBJECTDATA Construct an instance of this class
            %   Detailed explanation goes here
            arguments
                parameters.dirpath = './!SubjectInfo'
            end
            obj.dirpath = parameters.dirpath;

            % Create object from the class
            app = CFS.Element.Data.SubjectInfo();
            %movegui(app.UIFigure, 'center');
            % Wait for the button to be pushed. Either 'Save' or 'Cancel'.
            while ~(app.save_clicked || app.cancel_clicked)
                pause(0.05)
            end
        
            % if cancel button was pushed - delete the object and stop the
            % experiment execution.
            % If save button was pushed - save provided data and set suppressing
            % half of the window. Delete the object at the end.
            if app.cancel_clicked == 1
                app.delete;
                % Stop further execution.
                error('"Cancel" button was pushed, program execution was stopped.')
            else
                obj.code = app.data.code;
                
                if app.data.dominant_eye == "Right"
                    obj.is_left_suppression = false;
                else
                    obj.is_left_suppression = true;
                end

                obj.table = struct2table(app.data);
                obj.table.time = GetSecs();
                obj.filename = num2str(obj.code);

                app.delete;
                
            end

        end
    end
end

