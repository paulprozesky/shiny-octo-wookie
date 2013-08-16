blks = find_system(gcs, 'FollowLinks', 'on', 'LookUnderMasks', 'all', 'RegExp', 'on', 'Tag', 'xps:*|casper:*');
handles = zeros(1,numel(blks));
for b = 1 : numel(blks),
    handles(b) = cell2mat(get_param(blks(b),'Handle'));
end
for h = 1 : numel(handles),
    for hh = 1 : numel(handles),
        if hh ~= h,
            if handles(hh) == handles(h),
                error('handle clash');
            end
        end
    end
end