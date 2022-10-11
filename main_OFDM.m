%ы
clear all;
clc;
%% Конфигурация
Constellation = '16-QAM'; % 'BPSK' 'QPSK' '16-QAM'
switch Constellation
    case 'BPSK'
        N_constellation = 1; %Одна точка определена одним битом
    case 'QPSK'
        N_constellation = 2; %Одна точка определена двумя битами
    case '16-QAM'
        N_constellation = 4; %Одна точка определена четырьмя битами
end
N_OFDM_symbols = 10; %Количество OFDM-символов
N_carrier = 400; %Количество поднесущих частотных каналов в OFDM
N_IQpoints = N_carrier*N_OFDM_symbols; %Количество точек в созвездии
N_fft = 1024; %Длительность преобразования Фурье
T_guard = N_fft/8; %Длительность защитного интервала

%Добавили в 4
Register = [1, 0, 0, 1, 0 , 1 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0]; %Задаём 
PAPR0 = 0:20; %Создаём массив, содержащий различные значения отношения пиковой мощности к средней

%Добавили в 5
SNR = 30; %SNR в дБ. До преобразования
delay_time = randi([0, N_fft+T_guard],1); %Случайная временная задержка (в диапазоне от 0 до N_fft+T_guard)
freq_shift = 25.5; %Частотная рассинхронизация. Внимание! Меняем в диапазоне действительных чисел от -30 до 30
channel = [0, 1; 4, 0.6; 10, 0.3]; %Массив содержит параметры покорёженных отражений сигнала (каждая строчка содержит два параметра: задержка луча, заданная во временных отсчётах м(ожет принимать от 0 до T_guard/2) и амплитуда пришедшего луча (задаётся в диапазоне [0;1])

%% Передатчик
% Import data
%InputBits = randi([0,1], 1, N_constellation*N_IQpoints); %Генерируем передаваемые биты случайным образом (отключено, т. к. в 4 мы передаём войну и мир)
fileID = fopen('War_and_Peace.doc'); %Считываем все биты, кодирующие Войну и мир в wordовском формате
InputBits = fread(fileID, N_constellation*N_IQpoints,'*ubit1')'; %И готовим эти биты к отправке

InputBits_psd = randomizer(InputBits,Register); %Делаем рандомизацию с битами из считанного файла, получаем псевдорандомизированные передаваемые биты
%Внимание! Для 5 отключается часть функционала 4!
% Mapper
%Дважды используем маппинг. Один раз отправляем уже закодированные
%псевдослучайной последовательностью точки, а другой - нет
IQ_points_1 = mapping(Constellation, InputBits_psd); %Маппинг для точек с рандомизацией
%IQ_points_2 = mapping(Constellation, InputBits); %Маппинг для точек без рандомизации

%Дважды передаём биты
sausage_1 = transmitter(IQ_points_1, N_carrier, N_fft, T_guard); %Рандомизированные
%sausage_2 = transmitter(IQ_points_2, N_carrier, N_fft, T_guard); %Нерандомизированные

CCDF_rand_bits = CCDF(IQ_points_1, N_OFDM_symbols, N_carrier, N_fft, PAPR0); %Считаем CCDF для рандомизированных точек
%CCDF_corr_bits = CCDF(IQ_points_2, N_OFDM_symbols, N_carrier, N_fft, PAPR0); %Считаем CCDF для нерандомизированных точек

%Строим графики для сравнения. Для 5 отключается за ненадобностью
%plot(PAPR0, CCDF_rand_bits, PAPR0, CCDF_corr_bits, 'LineWidth',1);
%title('CCDF');
%ylabel('CCDF');
%xlabel('PAPR0');
%legend('Randomized bits', 'Correlated bits');
%grid on;
%% Канал
% В 5 меж передатчиком и приёмником появляется канал, добавляющий различные помехи
%sausage_1 - это сосиндрович, имеющий все OFDM-символы, склеенные между собой

% Добавим к переданному сигналу белый гауссовский шум
sausage_1 = my_awgn(SNR,sausage_1);
%Добавим к сигналу с белым гауссовским шумом временную задержку
%sausage_1 = delay(delay_time, sausage_1);
%Добавим к сигналу с белым гауссовым шумом и временным смещением ещё и частотное смещение
%sausage_1 = Frequency_shift(N_fft, sausage_1, freq_shift);
%Добавим к сигналу с белым гауссовым шумом, частотным и временным рассинхроном эффект от многолучевого распространения
%sausage_1 = multipath(channel, sausage_1);
%figure(1);
%plot(abs(fft(sausage_1(1:1024))))
%title('1 отсчёт защитного интервала')
%figure(2);
%plot(abs(fft(sausage_1(129:1153))))
%title('1 отсчёт информационной части')
%На этом в рамках 5 с каналом окончено
%% Приёмник
reverse_sausage = receiver(N_carrier, N_fft, T_guard, sausage_1, Constellation); %Принимаем данные (здесь - неискажённые) в частотной области
outputBits_psd = demapping(Constellation, reverse_sausage); %Представляем принятые рандомизированные данные во временной области
outputBits = randomizer(outputBits_psd,Register); %Проводим дерандомизацию, чтобы получить непосредственно то, что передавал радиопередатчик
mer = Calculate_MER(reverse_sausage, IQ_points_1); %рассчитаем MER на основе отправленных и принятых точек
sprintf('MER = %.4f dB', mer)
%% Export data