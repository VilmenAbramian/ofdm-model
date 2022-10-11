function sausage_1_with_shift = Frequency_shift(N_fft, sausage_1, freq_shift)
%Воспользуемся результатами лабораторгных работ Тормагова Тимофея по ЦОС
for i = 1:size(sausage_1(1,:),2)
    sausage_1_with_shift(1, i) = sausage_1(1,i).*exp((1j*2*pi*freq_shift*i)/N_fft); %Свойство преобразование Фурье. Теорема запаздывания (или смещения)
end
end