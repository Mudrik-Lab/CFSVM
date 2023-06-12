classdef BreakResponse < CFSVM.Element.ResponseElement
    % Initiating and recording break data.
    %

    properties (Constant)

        % Parameters to parse into the processed results table.
        RESULTS = {'response_time', 'response_choice', 'response_kbname'}

    end

    methods

        function obj = BreakResponse(kwargs)
            %
            % Args:
            %   keys: :attr:`~CFSVM.Element.ResponseElement.keys`.
            %       Defaults to ``{'LeftArrow', 'RightArrow'}``
            %

            arguments
                kwargs.keys = {'LeftArrow', 'RightArrow'}
            end

            kwargs_names = fieldnames(kwargs);
            for name = 1:length(kwargs_names)
                obj.(kwargs_names{name}) = kwargs.(kwargs_names{name});
            end
        end

        function get(obj, pressed, first_press)
            % Processes response properties from the PTB KbQueue.
            %
            % Args:
            %   pressed: Bool, whether any key was pressed.
            %   first_press: PTB timing of presses.
            %

            if pressed
                % Get only nonzero timings.
                keys_first_press = first_press(1, KbName(convertStringsToChars(obj.keys)));
                % Get sorted array of numeric codes converted from keys provided as
                % a parameter.
                sorted_codes = sort(KbName(obj.keys));
                % Get KbName code of the first key pressed.
                first_pressed_code = sorted_codes(keys_first_press == min(keys_first_press(keys_first_press ~= 0)));
                % Get KbName key of the first key pressed.
                obj.response_choice = find(KbName(obj.keys) == first_pressed_code);
                obj.response_kbname = obj.keys(obj.response_choice);
                obj.response_time = min(keys_first_press(keys_first_press ~= 0));
            else
                % If not pressed set breaking key to an empty string and time to
                % zero.
                obj.response_choice = -1;
                obj.response_kbname = "";
                obj.response_time = 0;
            end

        end

        function create_kbqueue(obj)
            % Creates PTB KbQueue.
            %
            % For more information, check the `PTB documentation <http://psychtoolbox.org/docs/KbQueueCreate>`_.
            %

            keys = [KbName(obj.keys)]; % All keys on right hand plus trigger, can be found by running KbDemo
            keylist = zeros(1, 256); % Create a list of 256 zeros
            keylist(keys) = 1; % Set keys you interested in to 1
            KbQueueCreate(-1, keylist); % Create the queue with the provided keys

        end

    end

end
