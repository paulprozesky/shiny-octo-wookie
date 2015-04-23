sim_dv = create_valid(5000, 0);
sim_sync = create_sync(23);
sim_adc = create_cwtone_multiple(214, 1712, [20 75 200], 8, 5000, false, sim_dv.signals.values);
sim_dv.signals.values(find(sim_sync.signals.values, 1)) = 1;

sim(gcs, 5000);

flat_input = flatten_signal(sim_sync.signals.values, sim_dv.signals.values, sim_adc.signals.values);
subplot(411); semilogy(abs(fft(flat_input, 4096))); title('FFT on input');

% plot the filtered signal also
filt_sync_pos = find(simout_filt_sync.signals.values == 1, 1);
filt_data_r = simout_filt_data_r.signals.values(filt_sync_pos + 1 : end);
filt_data_i = simout_filt_data_i.signals.values(filt_sync_pos + 1 : end);
filt_data = filt_data_r + (1j * filt_data_i);

filt_data_r_conv = simout_filt_data_r_conv.signals.values(filt_sync_pos + 1 : end);
filt_data_i_conv = simout_filt_data_i_conv.signals.values(filt_sync_pos + 1 : end);
filt_data_conv = filt_data_r_conv + (1j * filt_data_i_conv);

subplot(412); semilogy(abs(fft(filt_data, 4096))); title('Decfir');
subplot(413); semilogy(abs(fft(filt_data_r, 4096))); title('Decfir REAL');
subplot(414); semilogy(abs(fft(filt_data_r_conv, 4096))); title('Decfir CONV');
%clear filt_data filt_data_r filt_data_i;
