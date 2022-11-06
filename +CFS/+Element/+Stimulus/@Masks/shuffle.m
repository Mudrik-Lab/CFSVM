function shuffle(obj)
% SHUFFLE Shuffles provided textures with seed.

    random_order = randperm(length(obj.textures.PTB_indices));
    obj.textures.PTB_indices = obj.textures.PTB_indices(random_order);

end