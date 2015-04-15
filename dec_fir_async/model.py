#!/usr/bin/python

sim_length = 500
data_parallel = 8
coeffs = [8, 7, 6, 5, 4, 3, 2, 1]
coeffs = range(64, 0, -1)
coeffs = [1, 2, 3, 4, 5, 6, 7, 8, 8, 7, 6, 5, 4, 3, 2, 1]

coeffs = range(1, 17)
coeffs.extend(range(16, 0, -1))

# [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1]
# [1 2 3 4 5 6 7 8 8 7 6 5 4 3 2 1]

#####################################################
filter_len = len(coeffs)
dataramp = [0] * (filter_len - data_parallel)
dataramp.extend(range(1, sim_length))
for clock_tick in range(0, sim_length/data_parallel-data_parallel):
    pos = clock_tick * data_parallel
    fsum = 0
    for ctr in range(0, filter_len):
        fsum += coeffs[ctr] * dataramp[pos + ctr]
    print clock_tick, pos, dataramp[pos:pos + filter_len], fsum
