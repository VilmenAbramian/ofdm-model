function sausage_1_with_multipath = multipath(channel, sausage_1)
sausage_1_with_multipath = zeros(1, size(sausage_1, 2));
for i=1:size(channel, 1) %Количество лучей
    time_rumpled = channel(i, 1); %Помятое время для конкретного луча
    amplitude_rumpled = channel(i, 2); %Помятая амплитуда для конкретного луча
    
    mashed_sausage = amplitude_rumpled*circshift(sausage_1, -time_rumpled); %Циклически сдвигаем символ (на значение временного сдвига) (при этом не зануляя необходимую часть символа) и умножаем на амплитудный коэффициент
    mashed_sausage(1, (size(sausage_1, 2) - time_rumpled + 1):size(sausage_1, 2)) = 0; %Зануляем сдвинутые отсчёты. Теперь получаем полностью помятый луч (один из 3х в нашем исходном случае) OFDM-символа
    sausage_1_with_multipath = sausage_1_with_multipath + mashed_sausage; %Складываем лучи. 3 в 1   
end
end