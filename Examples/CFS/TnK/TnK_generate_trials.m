import CFSVM.Experiment.* ...
    CFSVM.Element.Screen.* ...
    CFSVM.Element.Data.* ...
    CFSVM.Element.Evidence.* ...
    CFSVM.Element.Stimulus.*

experiment = BCFS();

experiment.frame = CheckFrame( ...
    hex_colors={'#000000', '#FFFFFF'}, ...
    checker_length=30, ...
    checker_width=15);

import CFSVM.Generators.FixationGenerator
% Will generate fixation.png inside dirpath/Fixation/
generator = FixationGenerator( ...
    '../Stimuli/', ...
    hex_color='#000000', ...
    radius=256, ...
    is_smooth_edges=true, ...
    smoothing_cycles=5);
generator.C(cross_width=64)

experiment.fixation = Fixation( ...
    '../Stimuli/Fixation', ...
    duration=1, ...
    size=0.05);


import CFSVM.Generators.MondrianGenerator
% Will generate Mondrians inside dirpath/Masks/
generator = MondrianGenerator( ...
    '../Stimuli/', ...
    type='rectangle', ...
    x_pixels=512, ...
    y_pixels=512, ...
    min_fraction=1/20, ...
    max_fraction=1/8, ...
    n_figures=1000, ...
    cmap='grayscale');

generator.set_physical_properties(60, 1920, 33.5, 1080, 45);

% generator.set_shades([0,0,0], 5);
% generator.cmap = [0 0 0
%             0.25 0.25 0.25 
%             0.5 0.5 0.5 
%             0.75 0.75 0.75 
%             1 1 1]

generator.generate(50);

experiment.masks = Mondrians( ...
    dirpath='../Stimuli/Masks', ...
    temporal_frequency=10, ...
    duration=5, ...
    blank=5, ...
    position="Right", ...
    size=0.45, ...
    padding=0.3, ...
    xy_ratio=1, ...
    contrast=1, ...
    rotation=0);

experiment.addprop('stimulus_1');
experiment.addprop('stimulus_2');
experiment.stimulus_1 = SuppressedStimulus( ...
    '../Stimuli/Suppressed', ...
    duration=5, ...
    position="Left", ...
    size=0.5, ...
    padding=0.5, ...
    xy_ratio=1, ...
    contrast=0.3);
experiment.stimulus_2 = SuppressedStimulus( ...
    '../Stimuli/Suppressed', ...
    duration=5, ...
    position="Right", ...
    size=0.5, ...
    padding=0.5, ...
    xy_ratio=1, ...
    contrast=0.3);


experiment.breakthrough = BreakResponse();


n_blocks = 1;
n_trials = [30];
trial_matrix = cell(1, n_blocks);

orientations = [0, 45, 90, 135];
n_images = 2;
for block = 1:n_blocks
    for trial = 1:n_trials(block)
        exp_copy = copy(experiment);
        exp_copy.stimulus_1.index = randi(n_images);
        exp_copy.stimulus_1.rotation = orientations(randi(length(orientations), 1));
        exp_copy.stimulus_2.index = randi(n_images);
        exp_copy.stimulus_2.rotation = orientations(randi(length(orientations), 1));
        if trial >= 20
            exp_copy.stimulus_2.contrast = 0;
        end
        trial_matrix{block}{trial} = exp_copy;
    end
    trial_matrix{1} = trial_matrix{1}(randperm(numel(trial_matrix{1})));
end



if ~exist('../TrialMatrix', 'dir')
    mkdir('../TrialMatrix')
end
save('../TrialMatrix/experiment.mat', 'trial_matrix')
