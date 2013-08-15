% swap_input - 0 for no swap, 1 for swapped halves of input vector
% column order - 0 for normal, 1 for interleaved (see interleave_step), 2 for custom (see custom_map)
% interleave_step - how should the columns be interleaved?
% custom_map - custom output order
function ct = corner_turn(iv_length, ov_length, idata, swap_input, column_order, interleave_step, custom_map)
    ctlen = iv_length * ov_length;
    dlen = length(idata);
    if mod(length(idata) , ctlen) > 0,
        error('Length of input data (%i) must be a multiple of total corner turn length (len(iv=%i)*len(ov=%i)).\n', length(idata), iv_length, ov_length);
    end
    ct = zeros(1, dlen);
    for ivec_num = 1 : dlen / ctlen,
        input_vector_s = ((ivec_num-1)*ctlen)+1;
        input_vector_e = input_vector_s + ctlen - 1;
        input_vector = idata(input_vector_s:input_vector_e);
        % act on options
        for ivec = 1 : ov_length,
            ivecs = ((ivec-1) * iv_length) + 1;
            ivece = ivecs + iv_length - 1;
            input_window = input_vector(ivecs:ivece);
            % swap
            if swap_input,
                hl = iv_length/2;
                input_window = [input_window(hl+1:end) input_window(1:hl)];
            end
            % interleaved
            if column_order == 1,
                if interleave_step < 2,
                    error('An interleave step of <2 does not really make sense.');
                end
                newiw = zeros(1, iv_length);
                for ctr = 1 : interleave_step,
                    newiws = ((ctr-1) * iv_length / interleave_step) + 1;
                    newiwe = newiws + (iv_length/interleave_step) - 1;
                    newiw(newiws:newiwe) = input_window(ctr:interleave_step:end);
                end
                input_window = newiw;
            % custom
            elseif column_order == 2,
                if length(custom_map) ~= iv_length,
                    error('Length of custom vector is not the same as input vector length?');
                end
                input_window = input_window(custom_map);
            end
            input_vector(ivecs:ivece) = input_window;
        end
        % corner turn that window
        ct(input_vector_s : input_vector_e) = reshape(permute(reshape(input_vector, iv_length, ov_length), [2,1]), 1, ctlen);
    end
end
% end