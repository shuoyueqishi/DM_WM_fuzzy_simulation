function u = u_y_B(y,a,left,right,step)
%u_y_B
% �����������y�������Ⱥ���ֵ
%y:���������ֵ
%a�������е��ֵ
%left:��ʾ�����������˵�
%right����ʾ����������Ҷ˵�
%step:�����εױ߳���һ��
%����Ϊ[-1.5,1.5]������5��ģ�����䣺B1,B2,B3,B4,B5
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

