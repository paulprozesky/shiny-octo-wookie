sim_len = 50000;
valid_ant = 0;
valid_pol = 0;
start_time = 83545080;
time_increment = 1;

% constants
start_from = 113;
valid_gap = 111;
% correlator setup
num_ant = 4;
num_x = 32;
num_chans = 512;
xacc_len = 128;
% calculated
chans_per_x = num_chans / num_x;
spead_packet_len = xacc_len / 4;

% print a little summary:
fprintf('Channels: %i\n', num_chans);
fprintf('f-engines: %i\n', num_ant);
fprintf('x-engines: %i\n', num_x);
fprintf('Chans per x: %i\n', chans_per_x);
fprintf('X-acc length: %i\n', xacc_len);
fprintf('Gap between valid blocks: %i\n', valid_gap);
fprintf('SPEAD packet length: %i\n', spead_packet_len);
fprintf('\n');

% number of timestamps to do
sizectr = 0;
for timectr = start_time : start_time + 3,
    for freqchan = 1 : num_chans / num_x,
        for ant = 1 : num_ant,
            % headers
            spead_time48() = timectr;
            spead_fengid() = ant;
            spead_flags() = 0;
            spead_freqid() = freqchan;
            % data array
            timeramp = 1 : xacc_len;
            timeramp = reshape(timeramp, 4, xacc_len/4);
            
            
        end
    end
    sizectr = sizectr + 1;
end







% make the main valid window
% valid_block = cat(2, ones(1, block_len), zeros(1, valid_gap));
% valid_block = repmat(valid_block, 1, blocks_per_window);
valid_vector = ones(1, block_len * blocks_per_window);
sync_vector = zeros(1, length(valid_vector));
sync_vector(sync_offset * xacc_len * num_ant) = 1;
datasel_vector = cat(2, zeros(1, xacc_len * valid_ant), ones(1, xacc_len), zeros(1, xacc_len * (num_ant - valid_ant - 1)));
datasel_vector = repmat(datasel_vector, 1, n_consecutive_chans);
datasel_vector = repmat(datasel_vector, 1, blocks_per_window);

valid_vector = reshape(valid_vector, block_len, blocks_per_window);
sync_vector = reshape(sync_vector, block_len, blocks_per_window);
datasel_vector = reshape(datasel_vector, block_len, blocks_per_window);

valid_block2 = zeros(block_len + valid_gap, blocks_per_window);
sync_vector2 = zeros(block_len + valid_gap, blocks_per_window);
datasel_vector2 = zeros(block_len + valid_gap, blocks_per_window);
for ctr = 1 : blocks_per_window,
    valid_block2(:, ctr) = cat(1, valid_vector(:, ctr), zeros(valid_gap, 1));
    sync_vector2(:, ctr) = cat(1, sync_vector(:, ctr), zeros(valid_gap, 1));
    datasel_vector2(:, ctr) = cat(1, datasel_vector(:, ctr), zeros(valid_gap, 1));
end
valid_vector = reshape(valid_block2, 1, blocks_per_window * (block_len + valid_gap));
sync_vector = reshape(sync_vector2, 1, blocks_per_window * (block_len + valid_gap));
datasel_vector = reshape(datasel_vector2, 1, blocks_per_window * (block_len + valid_gap));
clear valid_block2 sync_block2 datasel_vector2;

% repeat them all to the sim length
num_reps = ceil(sim_len / length(valid_vector));
valid_vector = repmat(valid_vector, 1, num_reps);
datasel_vector = repmat(datasel_vector, 1, num_reps);
sync_vector = repmat(sync_vector, 1, num_reps);
clear num_reps;

% make the time vector
time_vector = zeros(1, length(valid_vector));
this_time = start_time;
spos = 1;
sync_locations = find(sync_vector);
for ctr = 1 : length(sync_locations),
    epos = sync_locations(ctr);
    fprintf('%7i:%7i - time %i\n', spos, epos, this_time);
    time_vector(spos : epos) = ones(1, epos - spos + 1) * this_time;
    spos = epos + 1;
    this_time = this_time + time_increment;
end
clear spos this_time;

% make the correct pol select vector
pol_select_vector = datasel_vector * valid_pol;

% f = figure();
% subplot(5,1,1)
% plot(valid_vector, 'r');
% caxes = axis();
% axis([caxes(2)*-0.1 caxes(2)*1.1 caxes(4)*-0.1 caxes(4)*1.1]);
% subplot(5,1,2)
% plot(sync_vector, 'b');
% caxes = axis();
% axis([caxes(2)*-0.1 caxes(2)*1.1 caxes(4)*-0.1 caxes(4)*1.1]);
% subplot(5,1,3)
% plot(datasel_vector, 'g');
% caxes = axis();
% axis([caxes(2)*-0.1 caxes(2)*1.1 caxes(4)*-0.1 caxes(4)*1.1]);
% subplot(5,1,4)
% plot(pol_select_vector, 'c');
% caxes = axis();
% axis([caxes(2)*-0.1 caxes(2)*1.1 caxes(4)*-0.1 caxes(4)*1.1]);
% subplot(5,1,5)
% time_vector_plot = time_vector;
% time_vector_plot(time_vector_plot == 0) = max(time_vector_plot);
% plot(time_vector_plot, 'm');
% caxes = axis();
% axis([caxes(2)*-0.1 caxes(2)*1.1 min(time_vector_plot)-1 max(time_vector_plot)+1]);

% make the simulink structures
sim_valid.time = []; sim_valid.signals.values = valid_vector'; sim_valid.signals.dimensions = 1;
sim_data_sel.time = []; sim_data_sel.signals.values = datasel_vector'; sim_data_sel.signals.dimensions = 1;
sim_pol_sel.time = []; sim_pol_sel.signals.values = pol_select_vector'; sim_pol_sel.signals.dimensions = 1;
sim_sync.time = []; sim_sync.signals.values = sync_vector'; sim_sync.signals.dimensions = 1;
sim_time.time = []; sim_time.signals.values = time_vector'; sim_time.signals.dimensions = 1;
clear valid_vector datasel_vector pol_select_vector sync_vector;

% done
