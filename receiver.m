function reverse_sausage = receiver (N_carrier, N_fft, T_guard, sausage_1, Constellation)
%3.1 Вырезаем из спектра полосы сигнала (разбиваем всю принятую колбасу на отдельные полосы, содержащие отдельные OFDM-символы вместе с защитными интервалами)
symbol_protect_2=[];
for i=1:size(sausage_1,2)/(N_fft+T_guard)
symbol_protect_2=[symbol_protect_2; sausage_1((i-1)*(N_fft+T_guard)+1:(N_fft+T_guard)*i)]; %Массив, содержащий отдельные OFDM-символы вместе с защитными интервалами
end
%3.3 Удаляем защитный интервал из принятых OFDM-символов
symbol = symbol_protect_2(:,T_guard+1:end); %Массив, содержащий OFDM-символы уже без защитных интервалов
%3.2 Находим спектры OFDM-символов
symbol_spectrum=fft(symbol, [],2); %Массив, содержащий спектры OFDM-символов
%3.1 Сейчас будем готовить спектры OFDM символов к отправке на демаппинг
reverse_sausage=[];
c = symbol_spectrum(:,2:N_carrier+1); %Массив, содержащий спектры OFDM-символов, но уже заполненный с первого элемента
for i=1:size(c,1)
    reverse_sausage=[reverse_sausage,c(i,:)]; %Обратная колбаса, только и ждущая, чтобы отправиться в демаппинг и донести информацию до получателя
end
end