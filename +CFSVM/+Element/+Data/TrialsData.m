classdef TrialsData < matlab.mixin.Copyable
    % Storing and manipulating trial parameters.
    %

    properties (Constant)

        % Parameters to parse into the processed results table.
        RESULTS = {'block_index', 'trial_index', 'start_time', 'end_time'}

    end

    properties

        % Char array, path to the .mat file.
        filepath
        % Nested cell array for trial matrix.
        matrix cell
        % Int, number of blocks in trial matrix.
        n_blocks {mustBeInteger}
        % Int, current block.
        block_index {mustBeInteger}
        % Int, current trial.
        trial_index {mustBeInteger}
        % Float, trial onset.
        start_time {mustBeNonnegative}
        % Float, trial offset.
        end_time {mustBeNonnegative}

    end

    methods

        function obj = TrialsData(kwargs)
            %
            % Args:
            %   filepath: Char array, path to the .mat file.
            %

            arguments
                kwargs.filepath {mustBeFile}
            end

            obj.filepath = CFSVM.Utils.rel2abs(kwargs.filepath);

        end

        function import(obj)
            % Loads .mat file.
            %
            obj.matrix = load(obj.filepath).trial_matrix;
            [~, obj.n_blocks] = size(obj.matrix);

        end

        function load_trial_parameters(obj, experiment)
            % Updates parameters for the current trial.
            %
            % Args:
            %   experiment: An object derived from the :class:`~CFSVM.Experiment.Experiment` subclass.
            %
            dont_load = {'screen', 'subject_info', 'trials', 'instructions'};

            for property = setdiff(properties(experiment)', dont_load)
                experiment.(property{:}) = obj.matrix{obj.block_index}{obj.trial_index}.(property{:});
            end

        end

        function update(obj, experiment)
            % Updates every trial with initialized experiment parameters.
            %
            % Args:
            %   experiment: An object derived from the :class:`~CFSVM.Experiment.Experiment` subclass.
            %
            for block = 1:obj.n_blocks
                for trial = 1:size(obj.matrix{block}, 2)
                    exp = obj.matrix{block}{trial};
                    for prop = properties(exp)'
                        % If a property hasn't been initalized - copy it from the
                        % current experiment
                        if isempty(exp.(prop{:}))
                            exp.(prop{:}) = experiment.(prop{:});

                            % Else update empty property's properties
                        else
                            prop_list = metaclass(exp.(prop{:})).PropertyList;
                            for idx = 1:length(prop_list)
                                if isempty(exp.(prop{:}).(prop_list(idx).Name)) && ~prop_list(idx).Dependent
                                    exp.(prop{:}).(prop_list(idx).Name) = experiment.(prop{:}).(prop_list(idx).Name);
                                end
                            end
                        end
                    end
                end
            end

        end

    end

end
