function sausage_1_with_awgn = my_awgn(SNR, sausage_1)
%Воспользуемся результатами первой лабораторной работы Ляшева Владимира Александровича с той лишь разницей, что у нас одно значение SNR

%to add termal noise according input SNR, we need estimate average power
%of the signal to be sure that we will add right portion of noise.
Ps = mean(var(sausage_1)); %Средняя мощность сигнала
Dn = Ps / 10^(SNR/10);

% adding complex gaussian noise with variation Dn and expectation mean|n0| = 1
n0 = (randn(1,size(sausage_1,2)) + 1i*randn(1,size(sausage_1,2)))*sqrt(Dn/2);
sausage_1_with_awgn = sausage_1 + n0;
%Проверим
%y = awgn(sausage_1, SNR, 'measured');
%t1 = xor(abs(sausage_1_with_awgn), abs(y));
%t2 = xor(angle(sausage_1_with_awgn), angle(y));
end