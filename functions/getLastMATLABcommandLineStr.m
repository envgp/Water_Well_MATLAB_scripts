function str = getLastMATLABcommandLineStr()
% Function returns a string containing the last command entered in the Matlab Command Window..
% Code via : http://stackoverflow.com/questions/5053692/how-do-i-search-through-matlab-command-history
% Get session history from Java object:
history = ...
    com.mathworks.mlservices.MLCommandHistoryServices.getSessionHistory;
% Convert to a vector of char strings:
historyText = char(history);
% Convert to a cell vector of strings:
cvHistory = cellstr(historyText);
% Extract last string:
str = cvHistory{end};
end
