%% Project: EDA_MOEAD
%Author: Wang Zhao
%Date: 20170103
%Status: Programming

%%
function Creat_config_opt()
%Description: This function creat the optimization congifuration file for
%the optimization progress
amount_pop=100;   %#ok<NASGU>

save('config_opt.mat',...
    'amount_pop');
end