function sausage_1_with_delay = delay(delay_time, sausage_1)
for i = 1:(size(sausage_1,2)-delay_time)
    sausage_1_with_delay(i) = sausage_1(i+delay_time);
end
end