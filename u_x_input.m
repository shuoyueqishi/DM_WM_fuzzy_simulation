function u=u_x_input(x)
%计算任意一个输入在输入模糊区间A1，A2，A3，A4，A5，A6，A7上各自的隶属度值
% x：输入值
% u：输出一个有隶属度组成的数组
a=0;
u=zeros(1,10);
for i=1:10
    a=a+0.2;
   u(i)=u_x_A(x,a); 
end
end

