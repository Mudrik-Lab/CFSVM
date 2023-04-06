import CFSVM.Experiment.* ...
    CFSVM.Element.Screen.* ...
    CFSVM.Element.Data.* ...
    CFSVM.Element.Evidence.* ...
    CFSVM.Element.Stimulus.*

experiment = BCFS();

experiment.fixation = Fixation();
experiment.frame = CheckFrame();

import CFSVM.MondrianGenerator
% Will generate Mondrians inside dirpath/Masks
generator = MondrianGenerator( ...
    '../Stimuli/', ...
    type='rectangle', ...
    x_pixels=512, ...
    y_pixels=512, ...
    min_fraction=1/100, ...
    max_fraction=1/8, ...
    n_figures=1000);

generator.set_physical_properties(60, 1920, 33.5, 1080, 45);

generator.set_shades([0,0,0], 10);

generator.generate(51);

experiment.masks = Mondrians( ...
    dirpath='../Stimuli/Masks', ...
    temporal_frequency=10, ...
    duration=5, ...
    blank=0.5, ...
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


if ~exist('.temp', 'dir')
    mkdir('.temp')
end
save('.temp\experiment.mat', 'experiment')

n_blocks = 1;
n_trials = [30];
trial_matrix = cell(1, n_blocks);

orientations = [0, 45, 90, 135];
n_images = 2;
for block = 1:n_blocks
    for trial = 1:n_trials(block)
        load('.temp\experiment.mat');
        experiment.stimulus_1.index = randi(n_images);
        experiment.stimulus_1.rotation = orientations(randi(length(orientations), 1));
        experiment.stimulus_2.index = randi(n_images);
        experiment.stimulus_2.rotation = orientations(randi(length(orientations), 1));
        if trial >= 20
            experiment.stimulus_2.contrast = 0;
        end
        trial_matrix{block}{trial} = experiment;
    end
    trial_matrix{1} = trial_matrix{1}(randperm(numel(trial_matrix{1})));
end



if ~exist('../TrialMatrix', 'dir')
    mkdir('../TrialMatrix')
end
save('../TrialMatrix/experiment.mat', 'trial_matrix')

rmdir('.temp', 's')
