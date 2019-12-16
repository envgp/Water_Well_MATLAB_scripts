function Data_filt = filter_logical_new(Data,filterby,logical,varargin)
% Data_filt = filter_logical_new(Data,filterby,logical,Flags)
% Flags: 
%   - 'literal' means we only filter by the filterby column, even if that
%   leaves measurements without wells, wells without measurements, etc. 
%   - 'silent' means nothing gets printed out.
%
% Returns a new Data structure when given an existing data structure, a subfield
% by which to filter (WellData, MeasurementData or PerfData) and a logical
% corresponding to that subfield. The logical has to be the same length as
% that subfield. This function supercedes filter_logical. One difference in behaviour is that, no matter which
% subfield the logical applies to, other data is removed (eg after applying logical filter to measurements, we 
% run remove_wells_wo_measurements to remove wells which no longer have corresponding measurements). 
% To turn this behaviour off, add the flag 'literal'.

% Deal with possible flags.
if length(varargin)>0
    if sum(strcmpi('silent',varargin))
        silent=true();
    else
        silent=false();
    end

    if sum(strcmpi('literal',varargin))
        if ~ silent
            fprintf('Literal mode; may give unusual results!\n')
        end
        literal=true();
    else
        literal=false();
    end
    
else
    silent=false();
    literal=false();
end


if strcmp(filterby,'WellData')
    fields = fieldnames(Data.WellData);
    Data_filt = Data;
    for i=1:length(fields)
        Data_filt.WellData.(fields{i}) = Data.WellData.(fields{i})(logical);
    end
    
    if ~ literal
        Data_filt = remove_measurements_wo_wells(Data_filt);
        Data_filt = remove_perforations_wo_wells(Data_filt);
    end
end

if strcmp(filterby,'MeasurementData') 
    fields = fieldnames(Data.MeasurementData);
    Data_filt = Data;

    for i=1:length(fields)
        Data_filt.MeasurementData.(fields{i}) = Data.MeasurementData.(fields{i})(logical);
    end
    
    if ~ literal
        Data_filt = remove_wells_wo_measurements(Data_filt);
        Data_filt = remove_perforations_wo_wells(Data_filt);
    end
end

if strcmp(filterby,'PerfData')
    fields = fieldnames(Data.PerfData);
    Data_filt = Data;

    for i=1:length(fields)
        Data_filt.PerfData.(fields{i}) = Data.PerfData.(fields{i})(logical);
    end
    
    if ~ literal
        Data_filt = remove_wells_wo_perforations(Data_filt);
        Data_filt = remove_measurements_wo_wells(Data_filt);
    end
end

if length(fieldnames(Data)) > 3
    fprintf('\tWARNING: New field(s) detected in %s.  filter_logical_new has deleted this field.\n', inputname(1))
end
