vals = simout_mixed.signals.values;
actual_vector = zeros(1, 50001 * 8);
for ctr = 1 : 2 : 16,
    realvals = vals(:, ctr);
    imagvals = vals(:, ctr + 1);
    num = realvals + (imagvals * 1j);
    actual_vector(floor(ctr/2)+1:8:end) = num;
end

return

vals = sim_adc.signals.values;
complex_input = zeros(100000, 16);
complex_input(:,1:2:end) = vals;
actual_vector = zeros(100000 * 8, 1);
vals = complex_input;
realbit = vals(:,1:2:end);
all(realbit == sim_adc.signals.values)
for ctr = 1 : 2 : 16,
    realvals = vals(:, ctr);
    imagvals = vals(:, ctr + 1);
    num = realvals + (imagvals * 1j);
    actual_vector(floor(ctr/2)+1:8:end) = num;
end
actual_vector = actual_vector.';
all(real(actual_vector) == sim_adc.original)
