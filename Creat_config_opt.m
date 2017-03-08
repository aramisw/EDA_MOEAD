function Creat_config_opt()
%Description: This function creat the optimization congifuration file for
%the optimization progress
%Project: EDA_MOEAD
%Author: Wang Zhao
%Date: 20170103
%Status:
%       Check #1
%       Check #2 2017 02 20
%       Check #3
%Suggesting Parameters:Unadded yet
amount_pop=100;           %#ok<NASGU>
ratio_neighbor=0.1;       %#ok<NASGU>
area_x=100;               %#ok<NASGU>
area_y=100;               %#ok<NASGU>
amount_airship=4;         %#ok<NASGU>
dist_cov=20;              %#ok<NASGU>
height_airship=30;        %#ok<NASGU>
cap_airship=100;          %#ok<NASGU>
fade_a2u_1=0.4;           %#ok<NASGU>
user_distribution_type=1; %#ok<NASGU>
interval_new=7;          %#ok<NASGU>
prec_obj_2=100;           %#ok<NASGU>
penalty_PBI=1;            %#ok<NASGU>
type_decomp=3;            %#ok<NASGU>
ratio_balance=0.3;        %#ok<NASGU>
type_new=1;               %#ok<NASGU>
length_history=5;         %#ok<NASGU>
prec_EDA=100;             %#ok<NASGU>
pr_crossover=0.5;         %#ok<NASGU>
yita_SBX=1;               %#ok<NASGU>
F_DE=0.5;                 %#ok<NASGU>
alpha_BLX=0.5;            %#ok<NASGU>
type_mutation=1;          %#ok<NASGU>
pr_mutation=0.8;          %#ok<NASGU>
yita_poly=20;             %#ok<NASGU>
gen_max=300;              %#ok<NASGU>
beta_NU=1;                %#ok<NASGU>       
dist_move=10;             %#ok<NASGU>


save('config_opt.mat',...
    'amount_pop',...
    'ratio_neighbor',...
    'area_x',...
    'area_y',...
    'amount_airship',...
    'dist_cov',...
    'height_airship',...
    'cap_airship',...
    'fade_a2u_1',...
    'user_distribution_type',...
    'interval_new',...
    'prec_obj_2',...
    'penalty_PBI',...
    'type_decomp',...
    'ratio_balance',...
    'type_new',...
    'length_history',...
    'prec_EDA',...
    'pr_crossover',...
    'yita_SBX',...
    'F_DE',...
    'alpha_BLX',...
    'type_mutation',...
    'pr_mutation',...
    'yita_poly',...
    'gen_max',...
    'beta_NU',...
    'dist_move');
end