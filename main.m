clc;
clear;
%Start Time
time_1=clock;
disp(['The start time of the present experiment is: ',num2str(time_1(1)),' ',num2str(time_1(2)),' ',num2str(time_1(3)),'th ',num2str(time_1(4)),' : ',num2str(time_1(5)),' : ',num2str(time_1(6))]);

%Set random number
rng('shuffle');

%Load Global parameters

%Experiment Repeatation

%Creat optimization configuration
Creat_config_opt();

%Algorithm
EDA_MOEAD();

%Results Recording