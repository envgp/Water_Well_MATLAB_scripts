function NewData = merge_datastructures(S, T)
% NewData = merge_datastructures(struc1,struc2)
%
% Merges two data instances into a single structure. For instance, would be
% useful if you want to import CASGEM and Nicely data then hold both in a
% single structure.
cmd_called = getLastMATLABcommandLineStr();

fields = fieldnames(S);
for k = 1:numel(fields)
  aField     = fields{k}; % EDIT: changed to {}
  S.(aField) = cat(1, S.(aField), T.(aField));
end

wells = S.WellData;
fields = fieldnames(wells);
for i_field = 1:length(fields)
    field = fields{i_field};
    welldat.(field) = cat(1,wells(:).(field));
end

msmts = S.MeasurementData;
fields = fieldnames(msmts);
for i_field = 1:length(fields)
    field = fields{i_field};
    measdat.(field) = cat(1,msmts(:).(field));
end

perfs = S.PerfData;
fields = fieldnames(perfs);
for i_field = 1:length(fields)
    field = fields{i_field};
    perfdat.(field) = cat(1,perfs(:).(field));
end

NewData.WellData = welldat;
NewData.MeasurementData = measdat;
NewData.PerfData = perfdat;

NewData.History = "Merger between two datasets, merge command was " + cmd_called;

end