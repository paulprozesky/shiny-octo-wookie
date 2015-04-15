
function pfb_core_snb64_config(this_block)

  % Revision History:
  %
  %   24-Mar-2015  (15:35 hours):
  %     Original code was machine generated by Xilinx's System Generator after parsing
  %     /home/paulp/projects/code/shiny-octo-wookie/mkat/pfb_bb/pfb_core_snb64.vhd
  %
  %

  this_block.setTopLevelLanguage('VHDL');

  this_block.setEntityName('pfb_core_snb64');

  % System Generator has to assume that your entity  has a combinational feed through; 
  %   if it  doesn't, then comment out the following line:
%   this_block.tagAsCombinational;

  this_block.addSimulinkInport('sync_in');
  this_block.addSimulinkInport('en_in');
  this_block.addSimulinkInport('pol0_in');
  this_block.addSimulinkInport('pol1_in');
  this_block.addSimulinkInport('shift_in');

  this_block.addSimulinkOutport('sync_out');
  this_block.addSimulinkOutport('en_out');
  this_block.addSimulinkOutport('pol0_out');
  this_block.addSimulinkOutport('pol1_out');
  this_block.addSimulinkOutport('of_out');

  en_out_port = this_block.port('en_out');
  en_out_port.setType('Bool');
  en_out_port.useHDLVector(false);
  of_out_port = this_block.port('of_out');
  of_out_port.setType('Bool');
  of_out_port.useHDLVector(false);
  pol0_out_port = this_block.port('pol0_out');
  pol0_out_port.setType('UFix_36_0');
  pol1_out_port = this_block.port('pol1_out');
  pol1_out_port.setType('UFix_36_0');
  sync_out_port = this_block.port('sync_out');
  sync_out_port.setType('Bool');
  sync_out_port.useHDLVector(false);

  % -----------------------------
  if (this_block.inputTypesKnown)
    % do input type checking, dynamic output type and generic setup in this code block.

    if (this_block.port('en_in').width ~= 1);
      this_block.setError('Input data type for port "en_in" must have width=1.');
    end

    this_block.port('en_in').useHDLVector(false);

    if (this_block.port('pol0_in').width ~= 36);
      this_block.setError('Input data type for port "pol0_in" must have width=36.');
    end

    if (this_block.port('pol1_in').width ~= 36);
      this_block.setError('Input data type for port "pol1_in" must have width=36.');
    end

    if (this_block.port('shift_in').width ~= 32);
      this_block.setError('Input data type for port "shift_in" must have width=32.');
    end

    if (this_block.port('sync_in').width ~= 1);
      this_block.setError('Input data type for port "sync_in" must have width=1.');
    end

    this_block.port('sync_in').useHDLVector(false);

  end  % if(inputTypesKnown)
  % -----------------------------

  % -----------------------------
   if (this_block.inputRatesKnown)
     setup_as_single_rate(this_block,'clk_1','ce_1')
   end  % if(inputRatesKnown)
  % -----------------------------

    % (!) Set the inout port rate to be the same as the first input 
    %     rate. Change the following code if this is untrue.
    uniqueInputRates = unique(this_block.getInputRates);


  % Add addtional source files as needed.
  %  |-------------
  %  | Add files in the order in which they should be compiled.
  %  | If two files "a.vhd" and "b.vhd" contain the entities
  %  | entity_a and entity_b, and entity_a contains a
  %  | component of type entity_b, the correct sequence of
  %  | addFile() calls would be:
  %  |    this_block.addFile('b.vhd');
  %  |    this_block.addFile('a.vhd');
  %  |-------------

  %    this_block.addFile('');
  %    this_block.addFile('');
  this_block.addFile('pfb_core_snb64.vhd');

return;


% ------------------------------------------------------------

function setup_as_single_rate(block,clkname,cename) 
  inputRates = block.inputRates; 
  uniqueInputRates = unique(inputRates); 
  if (length(uniqueInputRates)==1 & uniqueInputRates(1)==Inf) 
    block.addError('The inputs to this block cannot all be constant.'); 
    return; 
  end 
  if (uniqueInputRates(end) == Inf) 
     hasConstantInput = true; 
     uniqueInputRates = uniqueInputRates(1:end-1); 
  end 
  if (length(uniqueInputRates) ~= 1) 
    block.addError('The inputs to this block must run at a single rate.'); 
    return; 
  end 
  theInputRate = uniqueInputRates(1); 
  for i = 1:block.numSimulinkOutports 
     block.outport(i).setRate(theInputRate); 
  end 
  block.addClkCEPair(clkname,cename,theInputRate); 
  return; 

% ------------------------------------------------------------

