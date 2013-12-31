regblks = find_system(gcs, 'FollowLinks', 'on', 'Tag', 'xps:sw_reg');

for b = 1 : numel(regblks),
    blk = regblks{b};
    
    blkname = get_param(blk, 'Name');
    oldblk = [blk, '_old'];

    % rename the old block
    set_param(blk, 'Name', [blkname, '_old']);
    oldpos = get_param(oldblk, 'Position');
    
    % make the new block
    reuse_block(gcs, blkname, 'xps_library/software register', 'Position', [oldpos(1)+10,oldpos(2)+10,oldpos(3)+10,oldpos(4)+10], ...
        'numios', '1', ...
        'io_dir', get_param(oldblk, 'io_dir'), ...
        'io_delay', get_param(oldblk, 'latency'), ...
        'sample_period', get_param(oldblk, 'sample_period'), ...
        'name1', 'reg', ...
        'bitwidth1', get_param(oldblk, 'bitwidth'), ...
        'arith_type1', get_param(oldblk, 'arith_type'), ...
        'bin_pt1', get_param(oldblk, 'bin_pt'));

%     src and dest of old block
%     p = get_param(oldblk, 'PortConnectivity');
%     from_block_handle = p(1).SrcBlock;
%     from_block = [get_param(from_block_handle, 'Parent'), '/', get_param(from_block_handle, 'Name')];
%     dest_block_handle = p(2).DstBlock;
%     dest_block = [get_param(dest_block_handle, 'Parent'), '/', get_param(dest_block_handle, 'Name')];
% 
%     connect the new block
%     add_line(gcs, [from_block, '/1');
%     
%     
%     disconnect the old block
%     
%     move the old block
%     
%     delete the old block
end