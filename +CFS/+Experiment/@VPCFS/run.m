function run(obj)
% RUN Executes the visual priming CFS experiment.
%
% Firstly initiates the experiment, then for every trial loads parameters,
% shows rest screen and fixation cross, flashes masks and stimuli, 
% shows PAS and mAFC questions, records responses, writes results.

    obj.initiate();

    for block = 1:obj.trials.n_blocks
        obj.trials.block_index = block;
        
        for trial = 1:width(obj.trials.matrix{block})
            obj.trials.start_time = GetSecs();
            obj.trials.trial_index = trial;
            obj.trials.load_trial_parameters(obj);

            vbl = obj.fixation.show(obj);
            
            obj.flash(vbl)
            obj.target.show(obj)
            obj.pas.show(obj.screen, obj.frame)
            obj.mafc.show(obj.screen, obj.frame)
            obj.trials.end_time = GetSecs();
            obj.show_rest_screen()
            save(sprintf("!Raw/%s/block%d_trial%d.mat", obj.subject_info.code, obj.trials.block_index, obj.trials.trial_index), 'obj')
            obj.wait_for_keypress('return')
        end

    end 

end 