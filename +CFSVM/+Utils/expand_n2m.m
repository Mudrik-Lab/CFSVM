function n = expand_n2m(n, m)

    w = width(n);
    if w == 1

        n = n + zeros(1, m);

    elseif w < m

        n = repelem(n, m/w);

    end
end

