function fig = hist_month(Data)
% Plots a histogram showing density of measurement by month.

    months = month(Data.MeasurementData.date);

    histogram(months);
    set(gca,'xtick',1:12,'xticklabel',{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'})
    title('Histogram of measurements by month')
end