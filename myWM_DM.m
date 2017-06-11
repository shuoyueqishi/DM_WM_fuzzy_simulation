clc;
clear;
PI=3.1415926;
t=0:0.01:2;
y=0.9*sin(PI*t)+0.3*cos(3*PI*t);
plot(t,y);%ԭʼͼ��
xlabel('���ֵx');
ylabel('����ֵy');
grid on;
title('y=0.9*sin(PI*t)+0.3*cos(3*PI*t)');

%��ȡ������,����21������
sample_x=0:0.1:2;
sample_y=0.9*sin(PI*sample_x)+0.3*cos(3*PI*sample_x);
sample_num=length(sample_x);%��������

%����x����set_X��ģ�����䣬ʹ����̬����˹������������,����[0,2]
set_X=13;
xmin=0;
xmax=2;
x_step=(xmax-xmin)/(set_X-1);%xģ�����ϵĲ���
av_x=xmin:x_step:xmax;       %�����˹�ֲ���ֵ
sigma_x=sqrt(-x_step^2/(8*log(0.5)));%�����˹�ֲ�����
%sigma_x=0.09;
x=xmin:0.01:xmax;
figure(2)
for i=1:set_X
    plot(gaussmf(x,[sigma_x,av_x(i)]));%����x��ģ����������
    hold on;
end
  legend('A1','A2','A3','A4','A5','A6','A7','A8','A9','A10','A11','A12','A13');
  xlabel('����ֵx');
  ylabel('������ֵu(x)');
  set(gca,'XTick',0:50:250);
  set(gca,'XTickLabel',{'0','0.5','1.0','1.5','2','2.5'});
  title('�������x��ģ�����仮���Լ�������');
  
%����y����set_Yģ�����䣬ʹ��������������,����[-1.5,1.5]
figure(3)
set_Y=13;
ymin=-1.5;%��������
ymax=1.5; %��������
y_step=(ymax-ymin)/(set_Y+1);%�������������֮��Ĳ���
a=ymin;%�����������ޣ��������������ȼ���
y=ymin:0.01:ymax;%��ȡһ��y����ֵ
for i=1:set_Y
    a=a+y_step;
    plot(u_y_B(y,a,ymin,ymax,y_step));%����y��ģ����������
    hold on;
end
 legend('B1','B2','B3','B4','B5','B6','B7','B8','B9','B10','B11','B12','B13');
  xlabel('���ֵy');
  ylabel('������ֵu(y)');
  set(gca,'XTick',0:50:350);
  set(gca,'XTickLabel',{'-1.5','-1.0','-0.5','0','0.5','1.0','1.5','2.0'});
  title('�������y��ģ�����仮���Լ�������');

  %WM�㷨
 uxA=zeros(sample_num,set_X);%�洢ÿ����������x�������Ⱥ���ֵ
 uyB=zeros(sample_num,set_Y);%�洢ÿ����������y�������Ⱥ���ֵ
 for i=1:set_X
     uxA(:,i)=gaussmf(sample_x,[sigma_x,av_x(i)]);%sample_num������x���ڵ�i��ģ�������е�������ֵ
 end
  a=ymin;
 for j=1:set_Y
     a=a+y_step;
     uyB(:,j)=u_y_B(sample_y,a,ymin,ymax,y_step);%sample_num������y���ڵ�j��ģ�������е�������ֵ
 end
 WM_rule=zeros(3,sample_num);%����ÿ�������������ڵ�ģ�����ϵ��±�
 [~,WM_rule(1,:)]=max(uxA,[],2);%����ÿ������x���ڵ�ģ�������±�
 [~,WM_rule(2,:)]=max(uyB,[],2);%����ÿ������y���ڵ�ģ�������±�
 for i=1:sample_num
      WM_rule(3,i)=uxA(i,WM_rule(1,i))*uyB(i,WM_rule(2,i));  %����ÿ�������֧�ֶ� 
 end
 %��������x����ͬһ��ģ�����䣬���ȴ��ͬ�Ĺ���ȥ�����ζȵ͵Ĺ���
 for i=2:sample_num
     if(WM_rule(1,i-1)==WM_rule(1,i))
         if(WM_rule(3,i-1)<=WM_rule(3,i))
             WM_rule(:,i-1)=0;
         else
             WM_rule(:,i)=0;
         end
     end
 end
 
 WM_rule(:,all(WM_rule==0,1))=[];%ȥ�����ڵĹ��򣨰�ÿ��ȫΪ0��ɾ����
 %WM�㷨��ģ��������Ѿ��������
 
%DM�㷨�������֧�ֶ�
DM_AB=zeros(set_Y,set_X);%���ڴ洢֧�ֶȵ���ֵ,�б�ʾB���б�ʾA
for i=1:set_X   %x
    u_x=gaussmf(sample_x,[sigma_x,av_x(i)]);%���������sample_x������ģ���������������ֵ
    a=ymin;
     for j=1:set_Y  %y
        a=a+y_step;
        u_y=u_y_B(sample_y,a,ymin,ymax,y_step);%���������sample_y�����ģ���������������ֵ
        sup_num=0;
        sup_den=0;
        for p=1:sample_num
            sup_num=sup_num+u_y(p)*u_x(p);%�������
            sup_den=sup_den+u_x(p);      %�����ĸ
        end
        sup=sup_num/sup_den;              %����֧�ֶ�
        DM_AB(j,i)=sup;
     end
end

[max_sup,B_index]=max(DM_AB);%�������֧�ֶ�,max_sup����ÿ����������֧�ֶȣ�B_index���������Ӧ�Ĺ���ţ���3����ʾB3����I��λ�ñ�ʾ����ţ�λ��1��ʾA1��
p_value=zeros(1,set_Y);%���ڱ���yģ�������������Ӧ�ĺ������ֵ
a=ymin;
for i=1:set_Y
    a=a+y_step;
    p_value(i)=a;%����yģ�������������Ӧ�ĺ������ֵ
end

%���Թ���
x=0;
y_x=zeros(1,201);
WM_y_x=zeros(1,201);
for i=1:201
    x=x+0.01;
    ux=zeros(1,set_X);
    for m=1:set_X
      ux(m)=gaussmf(x,[sigma_x,av_x(m)]);
    end
   num=0;
   num1=0;
   den=0;
   for j=1:set_X
       num=num+p_value(B_index(j))*ux(j);
       num1=num1+p_value(WM_rule(2,j))*ux(j);
       den=den+ux(j);
   end
   y_x(i)=num/den;
   WM_y_x(i)=num1/den;
end
figure(4);
x=0:0.01:2;
plot(x,y_x,'--r');%����DM�㷨���������
hold on;
plot(x,WM_y_x,'-.b');%����WM�㷨���������
hold on;
y=0.9*sin(PI*x)+0.3*cos(3*PI*x);
plot(x,y,'-g');  %����ԭʼ����������
 xlabel('����ֵx');
 ylabel('���ֵy');
 title('ʹ��WM��DMģ�������㷨�Ľ��');
 %legend('DM�㷨�������','ԭʼ�������');
legend('DM�㷨�������','WM�㷨�������','ԭʼ�������');
grid on;

error=zeros(1,201);
figure(5);
error=abs(y_x-y);
plot(x,error);%�����������ͼ
 xlabel('����ֵx');
 ylabel('�������ֵ');
 title('ʹ��DM�㷨�����');
 E=sqrt(sum(error.^2))/201;%ģ�;���




