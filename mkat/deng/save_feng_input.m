function save_feng_input()

% gap_len = 5;
% dlen = 10;
% a = (1:dlen)';
% eof = zeros(dlen, 1);
% eof(2) = 1;
% eof(6) = 1;
% eofs = find(eof);
% for ctr = 1 : length(eofs),
%     a = [a(1:eofs(ctr)) ; zeros(gap_len, 1) ; a(eofs(ctr)+1:end)];
%     eof = [eof(1:eofs(ctr)) ; zeros(gap_len, 1) ; eof(eofs(ctr)+1:end)];
%     eofs = find(eof);
% end
% b = [a eof]

spead_data00_1 = evalin('base', 'spead_data00_1.signals.values');
spead_data00_2 = evalin('base', 'spead_data00_2.signals.values');
spead_eof00 = evalin('base', 'spead_eof00.signals.values');
spead_valid00 = evalin('base', 'spead_valid00.signals.values');

spead_data01_1 = evalin('base', 'spead_data01_1.signals.values');
spead_data01_2 = evalin('base', 'spead_data01_2.signals.values');
spead_eof01 = evalin('base', 'spead_eof01.signals.values');
spead_valid01 = evalin('base', 'spead_valid01.signals.values');

spead_data10_1 = evalin('base', 'spead_data10_1.signals.values');
spead_data10_2 = evalin('base', 'spead_data10_2.signals.values');
spead_eof10 = evalin('base', 'spead_eof10.signals.values');
spead_valid10 = evalin('base', 'spead_valid10.signals.values');

spead_data11_1 = evalin('base', 'spead_data11_1.signals.values');
spead_data11_2 = evalin('base', 'spead_data11_2.signals.values');
spead_eof11 = evalin('base', 'spead_eof11.signals.values');
spead_valid11 = evalin('base', 'spead_valid11.signals.values');

function [data_lsw, data_msw, eof, valid] = insert_gap(gap_len, data64_lsw, data64_msw, eof64, valid64)
    data_lsw = data64_lsw;
    data_msw = data64_msw;
    eof = eof64;
    valid = valid64;
    eofs = find(eof);
    for ctr = 1 : length(eofs),
        data_lsw = [data_lsw(1:eofs(ctr)) ; zeros(gap_len, 1) ; data_lsw(eofs(ctr)+1:end)];
        data_msw = [data_msw(1:eofs(ctr)) ; zeros(gap_len, 1) ; data_msw(eofs(ctr)+1:end)];
        valid = [valid(1:eofs(ctr)) ; zeros(gap_len, 1) ; valid(eofs(ctr)+1:end)];
        eof = [eof(1:eofs(ctr)) ; zeros(gap_len, 1) ; eof(eofs(ctr)+1:end)];
        eofs = find(eof);
    end
end

dlen = length(spead_data00_1)-1;
gap_len = 10;

clear gbe_data64_00_lsw gbe_data64_00_msw gbe_eof64_00 gbe_valid64_00;
clear gbe_data64_01_lsw gbe_data64_01_msw gbe_eof64_01 gbe_valid64_01;
clear gbe_data64_10_lsw gbe_data64_10_msw gbe_eof64_10 gbe_valid64_10;
clear gbe_data64_11_lsw gbe_data64_11_msw gbe_eof64_11 gbe_valid64_11;

[newdata64_lsw, newdata64_msw, neweof64, newvalid64] = insert_gap(gap_len, ...
    spead_data00_1(1:dlen), ...
    spead_data00_2(1:dlen), ...
    spead_eof00(1:dlen), ...
    spead_valid00(1:dlen));
% assignin('base', 'newdata64_lsw', newdata64_lsw);
% assignin('base', 'newdata64_msw', newdata64_msw);
% assignin('base', 'neweof64', neweof64);
% assignin('base', 'newvalid64', newvalid64);
% return
clear spead_data00_1 spead_data00_2 spead_eof00 spead_valid00;
gbe_data64_00_lsw = zeros(dlen, 2);
gbe_data64_00_lsw(dlen+1:end) = newdata64_lsw(1:dlen);
gbe_data64_00_lsw(1:dlen) = (1:dlen)';
gbe_data64_00_msw = zeros(dlen, 2);
gbe_data64_00_msw(dlen+1:end) = newdata64_msw(1:dlen);
gbe_data64_00_msw(1:dlen) = (1:dlen)';
gbe_eof64_00 = zeros(dlen, 2);
gbe_eof64_00(dlen+1:end) = neweof64(1:dlen);
gbe_eof64_00(1:dlen) = (1:dlen)';
gbe_valid64_00 = zeros(dlen, 2);
gbe_valid64_00(dlen+1:end) = newvalid64(1:dlen);
gbe_valid64_00(1:dlen) = (1:dlen)';
clear newdata64_lsw newdata64_msw neweof64 newvalid64;

[newdata64_lsw, newdata64_msw, neweof64, newvalid64] = insert_gap(gap_len, ...
    spead_data01_1(1:dlen), ...
    spead_data01_2(1:dlen), ...
    spead_eof01(1:dlen), ...
    spead_valid01(1:dlen));
clear spead_data01_1 spead_data01_2 spead_eof01 spead_valid01;
gbe_data64_01_lsw = zeros(dlen, 2);
gbe_data64_01_lsw(dlen+1:end) = newdata64_lsw(1:dlen);
gbe_data64_01_lsw(1:dlen) = (1:dlen)';
gbe_data64_01_msw = zeros(dlen, 2);
gbe_data64_01_msw(dlen+1:end) = newdata64_msw(1:dlen);
gbe_data64_01_msw(1:dlen) = (1:dlen)';
gbe_eof64_01 = zeros(dlen, 2);
gbe_eof64_01(dlen+1:end) = neweof64(1:dlen);
gbe_eof64_01(1:dlen) = (1:dlen)';
gbe_valid64_01 = zeros(dlen, 2);
gbe_valid64_01(dlen+1:end) = newvalid64(1:dlen);
gbe_valid64_01(1:dlen) = (1:dlen)';
clear newdata64_lsw newdata64_msw neweof64 newvalid64;

[newdata64_lsw, newdata64_msw, neweof64, newvalid64] = insert_gap(gap_len, ...
    spead_data10_1(1:dlen), ...
    spead_data10_2(1:dlen), ...
    spead_eof10(1:dlen), ...
    spead_valid10(1:dlen));
clear spead_data10_1 spead_data10_2 spead_eof10 spead_valid10;
gbe_data64_10_lsw = zeros(dlen, 2);
gbe_data64_10_lsw(dlen+1:end) = newdata64_lsw(1:dlen);
gbe_data64_10_lsw(1:dlen) = (1:dlen)';
gbe_data64_10_msw = zeros(dlen, 2);
gbe_data64_10_msw(dlen+1:end) = newdata64_msw(1:dlen);
gbe_data64_10_msw(1:dlen) = (1:dlen)';
gbe_eof64_10 = zeros(dlen, 2);
gbe_eof64_10(dlen+1:end) = neweof64(1:dlen);
gbe_eof64_10(1:dlen) = (1:dlen)';
gbe_valid64_10 = zeros(dlen, 2);
gbe_valid64_10(dlen+1:end) = newvalid64(1:dlen);
gbe_valid64_10(1:dlen) = (1:dlen)';
clear newdata64_lsw newdata64_msw neweof64 newvalid64;

[newdata64_lsw, newdata64_msw, neweof64, newvalid64] = insert_gap(gap_len, ...
    spead_data11_1(1:dlen), ...
    spead_data11_2(1:dlen), ...
    spead_eof11(1:dlen), ...
    spead_valid11(1:dlen));
clear spead_data11_1 spead_data11_2 spead_eof11 spead_valid11;
gbe_data64_11_lsw = zeros(dlen, 2);
gbe_data64_11_lsw(dlen+1:end) = newdata64_lsw(1:dlen);
gbe_data64_11_lsw(1:dlen) = (1:dlen)';
gbe_data64_11_msw = zeros(dlen, 2);
gbe_data64_11_msw(dlen+1:end) = newdata64_msw(1:dlen);
gbe_data64_11_msw(1:dlen) = (1:dlen)';
gbe_eof64_11 = zeros(dlen, 2);
gbe_eof64_11(dlen+1:end) = neweof64(1:dlen);
gbe_eof64_11(1:dlen) = (1:dlen)';
gbe_valid64_11 = zeros(dlen, 2);
gbe_valid64_11(dlen+1:end) = newvalid64(1:dlen);
gbe_valid64_11(1:dlen) = (1:dlen)';
clear newdata64_lsw newdata64_msw neweof64 newvalid64;

save('digdata64.mat', ...
    'gbe_data64_00_lsw', 'gbe_data64_00_msw', 'gbe_eof64_00', 'gbe_valid64_00', ...
    'gbe_data64_01_lsw', 'gbe_data64_01_msw', 'gbe_eof64_01', 'gbe_valid64_01', ...
    'gbe_data64_10_lsw', 'gbe_data64_10_msw', 'gbe_eof64_10', 'gbe_valid64_10', ...
    'gbe_data64_11_lsw', 'gbe_data64_11_msw', 'gbe_eof64_11', 'gbe_valid64_11');

end
% end
