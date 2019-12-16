function [CASGEMdata, Nicelydata] = split_by_source(Data,varargin)
% [CASGEMdata, Nicelydata] = split_by_source(Data)
% Flags:
%   - 'silent' means nothing gets printed out.

% Takes a datastructure and returns two datastructures, corresponding to
% data from CASGEM and data from Nicely. Filters on 'datasource' attribute. This can invert
% 'merge_datastructures' on casgem+nicely data.

if length(varargin)>0
    if sum(strcmpi('silent',varargin))
        silent=true();
    end
else
    silent=false();
end



% Split by Wells
logicalcasgem = ismember(Data.WellData.datasource,['CASGEM']);
logicalnicely = ismember(Data.WellData.datasource,['Nicely']);

CASGEMdata = filter_logical_new(Data,'WellData',logicalcasgem,'literal','silent');
Nicelydata = filter_logical_new(Data,'WellData',logicalnicely,'literal','silent');

% Split by Measurements
CASGEMdata = filter_logical_new(CASGEMdata,'MeasurementData',ismember(CASGEMdata.MeasurementData.datasource,['CASGEM']),'literal','silent');
Nicelydata = filter_logical_new(Nicelydata,'MeasurementData',ismember(Nicelydata.MeasurementData.datasource,['Nicely']),'literal','silent');