function CCDF = CCDF(IQ_points, N_OFDM_symbols, N_carrier, N_fft, PAPR0)
%3.1
OFDM_spectrum = zeros(N_OFDM_symbols, N_fft);
for i=1:N_OFDM_symbols
    OFDM_spectrum(i, 2:N_carrier+1) = IQ_points((i-1)*N_carrier+1:(N_carrier)*i);
end
%3.2
OFDM_symbols = ifft(OFDM_spectrum, [], 2);
%PAPR
PAPR = zeros(N_OFDM_symbols, 1);
for i=1:N_OFDM_symbols
    a = max(abs(OFDM_symbols(i,:)))^2;
    b = mean(abs(OFDM_symbols(i,:)))^2;
    PAPR(i) = 10*log10(a/b);
end
for i=1:size(PAPR0,2)  
    c = size(PAPR(PAPR > PAPR0(i)),1);
    CCDF(i)= c/size(PAPR, 1);   
end 
end

