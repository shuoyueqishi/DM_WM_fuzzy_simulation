clc;
clear;
PI=3.1415926;
t=0:0.01:2;
y=0.9*sin(PI*t)+0.3*cos(3*PI*t);
plot(t,y);%原始图像
xlabel('输出值x');
ylabel('输入值y');
grid on;
title('y=0.9*sin(PI*t)+0.3*cos(3*PI*t)');

%获取采样点,采样21组数据
sample_x=0:0.1:2;
sample_y=0.9*sin(PI*sample_x)+0.3*cos(3*PI*sample_x);
sample_num=length(sample_x);%采样个数

%论域x划分set_X个模糊区间，使用正态（高斯）形隶属函数,论域[0,2]
set_X=13;
xmin=0;
xmax=2;
x_step=(xmax-xmin)/(set_X-1);%x模糊集合的步长
av_x=xmin:x_step:xmax;       %计算高斯分布均值
sigma_x=sqrt(-x_step^2/(8*log(0.5)));%计算高斯分布方差
%sigma_x=0.09;
x=xmin:0.01:xmax;
figure(2)
for i=1:set_X
    plot(gaussmf(x,[sigma_x,av_x(i)]));%绘制x的模糊函数曲线
    hold on;
end
  legend('A1','A2','A3','A4','A5','A6','A7','A8','A9','A10','A11','A12','A13');
  xlabel('输入值x');
  ylabel('隶属度值u(x)');
  set(gca,'XTick',0:50:250);
  set(gca,'XTickLabel',{'0','0.5','1.0','1.5','2','2.5'});
  title('输入变量x的模糊区间划分以及隶属度');
  
%论域y划分set_Y模糊区间，使用三角隶属函数,论域[-1.5,1.5]
figure(3)
set_Y=13;
ymin=-1.5;%论域下限
ymax=1.5; %论域上限
y_step=(ymax-ymin)/(set_Y+1);%三角形两个尖点之间的步长
a=ymin;%保存论域下限，方便后面的隶属度计算
y=ymin:0.01:ymax;%获取一组y的数值
for i=1:set_Y
    a=a+y_step;
    plot(u_y_B(y,a,ymin,ymax,y_step));%绘制y的模糊函数曲线
    hold on;
end
 legend('B1','B2','B3','B4','B5','B6','B7','B8','B9','B10','B11','B12','B13');
  xlabel('输出值y');
  ylabel('隶属度值u(y)');
  set(gca,'XTick',0:50:350);
  set(gca,'XTickLabel',{'-1.5','-1.0','-0.5','0','0.5','1.0','1.5','2.0'});
  title('输出变量y的模糊区间划分以及隶属度');

  %WM算法
 uxA=zeros(sample_num,set_X);%存储每条样本数据x的隶属度函数值
 uyB=zeros(sample_num,set_Y);%存储每条样本数据y的隶属度函数值
 for i=1:set_X
     uxA(:,i)=gaussmf(sample_x,[sigma_x,av_x(i)]);%sample_num个样本x的在第i个模糊区间中的隶属度值
 end
  a=ymin;
 for j=1:set_Y
     a=a+y_step;
     uyB(:,j)=u_y_B(sample_y,a,ymin,ymax,y_step);%sample_num个样本y的在第j个模糊区间中的隶属度值
 end
 WM_rule=zeros(3,sample_num);%保存每个样本数据所在的模糊集合的下标
 [~,WM_rule(1,:)]=max(uxA,[],2);%计算每个样本x所在的模糊集合下标
 [~,WM_rule(2,:)]=max(uyB,[],2);%计算每个样本y所在的模糊集合下标
 for i=1:sample_num
      WM_rule(3,i)=uxA(i,WM_rule(1,i))*uyB(i,WM_rule(2,i));  %计算每条规则的支持度 
 end
 %对于属于x属于同一个模糊区间，输出却不同的规则，去除信任度低的规则
 for i=2:sample_num
     if(WM_rule(1,i-1)==WM_rule(1,i))
         if(WM_rule(3,i-1)<=WM_rule(3,i))
             WM_rule(:,i-1)=0;
         else
             WM_rule(:,i)=0;
         end
     end
 end
 
 WM_rule(:,all(WM_rule==0,1))=[];%去除多于的规则（把每列全为0的删除）
 %WM算法的模糊规则库已经建立完成
 
%DM算法计算最大支持度
DM_AB=zeros(set_Y,set_X);%用于存储支持度的数值,行表示B，列表示A
for i=1:set_X   %x
    u_x=gaussmf(sample_x,[sigma_x,av_x(i)]);%计算采样点sample_x在输入模糊区间的隶属函数值
    a=ymin;
     for j=1:set_Y  %y
        a=a+y_step;
        u_y=u_y_B(sample_y,a,ymin,ymax,y_step);%计算采样点sample_y在输出模糊区间的隶属函数值
        sup_num=0;
        sup_den=0;
        for p=1:sample_num
            sup_num=sup_num+u_y(p)*u_x(p);%计算分子
            sup_den=sup_den+u_x(p);      %计算分母
        end
        sup=sup_num/sup_den;              %计算支持度
        DM_AB(j,i)=sup;
     end
end

[max_sup,B_index]=max(DM_AB);%计算最大支持度,max_sup保存每条规则的最大支持度，B_index保存输出对应的规则号（如3，表示B3），I的位置表示规则号（位置1表示A1）
p_value=zeros(1,set_Y);%用于保存y模糊函数尖点所对应的横坐标的值
a=ymin;
for i=1:set_Y
    a=a+y_step;
    p_value(i)=a;%保存y模糊函数尖点所对应的横坐标的值
end

%测试规则
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
plot(x,y_x,'--r');%画出DM算法的输出曲线
hold on;
plot(x,WM_y_x,'-.b');%画出WM算法的输出曲线
hold on;
y=0.9*sin(PI*x)+0.3*cos(3*PI*x);
plot(x,y,'-g');  %画出原始函数的曲线
 xlabel('输入值x');
 ylabel('输出值y');
 title('使用WM、DM模糊控制算法的结果');
 %legend('DM算法输出曲线','原始输出曲线');
legend('DM算法输出曲线','WM算法输出曲线','原始输出曲线');
grid on;

error=zeros(1,201);
figure(5);
error=abs(y_x-y);
plot(x,error);%画出误差曲线图
 xlabel('输入值x');
 ylabel('绝对误差值');
 title('使用DM算法的误差');
 E=sqrt(sum(error.^2))/201;%模型精度




