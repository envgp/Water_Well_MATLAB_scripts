function fig = plot_wells(Data)
% Plots the locations of wells for given data. Currently a basic plot just
% for a sanity check.
    X = Data.WellData.longitude;
    Y = Data.WellData.latitude;
    fig = scatter(X,Y);
    set(gca,'fontsize',14)
end

    