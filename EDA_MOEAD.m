function EDA_MOEAD(ID_1,rpt_1)
%Project: EDA_MOEAD
%Author: Wang Zhao
%Date: 20170103
%Status:
%       Check #1
%       Check #2
%       Check #3
%       Check #4
%Description: This function is the main function of EDA-MOEAD
%INPUT PARAMETERS:
% ID_1: This is the complete ID of this experiment, which is used to name
% the result file.
% rpt_1: This is the repetition index of the current experiment

%Struct declaration
pop_array_field_1=...
    {...
    'obj_1';...
    'obj_2';...
    'pst_x_1';...
    'pst_y_1';...
    'pst_x_2';...
    'pst_y_2';...
    'w1';...
    'w2';...
    'nb';...
    'obj_norm_1';...
    'obj_norm_2';...
    'obj_decomp';...
    'obj_past_1';...
    'obj_past_2'...
    };
%Initialize the configuration filename
ID_config_name=['config_opt_',ID_1(1:6),'.mat'];

%Load configuration
load(ID_config_name);

%information calculation
amount_neighbor=floor(amount_pop*ratio_neighbor);
tmp_1=(dist_cov^2+height_airship^2)^0.5;  %Calculate the maximum communication distance
para_obj_1=(fade_a2u_1-1)/(tmp_1-height_airship)^2;  %The is the parameter when calculating the objective 1

%Initialize the population and the new individual structure
pop_array=Initialization_pop(amount_pop,area_x,area_y,amount_airship,amount_neighbor);
indiv_new_1=struct(...
    pop_array_field_1{1},cell(1),...
    pop_array_field_1{2},cell(1),...
    pop_array_field_1{3},cell(1),...
    pop_array_field_1{4},cell(1),...
    pop_array_field_1{5},cell(1),...
    pop_array_field_1{6},cell(1),...
    pop_array_field_1{7},cell(1),...
    pop_array_field_1{8},cell(1),...
    pop_array_field_1{9},cell(1),...
    pop_array_field_1{10},cell(1),...
    pop_array_field_1{11},cell(1),...
    pop_array_field_1{12},cell(1),...
    pop_array_field_1{13},cell(1),...
    pop_array_field_1{14},cell(1)...
    );

%Initialize the time counter
cnt_time=1; %This is the counter which records the current iteration
%ATTENTION: The time starts at 'generation 1'.

%Initialize the user array
user_array_1=[];
user_array_2=[];
[user_array_1,user_array_2,~]=User_generator(...
    cnt_time,...
    user_distribution_type,...
    interval_new,...
    user_array_1,...
    user_array_2,...
    area_x,...
    area_y);

%Get the amount of the user
[amount_user,~]=size(user_array_1);

%Calculate the objective values of the initial population
for cnt_1=1:1:amount_pop
    pop_array(cnt_1).obj_1=Obj_1(...
        pop_array(cnt_1),...
        user_array_1,...
        user_array_2,...
        amount_airship,...
        amount_user,...
        para_obj_1,...
        dist_cov,...
        height_airship,...
        cap_airship);
    pop_array(cnt_1).obj_2=Obj_2(pop_array(cnt_1),amount_airship,prec_obj_2,area_x,area_y,dist_cov);
end

reference_obj_1=[0,0,0];  %Set the reference objective value as [0,0,0], in which the first value is the minimum objective value and the second one is the maximum objective value and the third value is the interval between the maximum and minimum values
reference_obj_2=[0,0,0];
indic_ref_obj_1=0;  %#ok<NASGU> %The indicator which indicates whether the reference of the population have been changed
indic_ref_obj_2=0;  %#ok<NASGU> % '0' for unchanged and '1' for changed
for cnt_1=1:1:amount_pop  %Update the reference
    [reference_obj_1,indic_ref_obj_1]=Ref_update_1(pop_array(cnt_1),reference_obj_1); %#ok<ASGLU>
    [reference_obj_2,indic_ref_obj_2]=Ref_update_2(pop_array(cnt_1),reference_obj_2); %#ok<ASGLU>
end
for cnt_1=1:1:amount_pop  %Calculate the normed objective value
    [pop_array(cnt_1).obj_norm_1]=Obj_norm_1(pop_array(cnt_1),reference_obj_1);
    [pop_array(cnt_1).obj_norm_2]=Obj_norm_2(pop_array(cnt_1),reference_obj_2);
end
for cnt_1=1:1:amount_pop
    pop_array(cnt_1).obj_decomp=Obj_decomp(pop_array(cnt_1),type_decomp,penalty_PBI);
end

%Set the initial EDA probability history
eda_history_1=zeros(prec_EDA,prec_EDA,amount_pop);
eda_history_2=zeros(prec_EDA,prec_EDA,amount_pop);
eda_history_clean_1=zeros(prec_EDA,prec_EDA,amount_pop);
eda_history_clean_2=zeros(prec_EDA,prec_EDA,amount_pop);

%Set the initial non-dominated population list
pipe_eda_1=zeros(prec_EDA,prec_EDA,length_history,amount_pop);
pipe_eda_2=zeros(prec_EDA,prec_EDA,length_history,amount_pop);
pipe_eda_clean_1=zeros(prec_EDA,prec_EDA,length_history,amount_pop);
pipe_eda_clean_2=zeros(prec_EDA,prec_EDA,length_history,amount_pop);

%Set the origin EP_list and initialize the EP with the initial population
EP_list=[];
for cnt_1=1:1:amount_pop
    EP_list=EP_add(EP_list,pop_array(cnt_1),type_new);
end

%Initialize the termination data
termination_1=[];

%Check if we have to terminate the program in the first generation

%prepare the data to be input
[~,amount_EP]=size(EP_list);
obj_ter_1=[];  %the previous generation will be set as blank
obj_ter_2_pre=zeros(amount_EP,2);
if type_new==1
    %ATTENTION: The objective vectors used for termination criterion is not
    %the same for the EDA based generator and the comparison generator
    
    %For the EDA generator
    for cnt_1=1:1:amount_EP
        obj_ter_2_pre(cnt_1,1)=EP_list(cnt_1).obj_past_1;
        obj_ter_2_pre(cnt_1,2)=EP_list(cnt_1).obj_past_2;
    end
else
    %For the other generator
    for cnt_1=1:1:amount_EP
        obj_ter_2_pre(cnt_1,1)=EP_list(cnt_1).obj_1;
        obj_ter_2_pre(cnt_1,2)=EP_list(cnt_1).obj_2;
    end
end

%Refine the current obective vector array
indic_add=EP_add_core2(obj_ter_2_pre);
cnt_2=1;
amount_obj_ter_2=sum(indic_add);
obj_ter_2=zeros(amount_obj_ter_2,2);
for cnt_1=1:1:amount_EP
    if indic_add(cnt_1)==1
        obj_ter_2(cnt_2,:)=obj_ter_2_pre(cnt_1,:);
        cnt_2=cnt_2+1;
    end
end

%Perform the termination check
[termination_1,indic_termination]=EBT(termination_1,obj_ter_1,obj_ter_2,cnt_time,amount_bin,amount_gen,amount_decimal);


%Begin iteration
while indic_termination==0
    
    %ETA
    tic;
    
    %Iteration counter set
    cnt_time=cnt_time+1;
    
    %Display generation counter
    disp(['Gen: ',num2str(cnt_time)]);
    
    %Generate the user distribution
    [user_array_1,user_array_2,indic_user_changed]=User_generator(...
        cnt_time,...
        user_distribution_type,...
        interval_new,...
        user_array_1,...
        user_array_2,...
        area_x,...
        area_y);
    
    %Update the whole population
    for cnt_1=1:1:amount_pop
        [...
            indiv_new_1.pst_x_1,...
            indiv_new_1.pst_y_1,...
            indiv_new_1.pst_x_2,...
            indiv_new_1.pst_y_2,...
            eda_history_1(:,:,cnt_1),...
            eda_history_2(:,:,cnt_1),...
            eda_history_clean_1(:,:,cnt_1),...
            eda_history_clean_2(:,:,cnt_1),...
            pipe_eda_1(:,:,:,cnt_1),...
            pipe_eda_2(:,:,:,cnt_1),...
            pipe_eda_clean_1(:,:,:,cnt_1),...
            pipe_eda_clean_2(:,:,:,cnt_1)...
            ]=Eda_generate(...
            cnt_1,...
            pop_array,...
            ratio_balance,...
            amount_airship,...
            amount_neighbor,...
            type_new,...
            eda_history_1(:,:,cnt_1),...
            eda_history_2(:,:,cnt_1),...
            length_history,...
            cnt_time,...
            prec_EDA,...
            area_x,...
            area_y,...
            eda_history_clean_1(:,:,cnt_1),...
            eda_history_clean_2(:,:,cnt_1),...
            pipe_eda_1(:,:,:,cnt_1),...
            pipe_eda_2(:,:,:,cnt_1),...
            pipe_eda_clean_1(:,:,:,cnt_1),...
            pipe_eda_clean_2(:,:,:,cnt_1),...
            pr_crossover,...
            yita_SBX,...
            F_DE,...
            alpha_BLX);
        %Check if we need mutation
        if type_new~=1
            %Mutation needed
            [indiv_new_1.pst_x_1,indiv_new_1.pst_y_1,indiv_new_1.pst_x_2,indiv_new_1.pst_y_2]=mutation_EDA(...
                indiv_new_1.pst_x_1,...
                indiv_new_1.pst_y_1,...
                indiv_new_1.pst_x_2,...
                indiv_new_1.pst_y_2,...
                type_mutation,...
                pr_mutation,...
                yita_poly,...
                area_x,...
                area_y,...
                gen_max,...
                cnt_time,...
                beta_NU);
        end
        %Repair the new individual
        [indiv_new_1.pst_x_1,indiv_new_1.pst_y_1,indiv_new_1.pst_x_2,indiv_new_1.pst_y_2]=Repair_two_phase(indiv_new_1.pst_x_1,indiv_new_1.pst_y_1,indiv_new_1.pst_x_2,indiv_new_1.pst_y_2,dist_move);
        %Calculate the original objective value of the new individual
        indiv_new_1.obj_1=Obj_1(indiv_new_1,user_array_1,user_array_2,amount_airship,amount_user,para_obj_1,dist_cov,height_airship,cap_airship);
        indiv_new_1.obj_2=Obj_2(indiv_new_1,amount_airship,prec_obj_2,area_x,area_y,dist_cov);
        %Update the reference point
        [reference_obj_1,indic_ref_obj_1]=Ref_update_1(indiv_new_1,reference_obj_1);
        [reference_obj_2,indic_ref_obj_2]=Ref_update_1(indiv_new_1,reference_obj_2);
        %Calculate the normalized objective of the new individual
        indiv_new_1.obj_norm_1=Obj_norm_1(indiv_new_1,reference_obj_1);
        indiv_new_1.obj_norm_2=Obj_norm_2(indiv_new_1,reference_obj_2);
        %Check if we need to update the normalized objective of the other
        %individuals
        if indic_ref_obj_1==1
            %The other individuals need to be updated
            for cnt_2=1:1:amount_pop
                pop_array(cnt_2).obj_norm_1=Obj_norm_1(pop_array(cnt_2),reference_obj_1);
            end
        end
        if indic_ref_obj_2==1
            %The other individuals need to be updated
            for cnt_2=1:1:amount_pop
                pop_array(cnt_2).obj_norm_2=Obj_norm_2(pop_array(cnt_2),reference_obj_2);
            end
        end
        %Check if we need to update the decomposed objective values of the
        %individuals
        if (indic_ref_obj_1==1)||(indic_ref_obj_2==1)
            for cnt_2=1:1:amount_pop
                pop_array(cnt_2).obj_decomp=Obj_decomp(pop_array(cnt_2),type_decomp,penalty_PBI);
            end
        end
        %Update the entire neighborhood
        for cnt_2=1:1:amount_neighbor
            %Set the weight vector
            indiv_new_1.w1=pop_array(pop_array(cnt_1).nb(cnt_2)).w1;
            indiv_new_1.w2=pop_array(pop_array(cnt_1).nb(cnt_2)).w2;
            %Calculate the decomposed objective value
            indiv_new_1.obj_decomp=Obj_decomp(indiv_new_1,type_decomp,penalty_PBI);
            %Compare the decomposed objective betweeen the new individual
            %and the individuals in the neighborhood
            if indiv_new_1.obj_decomp<pop_array(pop_array(cnt_1).nb(cnt_2)).obj_decomp
                %If the new individual is better according to the decomped
                %objective value
                pop_array(pop_array(cnt_1).nb(cnt_2)).pst_x_1=indiv_new_1.pst_x_1;
                pop_array(pop_array(cnt_1).nb(cnt_2)).pst_y_1=indiv_new_1.pst_y_1;
                pop_array(pop_array(cnt_1).nb(cnt_2)).pst_x_2=indiv_new_1.pst_x_2;
                pop_array(pop_array(cnt_1).nb(cnt_2)).pst_y_2=indiv_new_1.pst_y_2;
                pop_array(pop_array(cnt_1).nb(cnt_2)).obj_1=indiv_new_1.obj_1;
                pop_array(pop_array(cnt_1).nb(cnt_2)).obj_2=indiv_new_1.obj_2;
                pop_array(pop_array(cnt_1).nb(cnt_2)).obj_norm_1=indiv_new_1.obj_norm_1;
                pop_array(pop_array(cnt_1).nb(cnt_2)).obj_norm_2=indiv_new_1.obj_norm_2;
                pop_array(pop_array(cnt_1).nb(cnt_2)).obj_decomp=indiv_new_1.obj_decomp;
            end
        end
        %Check if the users are changed in this generation
        if indic_user_changed==1
            %If the user distribution has changed in this generation
            EP_list=EP_obj_update(...  %Then the EP has to be updated.
                EP_list,...
                user_array_1,...
                user_array_2,...
                amount_airship,...
                amount_user,...
                para_obj_1,...
                dist_cov,...
                height_airship,...
                cap_airship...
                );
        end
        %Add the individual to the external population (EP)
        EP_list=EP_add(EP_list,indiv_new_1,type_new);
    end
    
    %Temination check
    if cnt_time>=gen_max
        %ATTENTION: If the number of the iterations exceeds the maximum
        %           threshold, the program will be terminated anyway.
        indic_termination=1;
    else
        %prepare the data to be input
        [~,amount_EP]=size(EP_list);
        obj_ter_1=obj_ter_2;  %prepare the objective value vectors of the previous generation
        obj_ter_2_pre=zeros(amount_EP,2);
        if type_new==1
            for cnt_1=1:1:amount_EP
                obj_ter_2_pre(cnt_1,1)=EP_list(cnt_1).obj_past_1;
                obj_ter_2_pre(cnt_1,2)=EP_list(cnt_1).obj_past_2;
            end
        else
            for cnt_1=1:1:amount_EP
                obj_ter_2_pre(cnt_1,1)=EP_list(cnt_1).obj_1;
                obj_ter_2_pre(cnt_1,2)=EP_list(cnt_1).obj_2;
            end
        end
        
        %Refine the current obective vector array
        indic_add=EP_add_core2(obj_ter_2_pre);
        cnt_2=1;
        amount_obj_ter_2=sum(indic_add);
        obj_ter_2=zeros(amount_obj_ter_2,2);
        for cnt_1=1:1:amount_EP
            if indic_add(cnt_1)==1
                obj_ter_2(cnt_2,:)=obj_ter_2_pre(cnt_1,:);
                cnt_2=cnt_2+1;
            end
        end
        
        %Perform the termination check
        [termination_1,indic_termination]=EBT(termination_1,obj_ter_1,obj_ter_2,cnt_time,amount_bin,amount_gen,amount_decimal);
    end
    
    %ETA
    time_1=toc;
    time_3=time_1*(gen_max-cnt_time);
    time_2_h=floor(time_3/3600);
    time_2_m=floor((time_3-time_2_h*3600)/60);
    time_2_s=time_3-time_2_h*3600-time_2_m*60;
    disp(['RPT:',num2str(rpt_1),'ETA: ',num2str(time_2_h),' hours ',num2str(time_2_m),' minutes ',num2str(time_2_s),' seconds.']);
    
end

%Record the results
save(ID_1);

end

