dlen = length(gbe_data.signals.values)-1;
clear gbe_data64_00 gbe_eof64_00 gbe_valid64_00;

gbe_data64_00 = zeros(dlen, 2);
gbe_data64_00(dlen+1:end) = gbe_data.signals.values(1:dlen);
gbe_data64_00(1:dlen) = (1:dlen)';
gbe_eof64_00 = zeros(dlen, 2);
gbe_eof64_00(dlen+1:end) = gbe_eof.signals.values(1:dlen);
gbe_eof64_00(1:dlen) = (1:dlen)';
gbe_valid64_00 = zeros(dlen, 2);
gbe_valid64_00(dlen+1:end) = gbe_valid.signals.values(1:dlen);
gbe_valid64_00(1:dlen) = (1:dlen)';


dlen = length(unpacked_data.signals.values)-1;
clear unpacked_data_00 unpacked_valid_00 unpacked_ready_00;

unpacked_data_00 = zeros(dlen, 2);
unpacked_data_00(dlen+1:end) = unpacked_data.signals.values(1:dlen);
unpacked_data_00(1:dlen) = (1:dlen)';
unpacked_valid_00 = zeros(dlen, 2);
unpacked_valid_00(dlen+1:end) = unpacked_valid.signals.values(1:dlen);
unpacked_valid_00(1:dlen) = (1:dlen)';
unpacked_ready_00 = zeros(dlen, 2);
unpacked_ready_00(dlen+1:end) = unpacked_ready.signals.values(1:dlen);
unpacked_ready_00(1:dlen) = (1:dlen)';


save('txdata64.mat', ...
    'gbe_data64_00', 'gbe_eof64_00', 'gbe_valid64_00', ...
    'unpacked_data_00', 'unpacked_valid_00', 'unpacked_ready_00');
% end
