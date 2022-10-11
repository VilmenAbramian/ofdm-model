function OutputBits = demapping (Constellation, InputPoints)
[~,L] = size(InputPoints); %Количество символов во входном массиве, благодаря которому можно узнать количество точек, которые необходимо обработать
switch Constellation
    case 'BPSK'
        BPSK_value=[1 0;-1 -0]; %Массив, содержащий все возможные варианты BPSK
        BPSK_bits = [1;0]; % Вектор-столбец, содержащий битовую кодировку для значений созвездия BPSK
        norm_BPSK = Norm(BPSK_value); %Нормируем созвездие BPSK
        amount = 2; %Количество точек в созвездии
        strim = PointToBits(InputPoints, norm_BPSK, BPSK_bits, L, amount);%Вызываем универсальную функцию демаппинга и записывам получающуюся "колбасу" в соответствующую переменную
        strim_1 = transpose(strim);
        OutputBits = transpose(strim_1(:));
   case 'QPSK'
        QPSK_value=[1 1;1 -1;-1 1;-1 -1]; %Массив, содержащий все возможные варианты QPSK
        QPSK_bits = [0 0;0 1;1 0;1 1]; % Вектор-столбец, содержащий битовую кодировку для значений созвездия QPSK 
        norm_QPSK = Norm(QPSK_value); %Нормируем созвездие QPSK
        amount = 4; %Количество точек в созвездии
        strim = PointToBits(InputPoints, norm_QPSK, QPSK_bits, L, amount);%Вызываем универсальную функцию демаппинга и записывам получающуюся "колбасу" в соответствующую переменную
        strim_1 = transpose(strim);
        OutputBits = transpose(strim_1(:));
   case '16-QAM'
        QAM_value=[3,3;3,1;1,3;1,1;3,-3;3,-1;1,-3;1,-1;-3,3;-3,1;-1,3;-1,1;-3,-3;-3,-1;-1,-3;-1,-1]; %Массив, содержащий все возможные варианты 16-QAM
        QAM_bits = [0 0 0 0;0 0 0 1;0 0 1 0; 0 0 1 1;0 1 0 0;0 1 0 1; 0 1 1 0; 0 1 1 1; 1 0 0 0; 1 0 0 1; 1 0 1 0; 1 0 1 1; 1 1 0 0; 1 1 0 1; 1 1 1 0; 1 1 1 1]; % Вектор-столбец, содержащий битовую кодировку для значений созвездия 16-QAM 
        norm_QAM = Norm(QAM_value); %Нормируем созвездие 16-QAM
        amount = 16; %Количество точек в созвездии
        strim = PointToBits(InputPoints, norm_QAM, QAM_bits, L, amount);%Вызываем универсальную функцию демаппинга и записывам получающуюся "колбасу" в соответствующую переменную
        strim_1 = transpose(strim);
        OutputBits = transpose(strim_1(:));
end
end
%Функция, содержащая универсальные циклы демаппинга для всех видов созвездий
function [outputBits] = PointToBits(InputPoints, norm_value, bits, quantity, amount) %На вход принимаем сырые входные данные, нормированные значения, биты заданного созвездия, количество точек, которые необходимо обработать, количество точек созвездия
for i_1 = 1:quantity %Цикл, обрабатывающий любое количество входных точек
    for i_2 = 1:amount %Цикл, который находит расстояния от одной заданной точки до всех точек заданного созвездия
        t(i_2, i_1) = abs(InputPoints(i_1)-norm_value(i_2));
    end
    [~, minNum] = min(t);
    outputBits = bits(minNum,:);
end
end