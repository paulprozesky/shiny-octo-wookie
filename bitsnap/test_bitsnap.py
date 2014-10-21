import casperfpga
import struct

snapwidth_bits = 128
snaplen_words = 1024

snapwidth_bytes = snapwidth_bits / 8  # in bytes
snaplen_bytes = snaplen_words *  snapwidth_bytes

fpga = casperfpga.katcp_fpga.KatcpFpga('roach020922')
# fpga.upload_to_ram_and_program('/home/paulp/bitsnap_2014_Oct_21_1551.fpg')
fpga.get_system_information()

fields = []

data = fpga.snapshots.bitsnap_ss.read(man_trig=True, man_valid=True)['data']
for key in data.keys():
    first = data[key][0]
    print '%s: %.20f' % (key, first)
    for d in data[key]:
        assert(first == d)
assert data['n64_0'][0] == 2245676952858558464
assert data['n64_13'][0] == 1234567890.123413


data = fpga.snapshots.bitsnap1_ss.read(man_trig=True, man_valid=True)['data']
for key in data.keys():
    first = data[key][0]
    print '%s: %.20f' % (key, first)
    for d in data[key]:
        assert(first == d)
assert data['n64_0'][0] == -9223372036854775808
assert data['n64_13'][0] == -1234567890.123413

data = fpga.snapshots.bitsnap2_ss.read(man_trig=True, man_valid=True)['data']
for key in data.keys():
    first = data[key][0]
    print '%s: %.20f' % (key, first)
    for d in data[key]:
        assert(first == d)
assert data['n83_0'][0] == 9671406556917033397649407

data = fpga.snapshots.bitsnap3_ss.read(man_trig=True, man_valid=True)['data']
for key in data.keys():
    first = data[key][0]
    print '%s: %.20f' % (key, first)
    for d in data[key]:
        assert(first == d)
assert data['n83_47'][0] == 68719476735.12345886230468750000

data = fpga.snapshots.bitsnap4_ss.read(man_trig=True, man_valid=True)['data']
for key in data.keys():
    first = data[key][0]
    print '%s: %.20f' % (key, first)
    for d in data[key]:
        assert(first == d)
assert data['n83_47'][0] == -34359738367.12345504760742187500

data = fpga.registers.sreg.read()['data']
print data
assert data['reg'] == 4294967295

data = fpga.registers.sreg1.read()['data']
print data
assert data['reg'] == -2147483647.0

data = fpga.registers.sreg2.read()['data']
print data
assert data['reg'] == 4194303.123046875

data = fpga.registers.sreg3.read()['data']
print data
assert data['reg'] == -2097151.123046875

data = fpga.registers.sreg4.read()['data']
print data
assert data['sigfrac'] == -17.75
assert data['sig'] == 200
assert data['uns'] == 17
assert data['bol'] == 1

print 'All conversions from snap and register okay'

fpga.disconnect()