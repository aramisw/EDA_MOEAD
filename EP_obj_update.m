function EP_list=EP_obj_update(...
    EP_list,...
    user_array_1,...
    user_array_2,...
    amount_airship,...
    amount_user,...
    para_obj_1,...
    dist_cov,...
    height_airship,...
    cap_airship...
    )
%Project: EDA_MOEAD
%Author: Wang Zhao
%Date: 20170103
%Status: 
%       Check #1
%       Check #2
%       Check #3
%       Check #4
%Description: This function is used to update the ooriginal objective value
%according to the new user distribution
%ATTENTION: The update of the second objective is uncessary. Therefore the
%           second objective is not updated in this 

%Calculate the size of the EP population
[~,amount_EP]=size(EP_list);

%Calculate the objective value of each individual
for cnt_1=1:1:amount_EP
    
    %ATTENTION: The objective value calculated according to the new user
    %distribution is not used to update the objective value references.
    %Thus these objective values should be used only for the dominance
    %check.
    
    %Calculate the objective values of the EP according to the new user
    %distribution
    [obj_1]=Obj_1(EP_list(cnt_1),user_array_1,user_array_2,amount_airship,amount_user,para_obj_1,dist_cov,height_airship,cap_airship);
    %Add this new record to the current individual
    if obj_1>EP_list(cnt_1).obj_past_1
        EP_list(cnt_1).obj_past_1=obj_1;
    end
    %Set the objective value as the objective value of the EP individual
    EP_list(cnt_1).obj_1=obj_1;
end

end