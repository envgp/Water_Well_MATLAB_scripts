function list_functions()
% lists functions available in the current version of well_data_MATLAB.
fprintf("LISTING FUNCTIONS IN CURRENT VERSION OF well_data_MATLAB:\n");
p = path;
P = split(path,':');
A = strfind(P,'functions');
idx_of_functions = find(~cellfun(@isempty,A)); 
directory = P(idx_of_functions);

a = ls(char(strcat(directory,'/*.m')));
b = splitlines(a);
for i = 1:length(b)
    tmp = split(b(i),'/');
    disp(tmp{end})
end
end