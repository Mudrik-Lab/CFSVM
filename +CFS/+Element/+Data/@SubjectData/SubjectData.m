classdef SubjectData < CFS.Element.DataTableElement
% SUBJECTDATA Class for inquiring about subject info and for recording it.
    
    properties

        code
        is_left_suppression

    end
    

    methods

        function obj = SubjectData(parameters)
            % SUBJECTDATA Construct an instance of this class

            arguments
                parameters.dirpath = './!SubjectInfo'
            end
            
            obj.dirpath = parameters.dirpath;
            data.code = input('Subject code\n> ', 's');
            data.birthdate = input('Date of birth\n> ', 's');
            data.dominant_eye = input('Dominant eye\n> ', 's');
            data.dominant_hand = input('Dominant hand\n> ', 's');

            obj.code = data.code;  

            if strcmpi(data.dominant_eye, "Left")
                obj.is_left_suppression = true;
            else
                obj.is_left_suppression = false;
            end

            obj.table = struct2table(data);
            obj.table.time = GetSecs();
            obj.filename = num2str(obj.code);

        end

    end

end

