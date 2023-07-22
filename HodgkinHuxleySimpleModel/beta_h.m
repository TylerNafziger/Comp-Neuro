function bh = HH_bh(V)

bh = 1 ./ (1 + exp(-(V+35)/10));