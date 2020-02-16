function fig = plot_hydrograph(Data,well_id,varargin)
% fig = plot_hydrograph(Data,well_id)
%
% Plots a hydrograph for a given well specified by it's well_id. well_id
% can be a CASGEM id or a Tim Nicely id. CASGEM id refers to site_code in OpenData Periodic Groundwater Measurements and the Water Data Library, but is CASGEM
% id in the CASGEM dataset, so should be a character vector of form
% (for example) '361089N1194293W001'. Depth to water is calculated using
% the correct 'Matt' method.
%
% OPTIONAL ARGUMENTS
% Optional argument 'flagQC' plots in red any measurements which have a
% quality comment attached. Argument 'multisource' plots casgem and nicely
% data in different colours. Argument 'trendline' plots a trendline if
% there are >2 measurements.
%
% A future version should contain a 'silent' option so that having the QC
% flag isn't always printed out.

if length(varargin)>0

    if sum(strcmpi('flagQC',varargin))
        fprintf('\tFlagQC flag detected.\n')
        flagqc=true();
    else
    flagqc=false();
    end
    
    if sum(strcmpi('multisource',varargin))
        %fprintf('Multisource mode!\n')
        multisource=true();
    else
        multisource=false();
    end
    
    if sum(strcmpi('trendline',varargin))
        %fprintf('Multisource mode!\n')
        trendline=true();
    else
        trendline=false();
    end

else
    flagqc=false();
    multisource=false();
    trendline=false()

end


% Check you have the right type of data as well_id    
if isa(well_id,'cell')
    fprintf('\tWARNING: well_id input is given as cell. It should be char. Try using curly braces, not curved brackets. Error likely to follow!')
end

% Check whether the given well_id is a CASGEM or Nicely ID.
if length(well_id) == 18
    casgem=true();
    nicely=false();
elseif contains(well_id,'KSB')
    casgem=false();
    nicely=true();
else
    fprintf("\WARNING: could not tell if the well_id is from CASGEM or Nicely. It's highly unlikely this will work.")
end

if casgem
    Data_filt = filter_by_siteid(Data,well_id);
elseif nicely
    Data_filt = filter_by_nicely_site_code(Data,well_id);
end

    %     [LIA, LOCB] = ismember(Data.MeasurementData.site_code(:),well_id);
% 
%     Data_filt = filter_logical(Data,true([length(Data.WellData.stn_id(:)) 1]), LIA);
% 
%     Data_filt = remove_wells_wo_measurements(Data_filt);

if flagqc
    for i = 1:length(Data_filt.MeasurementData.date(:))
        flag(i)= ~isempty(Data_filt.MeasurementData.quality_comment{i});
    end
end


DATA = [datenum(Data_filt.MeasurementData.date(:)), calc_water_levels(Data_filt,0)];
if flagqc
    DATA = [datenum(Data_filt.MeasurementData.date(:)), calc_water_levels(Data_filt,0), flag'];
end

if multisource
    DATA = [datenum(Data_filt.MeasurementData.date(:)), calc_water_levels(Data_filt,0), Data_filt.MeasurementData.datasource=="CASGEM"];
end

if trendline
    if length(DATA(~isnan(DATA(:,2)),1)) >=3
        trend_params = polyfit(DATA(~isnan(DATA(:,2)),1),DATA(~isnan(DATA(:,2)),2),1);
    end
end

DATA = sortrows(DATA,1);
%DATA(any(isnan(DATA),2),:) = []; % Used to do this here; now I do it while
%plotting.



% BELOW HERE WE ARE PLOTTING!

if ~multisource % We plot the line separately for the multisource case.
    hold on
    plot(DATA(~isnan(DATA(:,2)),1),DATA(~isnan(DATA(:,2)),2),'ko-','MarkerFaceColor','black','DisplayName','hydrograph','LineWidth',2); % This line plots only nonNan values. The reason to do this is else the plot is discontinuous.
    if trendline
        plot(DATA(~isnan(DATA(:,2)),1),trend_params(1)*DATA(~isnan(DATA(:,2)),1) + trend_params(2),'r--','DisplayName','trendline')
    end
end

if flagqc
    hold on
    flag=logical(DATA(:,3));
    plot(DATA(flag,1),DATA(flag,2),'ro','MarkerFaceColor','red','DisplayName','Quality Code');
    if trendline
        plot(DATA(~isnan(DATA(:,2)),1),trend_params(1)*DATA(~isnan(DATA(:,2)),1) + trend_params(2),'r--','DisplayName','trendline')
    end

end

if multisource
    flag=logical(DATA(:,3));
    plot(DATA(~isnan(DATA(:,2)),1),DATA(~isnan(DATA(:,2)),2),'-','LineWidth',2); % Plot a line (no markers yet).
    hold on
    plot(DATA(flag,1),DATA(flag,2),'ro','MarkerFaceColor','blue','DisplayName','CASGEM data');
    plot(DATA(~flag,1),DATA(~flag,2),'ro','MarkerFaceColor','green','DisplayName','Nicely data');
    if trendline
        plot(DATA(~isnan(DATA(:,2)),1),trend_params(1)*DATA(~isnan(DATA(:,2)),1) + trend_params(2),'r--','DisplayName','trendline')
    end

end


set(gca,'ydir','reverse')
xlabel('Date')
ylabel('Depth to water (feet)')
title(sprintf('Hydrograph for well id %s', well_id))
datetick('x','mm/yyyy')



%     hold on
%     depth = get_welldepth_siteid(Data,well_id);
%     plot([min(DATA(:,1)) max(DATA(:,1))],[depth depth],'--','DisplayName','Reported well depth')

legend()

end
