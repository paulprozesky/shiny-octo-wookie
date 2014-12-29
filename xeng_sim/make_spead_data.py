__author__ = 'paulp'

valid_ant = 0
valid_pol = 0
start_time = 83545080 << (9 + 1 + 7)
start_time = 1 << (9 + 1 + 7)
time_increment = 1 << (9 + 1 + 7)
num_timestamps_to_process = 30

# constants
start_from = 113
valid_gap = 65  # if this is too small if won't work! - the reorder block falls over
# correlator setup
num_ant = 4
num_x = 32
num_chans = 512
xacc_len = 128
# calculated
chans_per_x = num_chans / num_x
spead_packet_len = xacc_len / 2
window_len = spead_packet_len * num_ant * chans_per_x

# print a little summary:
print 'Channels: ', num_chans
print 'f-engines: ', num_ant
print 'x-engines: ', num_x
print 'Chans per x: ', chans_per_x
print 'X-acc length: ', xacc_len
print 'Gap between valid blocks: ', valid_gap
print 'SPEAD packet length: ', spead_packet_len
print 'Window length: ', window_len
print ''


def make_spead_data(packet_length, data_value, packet_time, input_id, channel):
    spead_data = {'data':       [data_value] * packet_length,
                  'valid':      [1] * packet_length,
                  'eof':        [0] * packet_length,
                  'time48':     [packet_time] * packet_length,
                  'fengid':     [input_id] * packet_length,
                  'flags':      [0] * packet_length,
                  'channel':    [channel] * packet_length,
                  }
    spead_data['eof'][-1] = 1
    return spead_data


# number of timestamps to do - make all the spead packets
packets = []
block_position = 0
freq_block_size = window_len / chans_per_x
for timectr in range(0, num_timestamps_to_process):
    this_time = start_time + (timectr * time_increment)
    # print 'time %i starts at %i:' % (this_time, block_position)
    for freqchan in range(0, num_chans / num_x):
        # freq_position = block_position + (freqchan * freq_block_size)
        # print '\tfreq %i at %i:' % (freqchan, freq_position)
        # print '\t\t',
        for ant in range(0, num_ant):
            # ant_position = freq_position + (ant * spead_packet_len)
            # print 'ant%02i: %i,' % (ant, ant_position),
            # data
            if ant == valid_ant:
                if valid_pol == 0:
                    dataval = 72057594054705152
                else:
                    dataval = 1099511628032
            else:
                dataval = 0
            # make the packet
            pkt = make_spead_data(spead_packet_len, dataval, this_time, ant, freqchan)
            packets.append(pkt)
        # print ''
    block_position += window_len

# make the vectors
packetdata = {}
for key in packets[0].keys():
    packetdata[key] = [0] * start_from

# add the data
for pkt in packets:
    for key in packets[0].keys():
        packetdata[key].extend(pkt[key])
        packetdata[key].extend([0] * valid_gap)

# reorder to columns for matlab and make the matlab dict
import numpy as np
total_length = len(packetdata['valid'])
print 'Total vector length: ', total_length
mat_dict = {}
for key in packets[0].keys():
    mat_dict['sim_spead_%s' % key] = {'time': [],
                                'signals': {'values': np.array(packetdata[key],
                                                               dtype=np.double).reshape(total_length, 1),
                                            'dimensions': 1.0}
    }

# save the matlab dict to a file
import scipy.io as sio
sio.savemat('/tmp/xreord.mat', mat_dict)

# end
