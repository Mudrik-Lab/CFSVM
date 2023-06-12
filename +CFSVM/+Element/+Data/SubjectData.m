classdef SubjectData < matlab.mixin.Copyable
    % Inquiry about and recording of the subject info.
    %

    properties (SetAccess = private)

        % Char array for path to directory in which to save the data.
        dirpath
        % A table storing subject info.
        table
        % Char array for subject code.
        code
        % Bool, whether to suppress the left eye in CFS.
        is_left_suppression
        % Info table extension.
        file_extension

    end

    methods

        function obj = SubjectData(kwargs)
            % Inquires subject info and puts it into table.
            %
            % Args:
            %   dirpath: Char array for path to directory in which to save the data.
            %       Defaults to './SubjectInfo'.
            %   file_extenstion: Char array. Defaults to '.csv'.
            %
            arguments
                kwargs.dirpath {mustBeTextScalar} = './SubjectInfo'
                kwargs.file_extension {mustBeTextScalar} = '.csv'
            end

            obj.dirpath = CFSVM.Utils.rel2abs(kwargs.dirpath);

            % If the provided folder doesn't exist - create.
            if ~exist(obj.dirpath, 'dir')
                mkdir(obj.dirpath);
            end

            obj.file_extension = char(kwargs.file_extension);
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

        function write(obj)
            % Writes table to the dirpath.
            %

            % Write the table to the folder with provided filename and extension.
            writetable(obj.table, ...
                       fullfile(obj.dirpath, ...
                                strcat(num2str(obj.code), obj.file_extension)));

        end

    end

end
