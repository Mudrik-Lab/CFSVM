function shuffle(obj, seed)
    %shuffle_mask Shuffles provided textures with seed.
    obj.seed = seed;
    rng(seed);
    random_order = randperm(length(obj.textures.PTB_indices));
    obj.textures.PTB_indices = obj.textures.PTB_indices(random_order);
end