len = 8;
rep = 4;

indata = [repmat(1:len,1,rep) repmat(len+1:len*2,1,rep)];

rearranged = zeros(1, length(indata));
for ctr = 1 : length(indata) / (len * rep),
    for ctr2 = 1 : len,
        indata_s = ((ctr-1)*len*rep) + ctr2;
        indata_e = indata_s + (len*rep) - 1;
        sindex = ((ctr-1)*len*rep) + ((ctr2-1)*rep) + 1;
        eindex = sindex + rep - 1;
        rearranged(sindex:eindex) = indata(indata_s : len : indata_e);
    end
end