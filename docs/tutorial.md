# CFS tutorial

```
Author: Gennadiy Belonosov <gennadiyb@mail.tau.ac.il>
```

💡 We will try to roughly simulate Experiment 2 from the original Tsuchiya and Koch [study](https://doi.org/10.1038/nn1500).

## Start from installing the package
- [How to install](installation)

## A word of caution

- This tutorial is only intended to present the capabilities and some functions of the package.
- Exact replication of the original Tsuchiya & Koch experiments is possible, but requires deeper modifications of the code, which are only briefly introduced here.
- For simplicity, Gabor patch parameters such as spatial frequency, luminance etc. are ignored.
- The Gabor patches were generated [here](https://www.cogsci.nl/gabor-generator).

## Extracting parameters from Tsuchiya & Koch’s experiment #2

![Untitled](tutorial/tnk.png)

Let's examine experiment #2 in the [Methods section](https://www.nature.com/articles/nn1500#Sec9) and [Supplementary Table 1](https://www.nature.com/articles/nn1500#Sec15) of the paper to extract relevant parameters.

- [ ]  The contrast of two Gabor patches was set to 30%
- [ ]  The phase and orientation of the Gabors were choosen randomly
- [ ]  The flashing frequency of the Mondrians was 10 Hz
- [ ]  Adaptation continued for 5 seconds
- [ ]  After the adaptation grey background was shown
- [ ]  20 trials with Gabor patches on both sides
- [ ]  10 trials with a Gabor patch only on the side that is not suppressed by Mondrians
- [ ]  The 10 trials are randomly interleaved with the 20 trials

## Preparing the experiment

### Create the experiment folder

I will name it simply simply the `Experiment` folder in the *Documents*, for example:

*C:\Users\Gennadiy\Documents\Experiment*

### Stimuli

Create new folder inside the `Experiment` and put in it two Gabor images with transparent backgrounds and opposite phases, like these: 

![Untitled](tutorial/gabor1.png)

![Untitled](tutorial/gabor2.png)

### Trial matrix

We will start by generating trials. 
You can just open the example script by running `open TnK_generate_trials` in the MATLAB command window. Or you can create your own `generate_trials.m` file and follow the tutorial.

The main idea of this script is to create an experiment object for each trial and save it in one .mat file. Let’s construct the script command by command.

#### Import the package

```matlab
import CFSVM.Experiment.* ...
    CFSVM.Element.Screen.* ...
    CFSVM.Element.Data.* ...
    CFSVM.Element.Evidence.* ...
    CFSVM.Element.Stimulus.*
```

#### Choose the experiment type

We will use **BCFS** template for this experiment, as there is no need for **VPCFS**-related mAFC and PAS

```matlab
experiment = BCFS();
```

#### Initialize the object’s properties

**BCFS** template has multiple required properties:

| Property | Class |
| --- | --- |
| screen | CustomScreen |
| subject_info | SubjectData |
| trials  | TrialsData |
| fixation | Fixation |
| frame  | CheckFrame |
| masks  | Mondrians |
| breakthrough  | BreakResponse |

We will initialize only a few of them here: **fixation**, **frame**, **masks**, **breakthrough**. The remaining properties will be initialized at the start of the experiment. We will also add two dynamic properties for stimuli, representing two Gabor patches.

Let’s start with **fixation** and **frame**, though the order doesn’t really matter. The **Fixation** and **CheckFrame** classes have some customisation parameters, but we won’t set them here, as they are not critical for our needs. You can read more about the parameters in the [API](./+CFSVM.rst).

```matlab
experiment.fixation = Fixation();
experiment.frame = CheckFrame();
```

Next, we will set the **masks** property. The first parameter we will provide is the path to the folder containing Mondrian images. If you want to generate Mondrians from scratch, set the **mondrians_shape** and **mondrians_color** parameters. The masks will be generated in the provided path.

We will set **temporal_frequency** to 10 Hz, **duration** to 5 seconds, and **position** to "Right" (so that it suppresses only the right Gabor patch).

To adjust the Mondrians' position, we will set **size** to 0.45 (1 will fill the whole right side, 0.5 will fill half of the right side depending on **position**), **padding** to 0.5 (0 will align to the frame, 1 will align to the center of the fixation cross), and **xy_ratio** to 1 (square). You can also change the contrast and rotation if desired.

Finally, we will set **blank** to 5 seconds, which will show a blank screen with fixations after the masks flashing has been ended.

```
experiment.masks = Mondrians( ...
    './Masks/', ...
    mondrians_shape=1, ...
    mondrians_color=1, ...
    temporal_frequency=10, ...
    duration=5, ...
    position="Right", ...
    size=0.45, ...
    padding=0.5, ...
    xy_ratio=1, ...
    contrast=1, ...
    rotation=0,
    blank=5);
```

Now we will add two stimuli properties for the Gabor patches.

Create the properties first:

```matlab
experiment.addprop('stimulus_1');
experiment.addprop('stimulus_2');
```

Then initialize them. We will provide path to the folder with different (phase and orientation) Gabors.

We will set *show_duration* for both of them equal to 5 seconds. We will set different *position* for them: “Left” for the first and “Right” for the second.

We will set *contrast* to 0.3 (30%), *size* to 0.4, *padding* to 0.5 and *xy_ratio* to 1.

```
experiment.stimulus_1 = SuppressedStimulus( ...
    './Images', ...
    show_duration=5, ...
    position="Left", ...
	contrast=0.3, ...
    size=0.4, ...
    padding=0.5, ...
    xy_ratio=1);
experiment.stimulus_2 = SuppressedStimulus( ...
    './Images', ...
    show_duration=5, ...
    position="Right", ...
	contrast=0.3, ...
    size=0.4, ...
    padding=0.5, ...
    xy_ratio=1);
```

Here you can set parameters for the *breakthrough* property, which basically records the time and the key pressed by subject. It’s not much relevant for our needs here, so we will just initialize it and move on.

```matlab
experiment.breakthrough = BreakResponse();
```

To be able to create independent experiment object for every trial, we will record our *experiment* object to the file and then we will load this file for every trial.

```matlab
if ~exist('.temp', 'dir')
    mkdir('.temp')
end
save('.temp\experiment.mat', 'experiment')
```

Let’s set number of blocks and trials. It works this way: number of blocks is a natural number and number of trials is a list of length=n_blocks containing number of trials for every block.

The last line will initialize a cell array for the trial matrix.

```matlab
n_blocks = 1;
n_trials = [30];
trial_matrix = cell(1, n_blocks);
```

Now, all 30 trials we will randomise Gabor images and their orientations for both stimuli properties. 

For 10 of these 30 trials we will set the contrast for the second stimulus to 0, so that it doesn’t appear.

Afterwards, we will shuffle the trials.

```matlab
orientations = [0, 45, 90, 135];
n_images = 2;
block = 1;
for trial = 1:30
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
```

Save the trial matrix to the file:

```matlab
if ~exist('TrialMatrix', 'dir')
    mkdir('TrialMatrix')
end
save('TrialMatrix\experiment.mat', 'trial_matrix')
```

Don’t forget to clean temp files:

```matlab
rmdir('.temp', 's')
```

Don’t forget to run the code! You will find the file with trial matrix in the directory you provided to the `save()` function.

Congrats! We are almost there!

## The last step before the run

So far we’ve generated the trials. Now we want to run the experiment.

Again, you can either use the example: `open TnK_main` file or you can create your own `main.m`. Make sure the relative paths to the stimuli images and masks you provided while generating trials are preserved.

Let’s start building our `main.m` script.

Clear the workspace and the screen:

```matlab
Screen('CloseAll');
close all;
clear;
```

Import the package:

```matlab
import CFSVM.Experiment.* ...
    CFSVM.Element.Screen.* ...
    CFSVM.Element.Data.*
```

Initialize the BCFS object

```matlab
experiment = BCFS();
```

Initialize **subject_info** property by providing directory to save the info in.

```matlab
experiment.subject_info = SubjectData( ...
    dirpath='./!SubjectInfo');
```

Initialize **trials** property by providing a path to the already generated file with the trial matrix.

```matlab
experiment.trials = TrialsData( ...
    filepath='./TrialMatrix/experiment.mat');
```

Initialize **screen** property by setting *is_stereo* to `true` and providing rectangle for the left screen field. The first two numbers in the rect array are x and y pixels of the upper left rectangle vertex, the last two numbers are x and y pixels of the lower right vertex.
The right field will be set symmetrically to the left one.

We will also provide hex code for the background color - *#AEAEAE* grey here.

```matlab
experiment.screen = CustomScreen( ...
    is_stereo=true, ...
    initial_rect=[30, 270, 930, 810], ...
    background_color='#AEAEAE');
```

The last two lines of code are quite self explanatory:

```matlab
experiment.run()

Screen('CloseAll')
```

That’s it! You can run the `main.m` script now!

## Running the experiment

Right after executing the script you’ll see the dialogue for collecting the subject data:

![Untitled](tutorial/subjinfo.png)

Now you will proceed to the experiment itself.

And that's it! Once you’ve adjusted the screens, you'll see the introduction screen. After that, the CFS will begin.

[Example run of the experiment](https://drive.google.com/file/d/1GaprHYRkqoBciiAhCTZY-zux2j1I_oIb/view)

## The data

The raw trial data will appear in the `!Raw` folder. Every `.mat` file will contain an experiment object similar to the ones we have generated while creating the trial matrix, but containing timings and subject responses.

You can run `CFSVM.extract_from_raw_cfs(subject_code)` (subject_code will be 'HZ4' in this example) script to extract the data from the raw files. It will create two csv tables in `!Results` and `!Processed` folders, the first one containing raw timings and the second one processed ones (e.g., duration instead of onset and offset).

![Raw files](tutorial/rawfiles.png)

Raw files

![Extracted from raw, unprocessed CSV](tutorial/results_unprocessed.png)

Extracted from raw, unprocessed CSV

![Processed CSV](tutorial/results_processed.png)

Processed CSV

## Thanks!