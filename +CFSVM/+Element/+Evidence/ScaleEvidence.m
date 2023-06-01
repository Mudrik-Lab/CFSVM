classdef (Abstract) ScaleEvidence < ...
CFSVM.Element.ResponseElement & ...
CFSVM.Element.TemporalElement
% A base class for description of scale-based evidence classes like
% :class:`~CFSVM.Element.Evidence.PAS` and
% :class:`~CFSVM.Element.Evidence.ImgMAFC`.
%
    properties

        % ``Char array`` representing title or question shown on screen.
        title {mustBeTextScalar} = ''

        % ``Int``
        title_size {mustBeNonnegative, mustBeInteger}

        % ``Cell array``
        options cell

        % ``Int`` length of :attr:`~CFSVM.Element.ResponseElement.keys`
        n_options {mustBeInteger}

    end

    methods

        function record_response(obj)
        % Waits for a keypress specified in :attr:`~CFSVM.Element.ResponseElement.keys` and
        % records response properties.
        %

            while 1

                [obj.response_time, keyCode, ~] = KbWait();
                if ismember(KbName(keyCode), obj.keys(1:end))
                    response_kbname = KbName(keyCode);
                    break
                end
                
            end

            obj.response_choice = find(strcmpi(obj.keys, response_kbname));
            obj.response_kbname = convertCharsToStrings(response_kbname);

        end

    end
end
