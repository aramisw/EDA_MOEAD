%%
%This is the entry of the whole program, which controls everything of the
%program. The program is the Estimated Distribution Algorithm based on
%MOEA/D.
% Status:
%        Checked #1
%        Checked #2  2017 02 20
%%
clc;
clear;
%Start Time
time_1=clock;
disp(['The start time of the present experiment is: ',num2str(time_1(1)),' ',num2str(time_1(2)),' ',num2str(time_1(3)),'th ',num2str(time_1(4)),' : ',num2str(time_1(5)),' : ',num2str(time_1(6))]);
disp('EDA_MOEA/D version: 1.0');

%Set random number
rng('shuffle');

%ID set
ID_series='000000';

%Set the repetation of the whole program
amount_rpt=10;

%The repeatition
for cnt_1=1:1:amount_rpt
    %Creat optimization configuration
    Creat_config_opt();
    
    %Creat the ID
    if amount_rpt<=10
        ID_1=[ID_series '0' num2str(cnt_1)];
    else
        ID_1=[ID_series num2str(cnt_1)];
    end
    
    %Algorithm
    EDA_MOEAD(ID_1);
end

%Format
% 1. pop_array: This is the array which records all the individuals
%               obj_1:      the origin value of the objective 1
%               obj_2:      the origin value of the objective 2
%               pst_x_1:    the x positions of the airships in phase 1. It is a
%                           row vector. _ _ _ _.
%               pst_y_1:    the y positions of the airships in phase 1. It is a
%                           row vector. _ _ _ _.
%               pst_x_2:    the x positions of the airships in phase 2. It is a
%                           row vector. _ _ _ _.
%               pst_y_2:    the y positions of the airships in phase 2. It is a
%                           row vector. _ _ _ _.
%               w1:         the weight of objective 1
%               w2:         the weight of objective 2
%               nb:         the neighbor vector of the current individual. The
%                           'nb' reocrds the indexes of the individuals.
%                           _____
%               obj_norm_1: the normalized value of the objective 1
%               obj_norm_2: the normalized value of the objective 2
%               obj_decomp: the decomposed value of the two objectives
%               obj_past_1: this is the objective value of the individual
%                           if it enters the EP list. Therefore, the individuals that
%                           are not in the EP list have no values in this
%                           field. When new user distribution is generated,
%                           the individuals in EP list will be evaluated
%                           again and the past objective values will be
%                           recorded in this field. 
%                           _
%                           _
%                           _
%                           _
%               obj_past_2: this is the objective value of the individual
%                           if it enters the EP list. Therefore, the individuals that
%                           are not in the EP list have no values in this
%                           field. When new user distribution is generated,
%                           the individuals in EP list will be evaluated
%                           again and the past objective values will be
%                           recorded in this field. 
%                           _
%                           _
%                           _
%                           _
% 2. user_array_1 & user_array_2: These two arrays record the user
%                                 positions. Each row is one user. The
%                                 first column is the x position and the
%                                 second column is the y position.
%3. ID: eight digits. _    _    _    _    _    _    _    _
%                     The first six digits records the series number of the
%                     experiments. The last two digits is the repetation
%                     experiments which can contain 100 independent
%                     experiment.
%