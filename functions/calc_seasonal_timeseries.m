function [seasonaltimeseries,labels] = calc_seasonal_timeseries(Data,startyear,endyear,varargin)
% [DataTable] = calc_seasonal_timeseries(Data,startyear,endyear,varargin) takes a
% Data instance and returns table with colums containing Well Info then
% depth to water for spring and fall for each year in the range startyear
% -> endyear. For definitions of spring and fall, see the function
% 'temporal_filter_season' . 
%
% vargin: if 'silent' is passed as an argument it won't print anything out.

% Check if we're in silent mode.
if length(varargin)>0

    if strcmpi(varargin{1},'silent')
        fprintf('Silent mode!\n')
        silent=true();
    end
else
    silent=false();
end

years = startyear:endyear;

seasonaltimeseries = zeros(length(Data.WellData.stn_id(:)),3*length(years));

for i = 1:length(years)
    labels(3*i -2) = sprintf("Spring%i", years(i));
    Datatemp= temporal_filter_season(temporal_filter_year(Data,years(i)),'spring');
    
    if silent==false()
        [~,~,waterlevels,stnid,sitecode] = calc_water_levels_woduplicates(Datatemp,'average');
    else
        [~,~,waterlevels,stnid,sitecode] = calc_water_levels_woduplicates(Datatemp,'average','silent');
    end
        
    for j = 1:length(waterlevels)
        indx = ismember(Data.WellData.stn_id(:),stnid(j));
        seasonaltimeseries(indx,3*i-2) = waterlevels(j);
    end
    
    labels(3*i -1) = sprintf("Fall%i", years(i));
    Datatemp= temporal_filter_season(temporal_filter_year(Data,years(i)),'fall');
    if silent==false()
        [~,~,waterlevels,stnid,sitecode] = calc_water_levels_woduplicates(Datatemp,'average');
    else
        [~,~,waterlevels,stnid,sitecode] = calc_water_levels_woduplicates(Datatemp,'average','silent');
    end
    for j = 1:length(waterlevels)
        indx = ismember(Data.WellData.stn_id(:),stnid(j));
        seasonaltimeseries(indx,3*i -1 ) = waterlevels(j);
    end
    
    labels(3*i) = sprintf('Difference_%i', years(i));
    seasonaltimeseries(:,3*i) = seasonaltimeseries(:,3*i - 2) - seasonaltimeseries(:,3*i - 1);
end