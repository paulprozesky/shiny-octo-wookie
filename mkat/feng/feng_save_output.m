function feng_save_output()

for ctr = 1 : 16,
    eval(sprintf('ftxdata16_%i = evalin(''base'', ''txdata16_%i.signals.values'');', ctr, ctr));
end

for ctr = 1 : 4,
    eval(sprintf('ftxeof_%i = evalin(''base'', ''txeof_%i.signals.values'');', ctr, ctr));
    eval(sprintf('ftxvalid_%i = evalin(''base'', ''txvalid_%i.signals.values'');', ctr, ctr));
    eval(sprintf('ftxoverflow_%i = evalin(''base'', ''txoverflow_%i.signals.values'');', ctr, ctr));
end
   
ftxip = evalin('base', 'txip.signals.values');
ftxport = evalin('base', 'txport.signals.values');

dlen = length(ftxdata16_1)-1;
save_string = 'save(''feng_out_data.mat'', ';

for ctr = 1 : 16,
    eval(sprintf('fengoutdata_%i = zeros(dlen, 2); fengoutdata_%i(dlen+1:end) = ftxdata16_%i(1:dlen); fengoutdata_%i(1:dlen) = (1:dlen)'';', ctr, ctr, ctr, ctr));
    save_string = [save_string, sprintf('''fengoutdata_%i'', ', ctr)];
end

for ctr = 1 : 4,
    eval(sprintf('fengouteof_%i = zeros(dlen, 2); fengouteof_%i(dlen+1:end) = ftxeof_%i(1:dlen); fengouteof_%i(1:dlen) = (1:dlen)'';', ctr, ctr, ctr, ctr));
    eval(sprintf('fengoutvalid_%i = zeros(dlen, 2); fengoutvalid_%i(dlen+1:end) = ftxvalid_%i(1:dlen); fengoutvalid_%i(1:dlen) = (1:dlen)'';', ctr, ctr, ctr, ctr));
    eval(sprintf('fengoutoverflow_%i = zeros(dlen, 2); fengoutoverflow_%i(dlen+1:end) = ftxoverflow_%i(1:dlen); fengoutoverflow_%i(1:dlen) = (1:dlen)'';', ctr, ctr, ctr, ctr));
    save_string = [save_string, sprintf('''fengouteof_%i'', ', ctr)];
    save_string = [save_string, sprintf('''fengoutvalid_%i'', ', ctr)];
    save_string = [save_string, sprintf('''fengoutoverflow_%i'', ', ctr)];
end

fengoutip = zeros(dlen, 2); fengoutip(dlen+1:end) = ftxip(1:dlen); fengoutip(1:dlen) = (1:dlen)';
fengoutport = zeros(dlen, 2); fengoutport(dlen+1:end) = ftxport(1:dlen); fengoutport(1:dlen) = (1:dlen)';
save_string = [save_string, '''fengoutip'', ''fengoutport'');'];

eval(save_string);

end