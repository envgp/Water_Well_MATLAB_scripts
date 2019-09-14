function fig = plot_hydrograph(Data,well_id,varargin)
% plot_hydrograph(Data,well_id)
%
% Plots a hydrograph for a given well specified by it's well_id. well_id
% refers to site_code in OpenData Periodic Groundwater Measurements and the Water Data Library, but is CASGEM
% id in the CASGEM dataset. well_id should be a character vector of form
% (for example) '361089N1194293W001'. Depth to water is calculated using
% the correct 'Matt' method.
%
% Optional argument 'flagQC' plots in red any measurements which have a
% quality comment attached.
%
% A future version should contain a 'silent' option so that having the QC
% flag isn't always printed out.

if length(varargin)>0

    if strcmpi(varargin{1},'flagQC')
        fprintf('\tFlagQC flag detected.\n')
        flagqc=true();
    end
else
    flagqc=false();
end


% Check you have the right type of data as well_id    
if isa(well_id,'cell')
    fprintf('\tWARNING: well_id input is given as cell. It should be char. Try using curly braces, not curved brackets. Error likely to follow!')
end
    
Data_filt = filter_by_siteid(Data,well_id);
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

DATA = sortrows(DATA,1);
%DATA(any(isnan(DATA),2),:) = []; % Used to do this here; now I do it while
%plotting.
    
plot(DATA(~isnan(DATA(:,2)),1),DATA(~isnan(DATA(:,2)),2),'ko-','MarkerFaceColor','black','DisplayName','hydrograph','LineWidth',2); % This line plots only nonNan values. The reason to do this is else the plot is discontinuous.

if flagqc
    hold on
    flag=logical(DATA(:,3));
    plot(DATA(flag,1),DATA(flag,2),'ro','MarkerFaceColor','red','DisplayName','Quality Code');
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
