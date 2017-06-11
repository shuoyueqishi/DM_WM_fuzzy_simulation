function u = u_y_B(y,a,left,right,step)
%u_y_B
% 计算输出变量y的隶属度函数值
%y:输出变量的值
%a：区间中点的值
%left:表示论域区间的左端点
%right：表示论域区间的右端点
%step:三角形底边长的一半
%论域为[-1.5,1.5]，共有5个模糊区间：B1,B2,B3,B4,B5
b=a-step;
c=a+step;
len=length(y);
u=zeros(1,len);
for i=1:len
    if a==left+step
        if y(i)>=b&&y(i)<=a
        u(i)=1;
        end
        if y(i)>a&&y(i)<=c
         u(i)=(c-y(i))/(c-a);
        end
        if y(i)<b||y(i)>c
          u(i)=0;
        end
    elseif a==right-step
            if y(i)>=b&&y(i)<=a
            u(i)=(y(i)-b)/(a-b);
            end
            if y(i)>a&&y(i)<=c
                u(i)=1;
            end
            if y(i)<b||y(i)>c
                u(i)=0;
            end  
    else
            if y(i)>=b&&y(i)<=a
            u(i)=(y(i)-b)/(a-b);
            end
            if y(i)>a&&y(i)<=c
                u(i)=(c-y(i))/(c-a);
            end
            if y(i)<b||y(i)>c
                u(i)=0;
            end
    end
end
end

