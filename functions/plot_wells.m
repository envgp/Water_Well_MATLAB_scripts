function fig = plot_wells(Data,varargin)
% Plots the locations of wells for given Data instance. A basic plot often
% for a sanity check.
%
% Flag 'datasource' colours the output by datasource.

% Deal with varargin
if length(varargin)>0

    if sum(strcmpi('datasource',varargin))
        fprintf('\tdatasource flag detected.\n')
        datasource=true();
    else
    datasource=false();
    end
else
    datasource=false();
end

% Plot; do the case of datasource flag first.
if datasource
    figure()
    hold on
    sources = unique(Data.WellData.datasource);
    for i = 1:length(sources)
        X = Data.WellData.longitude(Data.WellData.datasource==sources(i));
        Y = Data.WellData.latitude(Data.WellData.datasource==sources(i));
        scatter(X,Y,'DisplayName',sources(i))
    end
    legend()
else   % Now the case without datasource flag.
    X = Data.WellData.longitude;
    Y = Data.WellData.latitude;
    fig = scatter(X,Y);
    set(gca,'fontsize',14)
end

end

    