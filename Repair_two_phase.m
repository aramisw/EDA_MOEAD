function [pst_x_1,pst_y_1,pst_x_2,pst_y_2]=Repair_two_phase(pst_x_1,pst_y_1,pst_x_2,pst_y_2,dist_move)
%Project: EDA_MOEAD
%Author: Wang Zhao
%Date: 20170103
%Status: Programming
%Status:
%       check #1
%       check #2
%       check #3
%Description: This function repairs the positions of thw two phases

%Prepare the common information
[~,amount_airship]=size(pst_x_1);
dist_array=sqrt((pst_x_1-pst_x_2).^2+(pst_y_1-pst_y_2).^2);

for cnt_1=1:1:amount_airship %Check the two positions of the each airship
    if dist_array(cnt_1)>dist_move
        %Perform repair
        tmp_1=dist_array(cnt_1)-dist_move;
        tmp_2=tmp_1/dist_array(cnt_1);
        tmp_3=rand();
        tmp_4=pst_x_1(cnt_1)-pst_x_2(cnt_1);
        tmp_5=pst_y_1(cnt_1)-pst_y_2(cnt_1);
        tmp_4=tmp_4*tmp_2;
        tmp_5=tmp_5*tmp_2;
        if tmp_3>=0.5  %Randomly pick a phase
            %Repair the second position
            pst_x_2(cnt_1)=pst_x_2(cnt_1)+tmp_4;
            pst_y_2(cnt_1)=pst_y_2(cnt_1)+tmp_5;
        else
            pst_x_1(cnt_1)=pst_x_1(cnt_1)-tmp_4;
            pst_y_1(cnt_1)=pst_y_1(cnt_1)-tmp_5;
        end
    end
end
end