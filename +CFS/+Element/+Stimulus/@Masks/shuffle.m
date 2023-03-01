function shuffle(obj)
% Shuffles masks textures.

    random_order = randperm(length(obj.textures.PTB_indices));
    obj.textures.PTB_indices = obj.textures.PTB_indices(random_order);

end