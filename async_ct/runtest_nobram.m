sync_time = 230;
input_range = [4,4];
output_range = [2,2];
logtofile = 0;

% open the design if it's not open already
if ~strcmp(gcs, 'ct_nobram'),
    open('ct_nobram.slx');
end

if logtofile,
    filename = sprintf('%s.log', datestr(now,'yyyy_mm_dd_HH_MM_SS_FFF'));
    logfile = fopen(filename,'w');
    fprintf('Writing to %s...\n', filename);
else
    logfile = 1;
end
pass = 0;
fail = 0;
test_counter = 0;
fprintf('Running test:       ');

demux_bits = 2; % we still run a 16-to-64 bit demux, so that's a demux in time of 4, 2 bits

input_bits = 10;
ct_bits = 4;
x_bits = 1;

set_param('ct_nobram/dataramp_64', 'n_bits', num2str(input_bits))
set_param('ct_nobram/qdr_ct_nobram', 'input_bits', num2str(input_bits))
set_param('ct_nobram/qdr_ct_nobram', 'ct_bits', num2str(ct_bits))
set_param('ct_nobram/qdr_ct_nobram', 'x_bits', num2str(x_bits))

if exist('force_sim_len', 'var'),
    test_len = force_sim_len;
else
    test_len = 2^(input_bits + ct_bits + demux_bits + 1) + 10000;
end
fprintf('\tthis time for %i cycles\n', test_len);

clear sim_dv sim_sync;
sim_dv = create_valid(test_len, 2);
sim_sync = create_sync(sync_time);

% run in blocks so we know what it's doing
set_param('ct_nobram', 'StopTime', num2str(test_len));
set_param('ct_nobram', 'SimulationCommand','stop');
set_param('ct_nobram', 'SimulationCommand','start');
last_simtime = 0;
while strcmp('running', get_param('ct_nobram', 'SimulationStatus')),
    pause(1);
    simtime = get_param('ct_nobram', 'SimulationTime');
    clks_per_sec = simtime - last_simtime;
    last_simtime = simtime;
    secs_remaining = (test_len - simtime) / clks_per_sec;
    fprintf('\t\tSim time is %i of %i - %.3f secs remaining\n', simtime, test_len, secs_remaining);
end
%sim('ct_nobram', test_len);

% now do a software corner turn on the input data, to compare it
% to the output data
indata = simout_indata.signals.values(simout_indv.signals.values == 1);
indv = simout_indv.signals.values(simout_indv.signals.values == 1);
insync = simout_insync.signals.values(simout_indv.signals.values == 1);
insyncpos = find(insync);
indata = indata(insyncpos+1:end);
indv = indv(insyncpos+1:end);
ct_step = 2^(input_bits - x_bits);
ct_indata = corner_turn(2^input_bits, 2^ct_bits, indata, 0, 1, ct_step);
ct_indata = ct_indata.';

% process the output and compare it to the corner-turned input
outdata = simout_data64.signals.values(simout_dv.signals.values == 1);
outdv = simout_dv.signals.values(simout_dv.signals.values == 1);
outsync = simout_sync.signals.values(simout_dv.signals.values == 1);
if ~any(outsync),
    error('No sync pulse found in the output?');
end
syncpos = find(outsync);
outdata = outdata(syncpos+1:end);
outdv = outdv(syncpos+1:end);

if ~all(outdata == ct_indata(1:length(outdata))),
    error('Output data is not the same as the corner-turned input data.');
end

return


for col_order = [0 1 2],
    for swapped = [0 1],
        for data_pow = input_range(1) : input_range(2),
            for out_vec_pow = output_range(1) : output_range(2),
                custom_map = [];
                interleave_steps = 0;
                if col_order == 1,
                    interleave_steps = pow2(2 : data_pow-1);
                end
                if col_order == 2,
                    custom_map = randperm(pow2(data_pow));
                end
                for interleave_step = interleave_steps,
                    fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\bRunning test: %6i', test_counter);
                    result = test_ct(logfile, data_pow, out_vec_pow, 1, swapped, col_order, interleave_step, custom_map);
                    test_counter = test_counter + 1;
                    if result,
                        pass = pass + 1;
                    else
                        fail = fail + 1;
                    end
                end % interleave_steps
            end % end out_vec_pow
        end % end in_vec_pow
    end % end swap_halves
end % col order
fprintf('\n');

if logtofile,
    fclose(logfile);
end

fprintf('Passed: %i\n', pass);
fprintf('Failed: %i\n', fail);

% end