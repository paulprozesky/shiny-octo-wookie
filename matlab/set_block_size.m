function get_block_size()

try
    exist(block_size_x ,'var');
    exist(block_size_y ,'var');
catch
    error('block_size_x and block_size_y must exist before you call this function! Did you get_block_size?')
end
block_names = find_system(gcs, 'LookUnderMasks', 'all', 'SearchDepth', 1, 'Type', 'Block', 'Selected', 'on');
for ctr = 1 : length(block_names),
    blkname = block_names{ctr};
    if strcmp(blkname, gcs) == 0,
        blkpos = get_param(blkname, 'Position'); set_param(blkname, 'Position', sprintf('[%i %i %i %i]', blkpos(1), blkpos(2), blkpos(1) + size_x, blkpos(2) + size_y));
    end
end

end
% end
