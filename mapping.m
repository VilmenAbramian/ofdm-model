function point = mapping (Constellation, InputBits)
[~,l] = size(InputBits); %���������� �������� �� ������� �������, ��������� �������� ����� ������ ���������� �����, ������� ���������� ����������
switch Constellation
    case 'BPSK'
        BPSK_value=[1 0;-1 -0]; %������, ���������� ��� ��������� �������� BPSK
        for iB = 1:l %����, �������� ��������� ����� �� ���
            numberB(iB)=bi2de(InputBits(iB),2,'left-msb')+1; %���������� ����� ����� � ��������� ��������� ����,+1 ����� ��� ����, ����� ������ ��������� �� � 0, � � 1
            x(iB)=BPSK_value(numberB(iB),1); %���������� �������, �������� ������ �������� �� �������, ��������� ��� �������� BPSK
            y(iB)=BPSK_value(numberB(iB),2); %���������� ��������, �������� ������ �������� �� �������, ��������� ��� �������� BPSK
        end
        point = complex(x,y); %����������, ������� �������� � ���� ��������� ���������� � ���� ������������ �����
    case 'QPSK'
        QPSK_value=[1 1;1 -1;-1 1;-1 -1]; %������, ���������� ��� ��������� �������� QPSK
        a = Norm(QPSK_value); %�������� ����� ���������� �� �������� ����� ���� ����� ���������
        countQ=1; %�������������� ������� ��� ���������� �������� ������ �� ��������� 2� ������� �����
        for iQ1 = 1:l/2 %��� �����, ������� �������� ������� ����� �� �����, ������ �� ������� ����� 2 ����
            for iQ2 = 1:2  
                pointQ(iQ1,iQ2) = InputBits(countQ); %��������� ������, ���������� ��� ������� ���� ���� �����. ������ ������� - ��� ��������� �����. 4 ��������, � ������ �������� ���� ��� ��� ���������� �����
                countQ = countQ+1;
            end
        end
        for iQ3 = 1:l/2 %����, �������� ��������� ����� �� ���
            numberQ(iQ3)=bi2de(pointQ(iQ3,:),2,'left-msb')+1;
            x(iQ3)=real(a(numberQ(iQ3)));
            y(iQ3)=imag(a(numberQ(iQ3)));
        end
        point = complex(x,y); %����������, ������� �������� � ���� ��������� ���������� � ���� ������������ �����
    case '16-QAM'
        QAM_value=[3,3;3,1;1,3;1,1;3,-3;3,-1;1,-3;1,-1;-3,3;-3,1;-1,3;-1,1;-3,-3;-3,-1;-1,-3;-1,-1]; %������, ���������� ��� ��������� �������� 16-QAM
        a = Norm(QAM_value); %�������� ����� ���������� �� �������� ����� ���� ����� ���������
        count=1; %�������������� ������� ��� ���������� �������� ������ �� ��������� 4� ������� �����
        for i16_1 = 1:l/4 %��� �����, ������� �������� ������� ����� �� �����, ������ �� ������� ����� 4 ����
            for i16_2 = 1:4  
                point(i16_1,i16_2) = InputBits(count); %��������� ������, ���������� ��� ������� ���� ���� �����. ������ ������� - ��� ��������� �����. 4 ��������, � ������ �������� ���� ��� ��� ���������� �����
                count = count+1;
            end
        end
        for i16 = 1:l/4 %����, �������� ��������� ����� �� ���
            number16(i16)=bi2de(point(i16,:),2,'left-msb')+1; %���������� ����� ����� � ��������� ��������� ����,+1 ����� ��� ����, ����� ������ ��������� �� � 0, � � 1
            x(i16)=real(a(number16(i16))); %���������� �������, �������� ������ �������� �� ������������ �������, ��������� ��� ������������� �������� 16-QAM
            y(i16)=imag(a(number16(i16))); %���������� ��������, �������� ������ �������� �� ������������ �������, ��������� ��� ������������� �������� 16-QAM
        end
        point = complex(x,y); %����������, ������� �������� � ���� ��������� ���������� � ���� ������������ �����
end
%Paint(x,y, Constellation); %�������� ������� ��������� ����� �� ����������� ���������
end
function [a] = Norm(value)
[lN,~] = size(value);
    for iN1=1:lN
        z(iN1)=complex(value(iN1,1),value(iN1,2)); 
    end
    sum=0;
    for iN2=1:lN
        sum=sum+z(iN2)*conj(z(iN2));
    end
    n=sqrt(sum/lN);
    for iN3=1:lN
        a(iN3)=z(iN3)/n; 
    end 
end
%�������, ������� ������ ��������� �� ����������� ��������� �� �������� �������������� � ������ ������. ����� ��� ��������� �������� ���������
function Paint(x,y,heder)
   plot(x,y, 'x');
   xlim([-3.5,3.5]);
   ylim([-3.5,3.5]);
   grid on;
   title(heder);
   ylabel('Quadrature');
   xlabel('In-Phase');
end