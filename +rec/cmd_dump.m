% CMD_DUMP - Dump value and name
% 
% Usage:
%    cmd_dump(name, v)
%
% Arguments:
%    name - string to dump
%    v - value to dump
%
function cmd_dump(name, v)
    fprintf('%s = [', name);
    fprintf(' %.4f', v);
    fprintf(']\n');
end
