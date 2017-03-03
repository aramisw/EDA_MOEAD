function [obj_past_1,obj_past_2]=Domi_record(obj_1,obj_2,obj_past_1,obj_past_2)
%Project: EDA_MOEAD
%Author: Wang Zhao
%Date: 20170103
%Status: 
%       Check #1
%       Check #2
%Description: This function checks the relationships between the new
%records and the present records of the current individual. And Then update
%the objective value list according to the result.
% Result explanation: indic_domi
% 1&0: The new objective values should be added to the list
% -1: The new objective values should not be added to the list

%Calculate the size of the obj history
[~,amount_record]=size(obj_past_1);
%ATTENTION: The form of the obj_past_1 and obj_past_2 is: '_____'

%Set the default value
indic_domi=0;

%Set the temporary objective recorder counter
indic_status=zeros(amount_record,1);
%Value Explanation: indic_status
% 0: The objective values and the new ones do not dominate each other
% -1: The objective values dominate the new objective values
% 1: The new ones dominate the objective values

%Compare the objective values
for cnt_1=1:1:amount_record
    if((obj_1==obj_past_1(cnt_1))||(obj_2==obj_past_2(cnt_1)))
        % Equality case
        if ((obj_1>obj_past_1(cnt_1))&&(obj_2==obj_past_2(cnt_1)))||((obj_1==obj_past_1(cnt_1))&&(obj_2>obj_past_2(cnt_1)))
            cnt_2=2;
        end
        if ((obj_1<=obj_past_1(cnt_1))&&(obj_2==obj_past_2(cnt_1)))||((obj_1==obj_past_1(cnt_1))&&(obj_2<=obj_past_2(cnt_1)))
            cnt_2=-2;
        end
    else       
        cnt_2=0;
        if obj_1>obj_past_1(cnt_1)
            cnt_2=cnt_2+1;
        else
            cnt_2=cnt_2-1;
        end
        if obj_2>obj_past_2(cnt_1)
            cnt_2=cnt_2+1;
        else
            cnt_2=cnt_2-1;
        end
    end
    switch cnt_2
        case 2
            indic_status(cnt_1)=1;
            indic_domi=1;
        case -2
            indic_status(cnt_1)=-1;
            indic_domi=-1;
            break;
        case 0
            indic_status(cnt_1)=0;
            indic_domi=0;
    end
end
if indic_domi~=-1
    %The new objective values survive the comparison
    cnt_2=1;
    obj_past_tmp_1=[];
    obj_past_tmp_2=[];
    for cnt_1=1:1:amount_record
        if indic_status(cnt_1)~=1
            obj_past_tmp_1(cnt_2)=obj_past_1(cnt_1);  %#ok<AGROW>
            obj_past_tmp_2(cnt_2)=obj_past_2(cnt_1);   %#ok<AGROW>
            cnt_2=cnt_2+1;
        end
    end
    obj_past_tmp_1(cnt_2)=obj_1;
    obj_past_tmp_2(cnt_2)=obj_2;
    obj_past_1=obj_past_tmp_1;
    obj_past_2=obj_past_tmp_2;
end
%ATTENTION
% If the new objective values did not pass the dominance check, it will not
% be added to the objective value list of the current individual, but
% serves as the current objective values in '.obj_1' and '.obj_2'. Thus we
% have to maintain a complete list of objective values for each EP
% individual only according to which we decide if we can keep the
% individual in the next iteration.
end