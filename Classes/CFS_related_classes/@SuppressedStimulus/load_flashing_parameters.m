function load_flashing_parameters(obj, masks)

    obj.contrasts_in = obj.contrast/ ...
        (masks.n_while_fade_in*masks.waitframe+1): ...
        obj.contrast/(masks.n_while_fade_in*masks.waitframe+1): ...
        obj.contrast;
    obj.contrasts_out = obj.contrast/ ...
        (masks.n_while_fade_out*masks.waitframe+1): ...
        obj.contrast/(masks.n_while_fade_out*masks.waitframe+1): ...
        obj.contrast;
end