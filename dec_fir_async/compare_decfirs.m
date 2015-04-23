fft_length = 4096;
sim_length = 50000;
sync_pos = floor(rand * 300);

% make the signal for the async filter
sim_dv = create_valid(sim_length, 2);
sim_sync = create_sync(sync_pos);
sim_adc = create_cwtone_multiple(214, 1712, [20 75 200], 8, sim_length, false, sim_dv.signals.values);
sim_dv.signals.values(find(sim_sync.signals.values, 1)) = 1;

% now collapse the input signal for the serial filter
sim_sync_serial = sim_sync;
tmp = sim_dv.signals.values(1:length(sim_sync.signals.values));
sim_sync_serial.signals.values = sim_sync_serial.signals.values(tmp == 1);
clear tmp;
sim_adc_serial = sim_adc;
tmp = repmat(sim_dv.signals.values, 1, 8);
sim_adc_serial.signals.values = reshape(sim_adc.signals.values(tmp == 1), sum(sim_dv.signals.values), 8);

tmp_async = flatten_signal(sim_sync.signals.values, sim_dv.signals.values, sim_adc.signals.values);
fft_async = fft(tmp_async, fft_length);
subplot(511); semilogy(abs(fft_async)); title('FFT of original signal');
tmp_serial = flatten_signal(sim_sync_serial.signals.values, ones(1, length(sim_adc_serial.signals.values)), sim_adc_serial.signals.values);
fft_serial = fft(tmp_serial, fft_length);
clear tmp_async tmp_serial;
compare_length = min(length(fft_async), length(fft_serial));
if ~all(fft_async(1:compare_length) == fft_serial(1:compare_length)),
    fprintf('ERROR in the FFTs of original signals.\n');
else
    fprintf('FFT of original outputs okay.\n');
end

% run the two simulations
sim('compare_serial', length(sim_adc_serial.signals.values));
sim('compare_async', length(sim_adc.signals.values));

% compare the output
syncpos_serial = find(simout_sync_serial.signals.values, 1);
data_serial_r = simout_filt_data_r_serial.signals.values(syncpos_serial + 1 : end);
data_serial_i = simout_filt_data_i_serial.signals.values(syncpos_serial + 1 : end);

syncpos_async = find(simout_sync_async.signals.values, 1);
data_async_r = simout_filt_data_r_async.signals.values(syncpos_async + 1 : end);
data_async_i = simout_filt_data_i_async.signals.values(syncpos_async + 1 : end);
dv_async = simout_dv_async.signals.values(syncpos_async + 1 : end);
data_async_r = data_async_r(dv_async == 1);
data_async_i = data_async_i(dv_async == 1);

compare_length = min(length(data_async_r), length(data_serial_r));
if ~all(data_async_r(1:compare_length) == data_serial_r(1:compare_length)),
    fprintf('ERROR in the REAL part of the results.\n');
else
    fprintf('REAL output okay over %i samples.\n', compare_length);
end

fft_async = fft(data_async_r, fft_length);
subplot(512); semilogy(abs(fft_async)); title('FFT of FILTERED REAL async signal');
fft_serial = fft(data_serial_r, fft_length);
subplot(513); semilogy(abs(fft_serial)); title('FFT of FILTERED REAL serial signal');
clear fft_async fft_serial;

compare_length = min(length(data_async_i), length(data_serial_i));
if ~all(data_async_i(1:compare_length) == data_serial_i(1:compare_length)),
    fprintf('ERROR in the IMAG part of the results.\n');
else
    fprintf('IMAG output okay over %i samples.\n', compare_length);
end

fft_async = fft(data_async_i, fft_length);
subplot(514); semilogy(abs(fft_async)); title('FFT of FILTERED IMAG async signal');
fft_serial = fft(data_serial_i, fft_length);
subplot(515); semilogy(abs(fft_serial)); title('FFT of FILTERED IMAG serial signal');
clear fft_async fft_serial;
