classdef SubjectData < handle
% Inquiry about and recording of the subject info.
%

    properties
        
        dirpath  % Char array for path to directory in which to save the data.
        table  % Table for recording the data
        code  % Anytype for subject code
        is_left_suppression  % Bool, true if dominant eye is left
        file_extension  % Char array, .csv is a default

    end
    

    methods

        function obj = SubjectData(parameters)
        % Inquires subject info and puts it into table.
        %
        % Args:
        %   dirpath: :attr:`~.+CFSVM.+Element.+Data.@SubjectData.SubjectData.dirpath`
        %   file_extenstion: :attr:`~.+CFSVM.+Element.+Data.@SubjectData.SubjectData.file_extension`
        %
        
            arguments
                parameters.dirpath = './!SubjectInfo'
                parameters.file_extension = '.csv'
            end
            
            obj.dirpath = parameters.dirpath;
            
            % If the provided folder doesn't exist - create.
            if ~exist(obj.dirpath, 'dir')
                mkdir(obj.dirpath)
            end
            
            obj.file_extension = parameters.file_extension;
            if obj.file_extension(1) ~= '.'
                obj.file_extension = ['.', obj.file_extension];
            end

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

        end

        write(obj)

    end

end

