function u= u_x_A(x,a)
%u_x_A
% �����������x�������Ⱥ���ֵ
%x:���������ֵ
%a�������е��ֵ
%����Ϊ[0,2]������10��ģ������A1,A2,A3,A4,A5,A6,A7��A8��A9��A10
len=length(x);
u=zeros(1,len);
b=a-0.2;
c=a+0.2;
for i=1:len
    if a==0.2
        if x(i)>=b&&x(i)<=a
        u(i)=1;
        end
        if x(i)>a&&x(i)<=c
         u(i)=(c-x(i))/(c-a);
        end
        if x(i)<b||x(i)>c
          u(i)=0;
        end
    elseif a==1.8
            if x(i)>=b&&x(i)<=a
            u(i)=(x(i)-b)/(a-b);
            end
            if x(i)>a&&x(i)<=c
                u(i)=1;
            end
            if x(i)<b||x(i)>c
                u(i)=0;
            end  
    else
            if x(i)>=b&&x(i)<=a
            u(i)=(x(i)-b)/(a-b);
            end
            if x(i)>a&&x(i)<=c
                u(i)=(c-x(i))/(c-a);
            end
            if x(i)<b||x(i)>c
                u(i)=0;
            end
    end
end
end

