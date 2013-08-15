function result = test_ct(logfile, in_vector_power, out_vector_power, random_dv, swapped_halves, column_order, interleave, custom_map)
%TEST_CT Summary of this function goes here
%   Detailed explanation goes here

    data_len = 2^in_vector_power;
    out_vector_length = 2^out_vector_power;
    sync_location = ceil(rand()*50);
    fprintf(logfile, '*******************************************************************************\n');
    fprintf(logfile, 'data_vector_length(%i) output_vector_length(%i) random_dv(%i) swapped(%i) col_order(%i) interleave(%i) map([%s])\n', data_len, out_vector_length, random_dv, swapped_halves, column_order, interleave, num2str(custom_map));

    % make the dv and data
    input_length = data_len * out_vector_length * 2;
    if random_dv == 1,
        % input ramp with random dv
        [sim_data, sim_dv] = create_ramp(input_length, [], 1);
    else
        % input ramp with constant dv - i.e. a stream
        [sim_data, sim_dv] = create_ramp(input_length);
    end

    % corner turn in software so we have something to compare against
    ct_data = corner_turn(data_len, out_vector_length, sim_data.signals.values(sim_dv.signals.values == 1), swapped_halves, column_order, interleave, custom_map);

    % offset for sync pulse        
    sim_sync = create_sync(sync_location);
    sim_dv.signals.values = [zeros(1, sync_location) sim_dv.signals.values']';
    sim_data.signals.values = [zeros(1, sync_location) sim_data.signals.values']';

    % assign to base workspace so the model can 'see' the test data
    assignin('base', 'sim_sync', sim_sync);
    assignin('base', 'sim_dv', sim_dv);
    assignin('base', 'sim_data', sim_data);

    % run the ct sim
    sim_length = length(sim_data.signals.values) * 4;
    fprintf(logfile, '\tSync is at %i. Simulating for %i cycles.', sync_location, sim_length);
    set_param('test/qdr_ct', 'output_order', 'in order');
    set_param('test/qdr_ct', 'step_bits', '0');
    set_param('test/qdr_ct', 'custom_map', sprintf('[%s]', num2str(custom_map - 1)));
    set_param('test/qdr_ct', 'idepth', sprintf('%i', log2(data_len)));
    set_param('test/qdr_ct', 'odepth', sprintf('%i', log2(out_vector_length)));
    if column_order == 0,
        set_param('test/qdr_ct', 'output_order', 'in order');
    elseif column_order == 1,
        set_param('test/qdr_ct', 'output_order', 'interleaved');
        set_param('test/qdr_ct', 'step_bits', sprintf('%i', log2(interleave)));
    elseif column_order == 2,
        set_param('test/qdr_ct', 'output_order', 'custom');
    end
    if swapped_halves,
        set_param('test/qdr_ct', 'swap_input', 'yes');
    else
        set_param('test/qdr_ct', 'swap_input', 'no');
    end
    set_param('test/outlimit', 'const', sprintf('%i', length(sim_dv.signals.values) + 100));
    sim('test', sim_length);

    assignin('base', 'simout_maxaddr', simout_maxaddr);
    
    % collapse the output data to only valid data
    check_length = length(ct_data);
    out_sync_position = find(simout_sync.signals.values);
    fprintf(logfile, ' Output sync at %i, ran for %i cycles.\n', out_sync_position, simout_simtime.signals.values);
    tempdv = simout_dv.signals.values(out_sync_position+1:end);
    tempdata = simout_data.signals.values(out_sync_position+1:end);
    out_sequence = tempdata(tempdv == 1)';
    if length(out_sequence) < check_length,
        check_length = length(out_sequence);
        fprintf(logfile, '\tLimiting check length from %i to %i.\n', length(ct_data), check_length);
        error('actually, this is a problem');
    end
    if check_length == 0,
        error('Something went very wrong.');
    end
    out_sequence = out_sequence(1:check_length);
    matched = all(ct_data(1:check_length) == out_sequence(1:check_length));
    if matched,
        fprintf(logfile, '\tPASS\n');
        result = 1;
    else
        dumpvar = sprintf('faildump_%s', datestr(now,'yyyy_mm_dd_HH_MM_SS_FFF'));
        fprintf(logfile, '\t\t!!!!!!!!!! ERROR - dumped to %s!!!!!!!!!!\n', dumpvar);
        result = 0;
        faildump.simout_sync = simout_sync;
        faildump.simout_data = simout_data;
        faildump.simout_dv = simout_dv;
        faildump.simout_simtime = simout_simtime;
        faildump.sim_sync = sim_sync;
        faildump.sim_dv = sim_dv;
        faildump.sim_data = sim_data;
        faildump.ct_data = ct_data;
        faildump.out_sequence = out_sequence;
        faildump.random_dv = random_dv;
        faildump.swapped_halves = swapped_halves;
        faildump.column_order = column_order;
        faildump.interleave = interleave;
        faildump.custom_map = custom_map;
        faildump.in_vector_power = in_vector_power;
        faildump.out_vector_power = out_vector_power;
        assignin('base', dumpvar, faildump);
    end
    fprintf(logfile, '*******************************************************************************\n');

end

