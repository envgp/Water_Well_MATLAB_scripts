function create_hydrograph_kmz(Data,outname)
% create_hydrograph_kmz(Data,outname)
% Creates a kmz containing wells and hydrographs for a data instance.
% Outname should be 'NAME.kml'. This all operates in the current working
% directory...can make it move stuff to exports if you like.


%% Main code: don't edit this bit

oldfolder = cd;
cd ../exports;
stub = split(outname,'.');
stub = stub{1};
mkdir(stub)
cd(stub)

mkdir('hydrograph_images_tmp')

description = cell(1,length(Data.WellData.stn_id));

for i = 1:length(Data.WellData.stn_id)
    if i ==1
        fprintf('\t%i out of %i wells completed (printing progress every 20).\n', i, length(Data.WellData.stn_id))
    elseif rem(i,20)==0
        fprintf('\t%i out of %i wells completed.\n', i, length(Data.WellData.stn_id))
    end

    fields = fieldnames(Data.WellData);
    B = strjoin(repmat("%s = %s <br>",1,length(fields)));
    words= strings(1,2*length(fields));
    words(1:2:length(words))= fields;
    for j = 1:length(fields)
        words(2*j) = Data.WellData.(fields{j})(i);
    end
    words(ismissing(words))=''; % Change NaNs to a blank space; this represents values we don't have.
    description{i} = sprintf(B,words);
    
    
    f = figure('visible','off');
    if Data.WellData.datasource{i}=="CASGEM"
        plot_hydrograph(Data,Data.WellData.site_code{i},'multisource','silent')
    elseif Data.WellData.datasource{i}=="Nicely"
        plot_hydrograph(Data,Data.WellData.nicely_site_code{i},'multisource','silent')
    end
    
%    set(gcf, 'PaperUnits', 'inches');
%    set(gcf, 'PaperSize', [4 2]);
%    xlim([datenum(sprintf('01/01/%i', startyear)) datenum(sprintf('12/31/%i', endyear))])
%    datetick('x','mm/yyyy','keeplimits')
    %saveas(f,sprintf('hydrograph_images_tmp/hydrograph%i.png',i));
    f.PaperPosition = [0 0 6 3];
    f.PaperUnits='inches';
    print(sprintf('hydrograph_images_tmp/hydrograph%i.png',i),'-dpng','-r100');
    description{i} = strcat(sprintf('<img style="max-width:500px;" src="hydrograph_images_tmp/hydrograph%i.png"><br>',i),description{i});
end


fprintf('\tCreating kml file.\n')
kmlwrite(outname,Data.WellData.latitude, Data.WellData.longitude, 'Description',description);

GIS_kml2kmz(outname);

cd(oldfolder);

end
