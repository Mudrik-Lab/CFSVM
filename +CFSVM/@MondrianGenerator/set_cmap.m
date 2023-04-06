function set_cmap(obj, colormap, parameters)
    arguments
        obj
        colormap
        parameters.n_tones = 8
    end
    if strcmpi('grayscale', colormap)
        obj.set_shades([0,0,0], parameters.n_tones);
    elseif strcmpi('reds', colormap)
        obj.set_shades([1,0,0], parameters.n_tones);
    elseif strcmpi('blues', colormap)
        obj.set_shades([0,0,1], parameters.n_tones);
    elseif strcmpi('greens', colormap)
        obj.set_shades([0,1,0], parameters.n_tones);
    else
        switch lower(colormap)
            case 'rgb'
                obj.cmap = [1 0 0
                    0 1 0
                    0 0 1];
            case 'original'
                obj.cmap = [0 0 0
                    1 0 0
                    0 1 0
                    0 0 1
                    1 1 0
                    1 0 1
                    0 1 1
                    1 1 1];
        end
    end
end