function save_reord_out()

re_data1 = evalin('base', 'redata_1.signals.values');
re_data2 = evalin('base', 'redata_2.signals.values');
re_data3 = evalin('base', 'redata_3.signals.values');
re_data4 = evalin('base', 'redata_4.signals.values');
re_data5 = evalin('base', 'redata_5.signals.values');
re_data6 = evalin('base', 'redata_6.signals.values');
re_data7 = evalin('base', 'redata_7.signals.values');
re_data8 = evalin('base', 'redata_8.signals.values');

re_time1 = evalin('base', 'retime_1.signals.values');
re_time2 = evalin('base', 'retime_2.signals.values');

re_recvd = evalin('base', 'rerecvd.signals.values');
re_valid = evalin('base', 'revalid.signals.values');

dlen = length(re_data1)-1;

reorddata_1 = zeros(dlen, 2); reorddata_1(dlen+1:end) = re_data1(1:dlen); reorddata_1(1:dlen) = (1:dlen)';
reorddata_2 = zeros(dlen, 2); reorddata_2(dlen+1:end) = re_data2(1:dlen); reorddata_2(1:dlen) = (1:dlen)';
reorddata_3 = zeros(dlen, 2); reorddata_3(dlen+1:end) = re_data3(1:dlen); reorddata_3(1:dlen) = (1:dlen)';
reorddata_4 = zeros(dlen, 2); reorddata_4(dlen+1:end) = re_data4(1:dlen); reorddata_4(1:dlen) = (1:dlen)';
reorddata_5 = zeros(dlen, 2); reorddata_5(dlen+1:end) = re_data5(1:dlen); reorddata_5(1:dlen) = (1:dlen)';
reorddata_6 = zeros(dlen, 2); reorddata_6(dlen+1:end) = re_data6(1:dlen); reorddata_6(1:dlen) = (1:dlen)';
reorddata_7 = zeros(dlen, 2); reorddata_7(dlen+1:end) = re_data7(1:dlen); reorddata_7(1:dlen) = (1:dlen)';
reorddata_8 = zeros(dlen, 2); reorddata_8(dlen+1:end) = re_data8(1:dlen); reorddata_8(1:dlen) = (1:dlen)';

reordtime1 = zeros(dlen, 2); reordtime1(dlen+1:end) = re_time1(1:dlen); reordtime1(1:dlen) = (1:dlen)';
reordtime2 = zeros(dlen, 2); reordtime2(dlen+1:end) = re_time2(1:dlen); reordtime2(1:dlen) = (1:dlen)';

reordrecvd = zeros(dlen, 2); reordrecvd(dlen+1:end) = re_recvd(1:dlen); reordrecvd(1:dlen) = (1:dlen)';
reordvalid = zeros(dlen, 2); reordvalid(dlen+1:end) = re_valid(1:dlen); reordvalid(1:dlen) = (1:dlen)';

clear re_data1 re_data2 re_data3 re_data4 re_data5 re_data6 re_data7 re_data8 re_time1 re_time2 re_recvd re_valid;

save('reorddata.mat', ...
    'reorddata_1', 'reorddata_2', 'reorddata_3', 'reorddata_4', ...
    'reorddata_5', 'reorddata_6', 'reorddata_7', 'reorddata_8', ...
    'reordtime1', 'reordtime2', 'reordrecvd', 'reordvalid');

end