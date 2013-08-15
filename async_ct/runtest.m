input_range = [4,4];
output_range = [2,2];
logtofile = 0;

% open the design if it's not open already
if ~strcmp(gcs, 'test'),
    open('test.slx');
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