function create_wells_kmz(Data,outname)
% Exports a kmz containing well data for all the wells in Data. Outname is
% a string which is the outputfile it will be saved as.

description = cell(1,length(Data.WellData.stn_id));


for i = 1:length(Data.WellData.stn_id)
    fields = fieldnames(Data.WellData);
    B = strjoin(repmat("%s = %s <br>",1,length(fields)));
    words= strings(1,2*length(fields));
    words(1:2:length(words))= fields;
    for j = 1:length(fields)
        words(2*j) = Data.WellData.(fields{j})(i);
    end
    words(ismissing(words))=''; % Change NaNs to a blank space; this represents values we don't have.
    description{i} = sprintf(B,words);
end


fprintf('\tCreating kml file.\n')
kmlwrite(outname,Data.WellData.latitude, Data.WellData.longitude, 'Name', Data.WellData.nicely_site_code, 'Description',description)
end
