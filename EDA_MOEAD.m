%% Project: EDA_MOEAD
%Author: Wang Zhao
%Date: 20170103
%Status: Programming

%%
function EDA_MOEAD()
%Description: This function is the main function of EDA-MOEAD

%Struct declaration
pop_array_field_1='obj_1';
pop_array_field_2='obj_2';
pop_array_field_3='pst_x_1';
pop_array_field_4='pst_y_1';
pop_array_field_5='pst_x_2';
pop_array_field_6='pst_y_2';
pop_array_field_7='w';

%Load configuration
load('config_opt.mat');

%Population Initialization
pop_array=struct(...
    pop_array_field_1,cell(amount_pop),...
    pop_array_field_2,cell(amount_pop),...
    pop_array_field_3,cell(amount_pop),...
    pop_array_field_4,cell(amount_pop),...
    pop_array_field_5,cell(amount_pop),...
    pop_array_field_6,cell(amount_pop),...
    pop_array_field_7,cell(amount_pop)...
    );
Initialization_pop(pop_array);


%
while Indic_termination==0
    
end

end

