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

save('txdata64.mat', ...
    'gbe_data64_00', 'gbe_eof64_00', 'gbe_valid64_00');
% end
