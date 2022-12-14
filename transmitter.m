function sausage = transmitter (IQ_points, N_carrier, N_fft, T_guard)
%3.1
amount_symbols = size(IQ_points,2)/N_carrier; %Количество OFDM символов. Зависит от передаваемых точек и количества поднесущих (количество точек/количество поднесущих)
symbol_spectrum=zeros(amount_symbols,N_carrier+1); %Инициализируем массив, в который будем записывать точки созвездия для формирования OFDM-символов, заполняя его нолями, чтобы при каждой итерации цикла не изменялся размер массива

for i = 1:amount_symbols %Цикл, отвечающий за распределение точек созвездия по OFDM-символам в соответствии с их количеством
    symbol_spectrum(i,2:N_carrier+1)=IQ_points((i-1)*N_carrier+1:(N_carrier)*i); %Массив, содержащий все OFDM-символы. По сути выход маппинга - это спектр квадратурно-модулированного сигнала. Поэтому здесь, разделив выход маппинга, мы имеем спектры OFDM-символов
end
%3.2
symbol=ifft(symbol_spectrum,N_fft,2); %Обратное преобразование Фурье. Получили сами OFDM-символы (OFDM-символы во временной области)
%3.3 Прорезаем задание 3.2 заданием 3.3
symbol_protect=zeros(amount_symbols, N_fft+T_guard); %Инициализируем двумерный массив. В строках: номера OFDM-символов (bkb , в столбиках: сами OFDM-символы увеличенного размера (длительность преобразования Фурье N_fft + защитный интервал T_guard
for i=1:size(symbol,1)
    symbol_protect(i,:)=[symbol(i,end-T_guard+1:end), symbol(i,:)]; %Новый двумерный массив, содержащий OFDM-символы с защитными интервалами, в строках которого находятся сами символы, а в столбцах их номера (сначала берём концовку одного символа, потом присовокупляем к ней сам символ
end
%3.2 Возвращаемся ко второй части задания 3.2
sausage = [];
for i=1:size(symbol_protect,1) %Цикл, сшивающий все OFDM-символы с защитными интервлами в одну длинную колбасу
    sausage=[sausage, symbol_protect(i,:)]; %OFDM-frame (OFDM-кадр). Каждый раз добавляем к колбасе всё новый и новый OFDM-символ
end
%1152
%ЧТо происходит с созвездиями?
%plot(abs(fft(symbol(1,:))));
%plot(abs(fft(symbol_protect(1,:),N_fft+T_guard)));
%Длина защитного интервала составляет 128 значений
%plot(abs(fft(symbol_protect(1,1:1024)))); 
%scatterplot(fft(symbol_protect(1,1:1024)));%Принимает комплесные значения, а строит созвездие
%plot(abs(fft(symbol_protect(1,1:1024),N_fft))); %Весь защитный интервал
%plot(abs(fft(symbol_protect(1,1:950),N_fft))); %Более защитного интервала
end