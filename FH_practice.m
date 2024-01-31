%��������Ļ����ź�Դ���������źŲ���ͼ
clc;clear;
g=40;fs=100000;            %�����ź���Ԫ����g,������fs
r=-10;delay=0;             %�����r,�ӳ�
sig1=round(rand(1,g));     %��������ź�Դ��round�������ڽ��������������Ϊ0��1
signal1=[];                %��ʼ���ź�
for k=1:g                  %��ɢ�㻯     
if sig1(1,k)==0            %����ÿ����Ԫ
sig=-ones(1,1000);         %����1000������Ϊ-1
else          
sig=ones(1,1000);          %����1000������Ϊ1
end      

signal1=[signal1 sig];     %�����ɵ�������ӵ��ź���
end  
figure(1)                  %����ͼ�δ���
plot(signal1,'b','linewidth',1);%�����źŲ��Σ���ɫ�ߣ��߿�Ϊ1    
grid on;                   %��ʾ����
axis([-100 1000*g -1.5 1.5]); %���������᷶Χ
title('�ź�Դ')

T0=200; f0=1/T0;           %���ڣ�Ƶ��
T1=400; f1=1/T1;           %���ڣ�Ƶ��
u0=gensig('sin',T0,1000*g-1,1); %�������Ҳ��ź�u0
u0=rot90(u0);              %��ת�źž���
u1=gensig('sin',T1,1000*g-1,1);%�������Ҳ��ź�u1
u1=rot90(u1);              %��ת�źž���
y0=u0.*sign(-signal1+1);   %���ɵ����ź�y0
y1=u1.*sign(signal1+1);    %���ɵ����ź�y1
SignalFSK=y0+y1;           %���ɵ�FSK�ź� 
figure(2);
% subplot(2,1,1);  
plot(SignalFSK)           % FSK�źŵ�ʱ���� 
axis([-100 1000*g -3 3]); 
title('SignalFSK') 


%����FSK�����źţ���������ʱ���Ρ�
t1=(0:100*pi/999:100*pi);            
t2=(0:110*pi/999:110*pi);                 
t3=(0:120*pi/999:120*pi);                            
t4=(0:130*pi/999:130*pi);                   
t5=(0:140*pi/999:140*pi);                
t6=(0:150*pi/999:150*pi);        
t7=(0:160*pi/999:160*pi);   
t8=(0:170*pi/999:170*pi);   
c1=cos(t1);                      
c2=cos(t2);  
c3=cos(t3);                      
c4=cos(t4);
c5=cos(t5);
c6=cos(t6); 
c7=cos(t7); 
c8=cos(t8); 
adr1=Mcreate(1001203);  %1001203
adr1=[adr1,adr1(1),adr1(2)];      %�û���ַΪ��ʼm����
fh_seq1= []; 
for k=1:g   
seq_1=adr1(3*k-2)*2^2+adr1(3*k-1)*2+adr1(3*k);   
fh_seq1=[fh_seq1 seq_1];              %�����û��ز����� 
end

spread_signal1=[];           %�û�һ�ز�
fhp=[]; 
for k=1:g      
c=fh_seq1(k);     
switch(c)         
case(0)              
spread_signal1=[spread_signal1 c8];         
case(1)              
spread_signal1=[spread_signal1 c1];                %�γ������Ƶ����         
case(2)              
spread_signal1=[spread_signal1 c2];         
case(3)              
spread_signal1=[spread_signal1 c3];         
case(4)              
spread_signal1=[spread_signal1 c4];         
case(5)                      
spread_signal1=[spread_signal1 c5]; 
case(6)              
spread_signal1=[spread_signal1 c6];         
case(7)              
spread_signal1=[spread_signal1 c7];                
end      
fhp=[fhp (500*c+5000)]; 
end

figure(3) %��Ƶͼ��
plot(fhp,'s','markerfacecolor','b','markersize',12); 
grid on;

freq_hopped_sig1=SignalFSK.*spread_signal1;   %��Ƶ��Ƶ���ƣ������ڷ��ȵ��ƣ�
figure(4);  
plot((1:1000*g),freq_hopped_sig1);    %��Ƶ��Ƶ���ʱ���ź�
axis([-100 1000*g -2 2]);  
title('��Ƶ��Ƶ���ʱ���ź�'); 


% �Ӷྶ 
s1=freq_hopped_sig1;  
s=[zeros(1,delay) s1(1:(1000*g-delay))]; 
freq_hopped_sig1=freq_hopped_sig1+s;    
% �Ӹ�˹������  
awgn_signal=awgn(freq_hopped_sig1,r,1/2);%�����Ϊr��

figure(7); 
subplot(2,1,1)  
plot((1:1000*g),awgn_signal);  
title('��Ƶ���ƺ�Ӹ�˹���������ź�'); 
subplot(2,1,2)  
Plot_f(awgn_signal,fs);  
title('��Ƶ���ƺ�Ӹ�˹���������ź�Ƶ��'); 

%��������ɽ����
receive_signal=awgn_signal.*(spread_signal1);%��Ƶ   
figure(8)  
subplot(2,1,1)  
plot([1:1000*g],receive_signal); 
title('��Ƶ����ź�'); 
subplot(2,1,2); 
Plot_f(receive_signal,fs); 
title('��Ƶ���Ƶ��'); 

%��ͨ�˲� 
cof_band=fir1(64,1000/fs);   
signal_out=filter(cof_band,1,receive_signal);
figure(9)  
subplot(2,1,1) 
plot([1:1000*g],signal_out); 
title('��ͨ�˲�����ź�'); 
subplot(2,1,2);  
Plot_f(signal_out,fs);  
title('��ͨ�˲����Ƶ��');

%���
[u2,k]=gensig('sin',T0,1000*g-1,1);u2=rot90(u2);   
[u3,k]=gensig('sin',T1,1000*g-1,1);u3=rot90(u3); 
receive_signal0=signal_out.*u2; 
cof_band=fir1(64,600/fs);   
signal_out0=filter(cof_band,1,receive_signal0);   

receive_signal1=signal_out.*u3;%���յ��źż�Ϊ���и�˹���������ź�1 
cof_band=fir1(64,600/fs);  
signal_out1=filter(cof_band,1,receive_signal1);   
uout=signal_out1-signal_out0; 
figure(10); 
subplot(2,1,1)  
plot(k,signal1);
axis([-100 1000*g -1.5 1.5]); 
title('ԭʼ��Դ'); 
subplot(2,1,2)  
plot(k,uout);
axis([-100 1000*g -4 4]); 
title('FSK�������ź�');

%�����о�
sentenced_signal=ones(1,g);                 
for n=1:g     
    ut=0;      
for m=(n-1)*1000+1:1:1000*n;          
    ut=ut+uout(m);
end     
    if ut<0          
     sentenced_signal(n)=0;     
    end 
end

sentenced_signal_wave=[];     %����������в���������+1��-1����
for k=1:g      
    if sentenced_signal(1,k)==0          
        sig=-ones(1,1000);    % 1000 minus ones for bit 0     
    else          
        sig=ones(1,1000);     % 1000 ones for bit 1     
    end      
    sentenced_signal_wave=[sentenced_signal_wave sig]; 
end  
figure(11),subplot(2,1,1) 
plot(signal1);  
axis([-100 1000*g -1.5 1.5]);  
title('��Դ����'); 
subplot(2,1,2)  
plot(sentenced_signal_wave); 
axis([-100 1000*g -1.5 1.5]);  
title('��ԭ����ź�����');  

