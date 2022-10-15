# CFS
**CFS** is an object-oriented high-level MATLAB (2021b+) package based on [Psychtoolbox-3](http://psychtoolbox.org/) intended as a well-developed and up-to-date infrastructure for building and running **Continuous Flash Suppression** experiments.

## Installation
Just clone or download the repo from the main branch. 
```
git clone https://github.com/Genuster/CFS.git
```
## Quickstart

### 1. Open main script
Open _main.m_ file and make sure the package folder is on the MATLAB path.
### 2. Choose type of the experiment
Assign the `experiment` variable to one of the currently implemented classes: 
- BCFS for breaking CFS
- VPCFS for visual priming CFS 
- VACFS for visual adaptation CFS
```
experiment = BCFS();
```
### 3. Customise the experiment
- Change parameters of the `experiment` properties, e.g. BCFS properties would be `trials`, `screen`, `frame`, `fixation`, `stimulus`, `masks`, `pas`, `stimulus_break`, `results`, `subject_info`. Read more about these in the documentation. For example, if you want the duration of the fixation be equal to 1.5 seconds, you should set the `duration` parameter of the `experiment.fixation` property to 1.5.
```
experiment.fixation = Fixation( ...
    duration=1.5, ...
    arm_length=20, ...
    line_width=4, ...
    color='#525252');
```
- Make sure that you have either provided all the relevant paths (e.g. path to the directory with stimulus images) or put the experiment data to the default paths.

### 4. Run the experiment
Congrats! You are all set, you may execute the _main.m_ script, which will run the experiment.
