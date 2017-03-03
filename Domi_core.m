function indic_domi=Domi_core(obj_new_1,obj_new_2,obj_EP_1,obj_EP_2)
%Project: EDA_MOEAD
%Author: Wang Zhao
%Date: 20170103
%Status: 
%       Check #1
%       Check #2
%Description: This function check the relationship between the two input
%objective values
%Result Explanation
% 1: The new one dominates strongly the old one
% -1: The new one is dominated or equal to the old one
% 0: The two input individuals do not dominate each other

%Set the counter
cnt_2=0;
if ((obj_new_1==obj_EP_1)||(obj_new_2==obj_EP_2))
    if ((obj_new_1>obj_EP_1)&&(obj_new_2==obj_EP_2)||(obj_new_1==obj_EP_1)&&(obj_new_2>obj_EP_2))
        cnt_2=2;
    end
    if ((obj_new_1<obj_EP_1)&&(obj_new_2==obj_EP_2)||(obj_new_1==obj_EP_1)&&(obj_new_2<obj_EP_2))
        cnt_2=-2;
    end
    if ((obj_new_1==obj_EP_1)&&(obj_new_2==obj_EP_2))
        cnt_2=-2;
    end
else
    if obj_new_1>obj_EP_1
        cnt_2=cnt_2+1;
    else
        cnt_2=cnt_2-1;
    end
    if obj_new_2>obj_EP_2
        cnt_2=cnt_2+1;
    else
        cnt_2=cnt_2-1;
    end
end

%Check the comparison result
switch cnt_2
    case 2
        indic_domi=1;
    case -2
        indic_domi=-1;
    case 0
        indic_domi=0;
end
end