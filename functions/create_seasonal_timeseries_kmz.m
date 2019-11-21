
function create_seasonal_timeseries_kmz(Data,outname,startyear,endyear,varargin) 
% create_seasonal_timeseries_kmz(Data,outname,startyear,endyear,varargin)
% Takes a Data instance and creates hydrographs for every Well within that
% Data instance between startyear and endyear. It then packages these hydrographs with the lat/lon
% information and outputs a kmz containing georeferenced version of those
% hydrographs. The hydrographs have measurements with quality flags in red.
% A future option might turn this behaviour off.
%
% Data = structure containing well and measurement data.
% outname = the file stub XXXX so the output file will be called XXXX.kmz
% startyear = year to start plotting eg 2010
% endyear = year to end plotting eg 2019

% Check if we're in silent mode
fprintf('Running create_seasonal_timeseries_kmz.\n')
fprintf('\tForming seasonal timeseries between %i and %i.\n', startyear,endyear)
[seasonaltimeseries,seasons] = calc_seasonal_timeseries(Data,startyear,endyear,'silent','multisource'); % Calculate the time series.
seasonaltimeseries(:,3:3:end) = []; % The third column is 'difference'. We don't want that, so remove it.
seasons(:,3:3:end) = []; % ditto

%variablenames=cellstr(['Latitude','Longitude','Station_Id','Site_code','Well_depth','Well_Use']);


T1 = struct2table(Data.WellData);
T2 = array2table(seasonaltimeseries,'VariableNames',seasons);
T = [T1,T2];

ids=T{:,5};
names=T{:,1};
types=T{:,6};

description = cell(1,length(ids));
name = cell(1,length(ids));

mkdir hydrograph_images_tmp
fprintf('\nForming hydrographs.\n')
for i=1:length(ids)
    if i ==1
        fprintf('\t%i out of %i wells completed (printing progress every 20).\n', i, length(ids))
    elseif rem(i,20)==0
        fprintf('\t%i out of %i wells completed.\n', i, length(ids))
    end

    f = figure('visible','off');
    plot_hydrograph(Data,ids{i},'flagQC')
%    set(gcf, 'PaperUnits', 'inches');
%    set(gcf, 'PaperSize', [4 2]);
    xlim([datenum(sprintf('01/01/%i', startyear)) datenum(sprintf('12/31/%i', endyear))])
    datetick('x','mm/yyyy','keeplimits')
    %saveas(f,sprintf('hydrograph_images_tmp/hydrograph%i.png',i));
    f.PaperPosition = [0 0 6 3];
    f.PaperUnits='inches';
    print(sprintf('hydrograph_images_tmp/hydrograph%i.png',i),'-dpng','-r100');
    description{i} = sprintf('<img style="max-width:500px;" src="hydrograph_images_tmp/hydrograph%i.png"><br>Site code = %s<br>Type = %s<br>Lat= %.3f<br>Lon= %.3f<br>Well depth = %.0f feet',i,ids{i},types{i},T{i,3}, T{i,4},T{i,2});
    name{i} = sprintf('%.0f',names(i));
    close all
end

fprintf('Done.\n')

%%

% This saves the final kml.
fprintf('\tCreating kml file.\n')
kmlwrite('hydrographs_tmp.kml',T{:,3}, T{:,4}, 'Description',description, 'Name', name)

fprintf('\tConverting to kmz.\n')
GIS_kml2kmz('hydrographs_tmp.kml');

cmd=sprintf("mv 'hydrographs_tmp.kmz' %s.kmz", outname);
fprintf(cmd)
system(cmd,'-echo');

cmd="rm -r hydrograph_images_tmp";
system(cmd,'-echo');

cmd="rm *tmp*";
system(cmd,'-echo');

fprintf('\nDone.\n')
end