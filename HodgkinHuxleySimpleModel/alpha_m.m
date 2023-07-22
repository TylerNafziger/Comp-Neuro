function am = HH_am(V)

am = .1 * (V+40) ./ (1 - exp(-(V+40)/10));

inds = find(isnan(am));
am(inds) = 1;