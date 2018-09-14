function ne_pl_modify_prt(session_path,prt_pattern,findfiles_options)
% ne_pl_modify_prt('H:\data1\MRI\Florian\20101229','*_sorted.prt','depth=1')

%% HELP: setting mod_struct
% onset and offset - original prt
% OnOffsets [x1 x2 x3 x4]: onset = onset + x1 | offset = offset - x2 | onset = offset - x3 | offset = onset + x4
% NOTE 1: x3 and x4 are exclusive, *** only one should be non-zero *** !!!
%
% NOTE 2: if condition names share a part of name, this might cause bugs, e.g. 'mem' and 'sac_mem'
% in this case, use  mod_struct(...).Name_start_index = ...; to search for certain place in prt condition names:
% e.g., for example above: mod_struct(2).Name_start_index = 1;
% 
% For changing color, assign all conditions separately, such as:
% mod_struct(1).Color = [255 255 255];

mod_struct(1).Name_start_index = []; % LEAVE THIS LINE INTACT


if nargin < 3,
	findfiles_options = [];
end


%% CHANGE mod_struct HERE, ADD mod_struct(...).Name_start_index for relevant conditions if needed

mod_struct(1).Name = 'cue';
mod_struct(1).OnOffsets = [0 0 0 500]; 

mod_struct(2).Name = 'mem';
mod_struct(2).OnOffsets = [1000 0 0 0]; 
mod_struct(2).Name_start_index = 1;

mod_struct(3).Name = 'sac';
mod_struct(3).OnOffsets = [0 0 0 2000]; 

%%
ne_xff_session(session_path,prt_pattern,findfiles_options,@ne_modify_prt,mod_struct);