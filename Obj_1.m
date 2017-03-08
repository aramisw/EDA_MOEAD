function [obj_1]=Obj_1(...
indiv_1,...
user_array_1,...
user_array_2,...
amount_airship,...
amount_user,...
para_obj_1,...
dist_cov,...
height_airship,...
cap_airship)
%Project: EDA_MOEAD
%Author: Wang Zhao
%Date: 20170103
%Status: 
%       Check #1
%       Check #2
%       Chwck #3
%Description:This functin calculate the objective value of the input
%individual

%Phase 1
%calculate the speed of the users in phase 1
dist_a2u_project=zeros(amount_airship,amount_user);
for cnt_1=1:1:amount_airship
    for cnt_2=1:1:amount_user
        %This is the projected distance between the airships and the users
        dist_a2u_project(cnt_1,cnt_2)=sqrt((indiv_1.pst_x_1(cnt_1)-user_array_1(cnt_2,1))^2+(indiv_1.pst_y_1(cnt_1)-user_array_1(cnt_2,2))^2);
    end
end
indic_connect=zeros(amount_airship,amount_user);  %this vector records the connection status of the users to the airships
dist_a2u_actual=zeros(amount_airship,amount_user);
for cnt_1=1:1:amount_airship
    for cnt_2=1:1:amount_user
        if dist_a2u_project(cnt_1,cnt_2)<=dist_cov
            dist_a2u_actual(cnt_1,cnt_2)=sqrt((indiv_1.pst_x_1(cnt_1)-user_array_1(cnt_2,1))^2+(indiv_1.pst_y_1(cnt_1)-user_array_1(cnt_2,2))^2+height_airship^2);
            indic_connect(cnt_1,cnt_2)=1;
        else
            dist_a2u_actual(cnt_1,cnt_2)=0;
            indic_connect(cnt_1,cnt_2)=0;
        end
    end
end
amount_connection=sum(indic_connect,2);
cap_split=cap_airship./amount_connection;
cap_user_1=zeros(1,amount_user);
for cnt_2=1:1:amount_user
    for cnt_1=1:1:amount_airship
       if indic_connect(cnt_1,cnt_2)~=0
           cap_user_1(cnt_2)=cap_user_1(cnt_2)+cap_split(cnt_1)*(para_obj_1*(dist_a2u_actual(cnt_1,cnt_2)-height_airship)^2+1);
       end
    end
end

%Phase 2
%calculate the speed of the users in phase 1
dist_a2u_project=zeros(amount_airship,amount_user);
for cnt_1=1:1:amount_airship
    for cnt_2=1:1:amount_user
        %This is the projected distance between the airships and the users
        dist_a2u_project(cnt_1,cnt_2)=sqrt((indiv_1.pst_x_2(cnt_1)-user_array_2(cnt_2,1))^2+(indiv_1.pst_y_2(cnt_1)-user_array_2(cnt_2,2))^2);
    end
end
indic_connect=zeros(amount_airship,amount_user);  %this vector records the connection status of the users to the airships
dist_a2u_actual=zeros(amount_airship,amount_user);
for cnt_1=1:1:amount_airship
    for cnt_2=1:1:amount_user
        if dist_a2u_project(cnt_1,cnt_2)<=dist_cov
            dist_a2u_actual(cnt_1,cnt_2)=sqrt((indiv_1.pst_x_2(cnt_1)-user_array_2(cnt_2,1))^2+(indiv_1.pst_y_2(cnt_1)-user_array_2(cnt_2,2))^2+height_airship^2);
            indic_connect(cnt_1,cnt_2)=1;
        else
            dist_a2u_actual(cnt_1,cnt_2)=0;
            indic_connect(cnt_1,cnt_2)=0;
        end
    end
end
amount_connection=sum(indic_connect,2);
cap_split=cap_airship./amount_connection;
cap_user_2=zeros(1,amount_user);
for cnt_2=1:1:amount_user
    for cnt_1=1:1:amount_airship
       if indic_connect(cnt_1,cnt_2)~=0
           cap_user_2(cnt_2)=cap_user_2(cnt_2)+cap_split(cnt_1)*(para_obj_1*(dist_a2u_actual(cnt_1,cnt_2)-height_airship)^2+1);
       end
    end
end

%Calculate the objective value
obj_1=sum(cap_user_1)+sum(cap_user_2);

end