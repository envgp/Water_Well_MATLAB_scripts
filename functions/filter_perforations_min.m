function Data_filt = filter_perforations_min(Data,minperf)
% takes a structure Data and returns a structure corresponding to Data with
% perforations only deeper than maxperf.

    logical = Data.PerfData.top_perf >= minperf;

    Data_filt = filter_logical_new(Data,'PerfData',logical);

end