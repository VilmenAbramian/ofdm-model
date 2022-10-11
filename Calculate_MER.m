function mer = Calculate_MER(reverse_sausage, IQ_points)
%Реализуем формулу с 22го слайда лекции номер 6
if(size(reverse_sausage,2) ~= size(IQ_points,2))
    reverse_sausage(size(IQ_points,2)) = 0;
end
numerator = sum(real(IQ_points).^2 + imag(IQ_points).^2);
    real_diff = (real(reverse_sausage)-real(IQ_points));
    imag_diff = (imag(reverse_sausage)-imag(IQ_points));
denominator = sum(real_diff.^2 + imag_diff.^2);
mer = 10*log10(numerator/denominator);
end