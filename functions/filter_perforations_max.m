function Data_filt = filter_perforations_max(Data,maxperf)
% takes a structure Data and returns a structure corresponding to Data
% perforation at or shallower than maxperf.

    logical = Data.PerfData.bot_perf <= maxperf;

    Data_filt = filter_logical_new(Data,'PerfData',logical);

end