function return_info(Data)
% Prints out basic information about a datastructure.

nowells = length(Data.WellData.stn_id);
nomsmts = length(Data.MeasurementData.date);
history = Data.History;

fprintf("\tnumber of wells = "+nowells+"."+newline+"\tnumber of measurements = "+nomsmts+"."+newline+"History printed below:"+newline+Data.History+newline)