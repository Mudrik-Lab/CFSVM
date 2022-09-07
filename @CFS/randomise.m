function [x, seed] = randomise(number_of_elements, repeats)
%RANDOMISE Summary of this function goes here
%   Detailed explanation goes here
    rng shuffle;
    seed = rng;
    seed = seed.Seed;
    x = randi(number_of_elements, 1, repeats);
    i = find(diff(x));
    n = [i numel(x)] - [0 i];
    while (max(n)>4)
        x = randi(number_of_elements, 1, repeats);
        i = find(diff(x));
        n = [i numel(x)] - [0 i];
    end
end

