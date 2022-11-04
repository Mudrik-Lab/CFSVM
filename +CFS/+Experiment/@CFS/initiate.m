function initiate(obj)
% INITIATE Prepares the experiment for execution.
%
% Writes subject_info to file, initiates PTB window, 
% runs screen adjustment for stereoscope, imports stimuli images, 
% trial matrices, masks (generates them if need) and shows the
% introductory screen and more.
% 
% See also 
% <p> 
% initiate_window <br>
% show_preparing_screen <br> 
% show_introduction_screen <br>
% CFS.Element.Data.SubjectData.write <br>
% CFS.Element.Screen.CustomScreen.adjust <br> 
% CFS.Element.Stimulus.Stimulus.import_images <br> 
% CFS.Element.Evidence.BreakResponse.create_kbqueue <br> 
% CFS.Element.Data.TrialsData.import <br>
% CFS.Element.Stimulus.Masks.initiate <br>
% CFS.Element.Stimulus.Masks.make_mondrian_masks <br> 
% </p>
    

    obj.subject_info.write()
    
    % Switch to the PTB's internal keys naming scheme.
    KbName('UnifyKeyNames')
    
    % Convert hex to MATLAB rgb color code.
    obj.screen.background_color = hex2rgb(obj.screen.background_color);

    obj.initiate_window()

    obj.screen.adjust(obj.frame)

    obj.show_preparing_screen()

    % Warm WaitSecs() function.
    WaitSecs(0.00001)

    obj.stimulus.import_images(obj.screen.window)
    
    % Imports target images, relevant only for VPCFS and VACFS experiments.
    if class(obj) == "CFS.Experiment.VPCFS" || class(obj) == "CFS.Experiment.VACFS"
        obj.target.import_images(obj.screen.window)
    end
    
    % Creates PTB KbQueue, relevant only for BCFS and VACFS experiments.
    if class(obj) == "CFS.Experiment.BCFS" || class(obj) == "CFS.Experiment.VACFS"
        obj.stimulus_break.create_kbqueue()
    end
    
    obj.trials.import(obj)

    obj.masks.initiate(obj.trials.blocks)
    
    % If the folder provided for masks doesn't exist - generate images to the folder.
    if ~isfolder(obj.masks.dirpath)
        % Use masks size according to the corresponding screen size.
        if obj.subject_info.is_left_suppression == true
            x = obj.screen.left.x_pixels;
            y = obj.screen.left.y_pixels;
        else
            x = obj.screen.right.x_pixels;
            y = obj.screen.right.y_pixels;
        end
        obj.masks.make_mondrian_masks(x,y)
    end

    % Import images and create PTB textures of the masks.
    obj.masks.import_images(obj.screen.window, images_number=obj.masks.n_max)
    
    obj.show_introduction_screen()

end

function rgb = hex2rgb(hex)
    %hex2rgb Transforms hexadecimal color code to MATLAB RGB color code.
    rgb = sscanf(hex(2:end),'%2x%2x%2x',[1 3])/255;
end