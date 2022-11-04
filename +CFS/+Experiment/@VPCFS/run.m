function run(obj)
% RUN Executes the visual priming CFS experiment.
%
% Firstly initiates the experiment, then for every trial loads parameters,
% shows rest screen and fixation cross, flashes masks and stimuli, 
% shows PAS and mAFC questions, records responses, writes results.

    obj.initiate()
    
    for block = 1:obj.trials.n_blocks
        obj.trials.block_index = block;
        
        for trial = 1:height(obj.trials.blocks{block})
            obj.trials.start_time = GetSecs();
            obj.trials.trial_index = trial;
            obj.load_parameters()

            if trial ~= 1 || block ~= 1
                obj.show_rest_screen()
            end

            obj.vbl = obj.fixation.show(obj);
            
            obj.flash()
            obj.target.show(obj)
            obj.pas.show(obj.screen, obj.frame)
            obj.mafc.show(obj.screen, obj.frame)
            obj.trials.end_time = GetSecs();
            obj.results.import_from(obj)
            obj.results.add_trial_to_table()
            obj.results.write()

        end

    end 

end 