function create_hydrograph_kmz_modern(Data,outname,varargin)
% create_hydrograph_kmz(Data,outname)
% Creates a kmz containing wells and hydrographs for a data instance.
% Outname should be 'NAME.kml'. The output is placed in exports, in a
% folder called NAME. Takes a Data instance with Depth_To_Water in the
% measurement section, and expects data merged from Nicely and CASGEM.


if length(varargin)>0
    if strcmpi(varargin{1},'trendline')
        fprintf('\tTrendline flag detected.\n')
        trendline=true();
    end
else
    trendline=false();
end


%% Main code: don't edit this bit

oldfolder = cd;
cd ../exports;
stub = split(outname,'.');
stub = stub{1};
mkdir(stub);
cd(stub);

mkdir('hydrograph_images_tmp');


% First do wells with a site code.

logical_sitecode = ~cellfun(@isempty,Data.WellData.site_code);
logical_nicelycode_only = cellfun(@isempty,Data.WellData.site_code) & ~cellfun(@isempty,Data.WellData.nicely_site_code);

total_number_wells = sum(logical_sitecode) + sum(logical_nicelycode_only);

description = cell(1,total_number_wells);
name = cell(1,total_number_wells);
trend = zeros(1,total_number_wells);
means = zeros(1,total_number_wells);
lat = zeros(1,total_number_wells);
lon = zeros(1,total_number_wells);

fprintf('\tDoing CASGEM or combined wells.\n')

idxs_sitecodes =  find(logical_sitecode);

for i = 1:length(idxs_sitecodes)

    fields = fieldnames(Data.WellData);
    B = strjoin(repmat("%s = %s <br>",1,length(fields)));
    words= strings(1,2*length(fields));
    words(1:2:length(words))= fields;
    for j = 1:length(fields)
        words(2*j) = Data.WellData.(fields{j})(idxs_sitecodes(i));
    end
    words(ismissing(words))=''; % Change NaNs to a blank space; this represents values we don't have.
    description{i} = sprintf(B,words);
    
    
    f = figure('visible','off');
    if trendline
        [trendy,the_mean] = plot_hydrograph(Data,Data.WellData.site_code{idxs_sitecodes(i)},'multisource','silent','trendline_return','return_mean');
    else
        plot_hydrograph(Data,Data.WellData.site_code{idxs_sitecodes(i)},'silent');
    end
       
    
    
%    set(gcf, 'PaperUnits', 'inches');
%    set(gcf, 'PaperSize', [4 2]);
%    xlim([datenum(sprintf('01/01/%i', startyear)) datenum(sprintf('12/31/%i', endyear))])
%    datetick('x','mm/yyyy','keeplimits')
    %saveas(f,sprintf('hydrograph_images_tmp/hydrograph%i.png',i));
    f.PaperPosition = [0 0 6 3];
    f.PaperUnits='inches';
    set(gcf,'renderer','zbuffer');
    print(sprintf('hydrograph_images_tmp/hydrograph_%s.png',int2str(Data.WellData.stn_id(idxs_sitecodes(i)))),'-dpng','-r100');
    description{i} = strcat(sprintf('<img style="max-width:500px;" src="hydrograph_images_tmp/hydrograph_%s.png"><br>',int2str(Data.WellData.stn_id(idxs_sitecodes(i)))),description{i});
    if trendline
        trend(i) = -365*trendy;
        means(i) = the_mean;
    end
    
    name{i}=int2str(Data.WellData.stn_id(idxs_sitecodes(i)));
    lat(i)=Data.WellData.latitude(idxs_sitecodes(i));
    lon(i)=Data.WellData.longitude(idxs_sitecodes(i));

    delete(f);
    
    if i ==1
        fprintf('\t%i out of %i wells completed (printing progress every 20).\n', i, total_number_wells)
    elseif rem(i,20)==0
        fprintf('\t%i out of %i wells completed.\n', i, total_number_wells)
    end

end

fprintf('\tDoing Nicely only wells.\n')
idxs_sitecodes_nicelyonly =  find(logical_nicelycode_only);

for j = 1:length(idxs_sitecodes_nicelyonly)
    fields = fieldnames(Data.WellData);
    B = strjoin(repmat("%s = %s <br>",1,length(fields)));
    words= strings(1,2*length(fields));
    words(1:2:length(words))= fields;
    for k = 1:length(fields)
        words(2*k) = Data.WellData.(fields{k})(idxs_sitecodes_nicelyonly(j));
    end
    words(ismissing(words))=''; % Change NaNs to a blank space; this represents values we don't have.
    description{j + length(idxs_sitecodes)} = sprintf(B,words);
    
    
    f = figure('visible','off');
    [trendy,the_mean] = plot_hydrograph(Data,Data.WellData.nicely_site_code{idxs_sitecodes_nicelyonly(j)},'multisource','silent','trendline_return','return_mean');
    
    
%    set(gcf, 'PaperUnits', 'inches');
%    set(gcf, 'PaperSize', [4 2]);
%    xlim([datenum(sprintf('01/01/%i', startyear)) datenum(sprintf('12/31/%i', endyear))])
%    datetick('x','mm/yyyy','keeplimits')
    %saveas(f,sprintf('hydrograph_images_tmp/hydrograph%i.png',i));
    f.PaperPosition = [0 0 6 3];
    f.PaperUnits='inches';
    print(sprintf('hydrograph_images_tmp/hydrograph_%s.png',Data.WellData.nicely_site_code{idxs_sitecodes_nicelyonly(j)}),'-dpng','-r100');
    description{j  + length(idxs_sitecodes)} = strcat(sprintf('<img style="max-width:500px;" src="hydrograph_images_tmp/hydrograph_%s.png"><br>',Data.WellData.nicely_site_code{idxs_sitecodes_nicelyonly(j)}),description{j  + length(idxs_sitecodes)});
    
    name{j + length(idxs_sitecodes)}=Data.WellData.nicely_site_code{idxs_sitecodes_nicelyonly(j)};
    lat(j + length(idxs_sitecodes))=Data.WellData.latitude(idxs_sitecodes_nicelyonly(j));
    lon(j + length(idxs_sitecodes))=Data.WellData.longitude(idxs_sitecodes_nicelyonly(j));

    if trendline
        trend(j) = -365*trendy;
        means(j) = the_mean;
    end
    
    delete(f);
    
    if j ==1
        fprintf('\t%i out of %i wells completed (printing progress every 20).\n', j, total_number_wells)
    elseif rem(j,20)==0
        fprintf('\t%i out of %i wells completed.\n', j, total_number_wells)
    end

end
    



if trendline
    fprintf('Outputting a trendline file.')
    A = table(Data.WellData.longitude,Data.WellData.latitude,name',trend',means');
    writetable(A,'tabular_well_data.csv');
end

fprintf('\tCreating kml file.\n')
kmlwrite(outname,lat,lon,'Name',name, 'Description',description);
GIS_kml2kmz(outname);

fprintf('\tWriting info file.\n')
fid = fopen(strcat(outname,".info"),'wt');
fprintf(fid, Data.History);
fclose(fid);


cd(oldfolder);

end