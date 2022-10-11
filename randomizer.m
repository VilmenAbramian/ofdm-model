function InputBits_psd = randomizer(InputBits,Register)
N_ib = size(InputBits,2);
InputBits_psd = zeros(1, N_ib);
    for i=1:N_ib
        xor_scheme = xor(Register(end-1),Register(end)); %Первый XOR в схеме
        InputBits_psd(i) = xor(InputBits(i), xor_scheme); %Второй XOR в схеме
        Register = circshift(Register, 1); %Делаем циклический сдвиг регистра
        Register(1) = xor_scheme;
    end
end

