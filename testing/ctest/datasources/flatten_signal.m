function flat_signal = flatten_signal(sync, valid, signal)
sync_pos = find(sync == 1, 1);
sig_par = min(size(signal));
if ~isempty(sync_pos),
    valid(1:sync_pos) = 0;
end
signal = reshape(signal(repmat(valid, 1, sig_par)==1), sum(valid), sig_par);
flat_signal = reshape(signal.', 1, sig_par * sum(valid));
