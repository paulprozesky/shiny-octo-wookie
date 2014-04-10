function ct_save_input()

ctin_en = evalin('base', 'ctin_en.signals.values');
ctin_sync = evalin('base', 'ctin_sync.signals.values');

dlen = length(ctin_sync)-1;

ctsync = zeros(dlen, 2); ctsync(dlen+1:end) = ctin_sync(1:dlen); ctsync(1:dlen) = (1:dlen)';
cten =   zeros(dlen, 2); cten(dlen+1:end) = ctin_en(1:dlen); cten(1:dlen) = (1:dlen)';

clear ctin_en ctin_sync;

save('ct_input.mat', 'ctsync', 'cten');

end