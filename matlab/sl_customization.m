% More information about this process can be found here:
% http://www.mathworks.com/help/simulink/ug/adding-items-to-model-editor-menus.html

function sl_customization(cm)
  %% Register custom menu function.
  cm.addCustomMenuFcn('Simulink:PreContextMenu', @getMyMenuItems);
end

%% Define the custom menu function.
function schemaFcns = getMyMenuItems(~) 
	schemaFcns = {@userFunctions}; 
end

%% Define the schema function for first menu item.
function schema = userFunctions(~)
	% Make a submenu label    
	schema = sl_container_schema;
	schema.label = 'CASPER helpers';     
	schema.childrenFcns = {@userGetBlockSize, @userSetBlockSize, @userGotoPlusPlus, @userDannyFunc, @userGoto2From};
end

function schema = userGetBlockSize(~)
    schema = sl_action_schema;
	schema.label = 'Get block size';
	schema.callback = @casper_sl_get_block_size; 
end

function schema = userSetBlockSize(~)
	schema = sl_action_schema;
	schema.label = 'Set block sizes';
	schema.callback = @casper_sl_set_block_size; 
end

function schema = userGotoPlusPlus(~)
	schema = sl_action_schema;
	schema.label = 'Increment goto/from tags';
    schema.userdata = [-1, -1];
	schema.callback = @casper_sl_incr_tag;
end

function schema = userDannyFunc(~)
	schema = sl_action_schema;
	schema.label = 'Goto -> Goto++';
	schema.callback = @casper_sl_goto_plusplus; 
end

function schema = userGoto2From(~)
	schema = sl_action_schema;
	schema.label = 'Goto -> From';
	schema.callback = @casper_sl_goto2from; 
end

% if you'd like to add more user functions duplicate 'userFunction1'
% structure.