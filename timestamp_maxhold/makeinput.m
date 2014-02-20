dlen = 1000;

sim_reset = zeros(dlen, 2);
sim_reset(1:dlen) = (1:dlen)';
sim_reset(dlen + 100) = 1;
sim_reset(dlen + 265) = 1;

sim_timestamp = zeros(dlen, 2);
sim_timestamp(dlen+1:end) = (1:2:dlen*2)';
sim_timestamp(1:dlen) = (1:dlen)';
sim_timestamp(dlen + 200) = sim_timestamp(dlen + 199) - 73;
sim_timestamp(dlen + 220) = 100;

% end
