function gototagnumber(changethis, tothis)

block_names = find_system('Regexp', 'on', 'BlockType', 'Goto|From', 'Selected', 'on', 'GotoTag', [changethis, '$']);
if isempty(block_names),
    error('No suitable selected goto/from blocks.');
end
for ctr = 1:length(block_names)
    currenttag = get_param(block_names{ctr}, 'GotoTag');
    newtag = regexprep(currenttag, [changethis, '$'], tothis);
    set_param(block_names{ctr}, 'GotoTag', newtag);
end

end
% end
