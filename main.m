%%
%This is the entry of the whole program, which controls everything of the
%program. The program is the Estimated Distribution Algorithm based on
%MOEA/D.
% Status:
%        Check #1
%        Check #2  2017 02 20
%        Check #3
%        Check #4 blank
%        Check #5
%%
clc;
clear;

%Start Time
time_1=clock;

%Open log file
%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
fp_1=fopen('20170318.txt','w');
%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

disp(['The start time of the experiment series is: ',num2str(time_1(1)),' ',num2str(time_1(2)),' ',num2str(time_1(3)),'th ',num2str(time_1(4)),' : ',num2str(time_1(5)),' : ',num2str(time_1(6))]);
disp('EDA_MOEA/D version: 1.2');

%Record the headings to the log file
fprintf(fp_1,'---------------------------------------------------------------------------\r\n');
fprintf(fp_1,['The start time of the experiment series is: ',num2str(time_1(1)),' ',num2str(time_1(2)),' ',num2str(time_1(3)),'th ',num2str(time_1(4)),' : ',num2str(time_1(5)),' : ',num2str(time_1(6))]);
fprintf(fp_1,'\r\n');
fprintf(fp_1,'---------------------------------------------------------------------------\r\n');
fprintf(fp_1,'EDA_MOEA/D version: 1.2\r\n');
fprintf(fp_1,'---------------------------------------------------------------------------\r\n');
fprintf(fp_1,'Experiment Series:\r\n');

%Set random number
rng('shuffle');

%ID set
%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
ID_series(1,:)='000002';
ID_series(2,:)='000003';
%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

%Calculate the number of experiment series
[amount_series,~]=size(ID_series);

%Record the info to the txt file
for cnt_1=1:1:amount_series
    fprintf(fp_1,[ID_series(cnt_1,:), '\r\n']);
end
fprintf(fp_1,'---------------------------------------------------------------------------\r\n');

%Set the repetation of the whole program
amount_rpt=10;

%Record the info to the txt file
fprintf(fp_1,['Repetition:',num2str(amount_rpt),'\r\n']);
fprintf(fp_1,'---------------------------------------------------------------------------\r\n');

%The loop of all the experiment series
for cnt_1=1:1:amount_series
    
    %The repeatition of the same experiment series
    for cnt_2=0:1:amount_rpt-1
        
        %Creat the ID
        if cnt_2<10
            ID_1=[ID_series(cnt_1,1:6), '0', num2str(cnt_2)];
        else
            ID_1=[ID_series(cnt_1,1:6), num2str(cnt_2)];
        end
        
        %Algorithm
        EDA_MOEAD(ID_1,cnt_2);
    end
end

%End Time
time_1=clock;

%Record the info to the txt file
disp(['The end time of the experiment series is: ',num2str(time_1(1)),' ',num2str(time_1(2)),' ',num2str(time_1(3)),'th ',num2str(time_1(4)),' : ',num2str(time_1(5)),' : ',num2str(time_1(6))]);
fprintf(fp_1,['The end time of the experiment series is: ',num2str(time_1(1)),' ',num2str(time_1(2)),' ',num2str(time_1(3)),'th ',num2str(time_1(4)),' : ',num2str(time_1(5)),' : ',num2str(time_1(6))]);
fprintf(fp_1,'\r\n');
fprintf(fp_1,'---------------------------------------------------------------------------');

fclose(fp_1);

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
%                           _ _ _ _ _
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
%                           _ _ _ _ _
%               obj_past_2: this is the objective value of the individual
%                           if it enters the EP list. Therefore, the individuals that
%                           are not in the EP list have no values in this
%                           field. When new user distribution is generated,
%                           the individuals in EP list will be evaluated
%                           again and the past objective values will be
%                           recorded in this field.
%                           _ _ _ _ _
% 2. user_array_1 & user_array_2: These two arrays record the user
%                                 positions. Each row is one user. The
%                                 first column is the x position and the
%                                 second column is the y position.
%                                 _ _
%                                 _ _
%3. ID: eight digits. _    _    _    _    _    _    _    _
%                     The first six digits records the series number of the
%                     experiments. The last two digits is the repetation
%                     experiments which can contain 100 independent
%                     experiment.
%4. Parameter setting marks: The parameter setting marks is labeled as
%                            below:
%                            %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
%                            parameters to be set
%                            %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$