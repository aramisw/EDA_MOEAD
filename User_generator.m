function [user_array_1,user_array_2,indic_user_changed]=User_generator(...
    cnt_time,...
    user_distribution_type,...
    interval_new,...
    user_array_1,...
    user_array_2,...
    area_x,...
    area_y)
%%
%Description: This function generate the user distribution accroding to the
%parameter settings
%Project: EDA_MOEAD
%Author: Wang Zhao
%Date: 20170103
%Status:
%       Check #1
%       Check #2
% INPUT PARAMETERS:
% 1:  cnt_time: This is the iteration counter
% 2:  user_distribution_type: This is the type of the user distribution, in
%     another word, this is the problem indicator.
%       The types of the user distribution includes these below:
%       a). '1':    The first test problem: single hotspot shift. In this
%                   problem, the hotspot shifts from one position to another position
%                   with the radius unchanged.
%                   single hotspot:
%                   hotspot position of phase 1: (20,50)
%                   hotspot position of phase 2: (80,50)
%                   radius: 20;
%                   hotspot user in two phases: 1000
%                   background user: 1000
%       b). '2':    The second test problem: single hotspot to two
%                   hotspots. In this problem, one hotspot in phase 1 changes to two
%                   hotspots.
%                   single hotspot to two hotspots:
%                   hotspot position of phase 1: (20,50)
%                   hotspot position of phase 2: (80,20) and (80,80)
%                   radius: 20;
%                   hotspot user in phase 1: 1000
%                   hotspot user in phase 2: 500 each
%                   background user: 1000
%       c). '3':    The third test problem: two hotspots shift. In this
%                   problem, two hotspots shift to other positions relatively with the
%                   same radius
%                   two hotspots shift:
%                   hotspot position of phase 1: (20,20) and (20,80)
%                   hotspot position of phase 2: (80,20) and (80,80)
%                   radius: 20;
%                   hotspot user in phase 1: 500 each
%                   hotspot user in phase 2: 500 each
%                   background user: 1000
%                   Pre-allocate the space
%       d). '4':    The forth test problem: single hotspot expand. In this
%                   problem, the radius of the hotspot expands with the center of the
%                   hotspot unchanged.
%                   single hotspot expand:
%                   hotspot position of phase 1: (50,50)
%                   hotspot position of phase 2: (50,50)
%                   radius of phase 1: 10;
%                   radius of phase 2: 20;
%                   hotspot user in phase 1: 1000
%                   hotspot user in phase 2: 1000
%                   background user: 1000
%       e). '5':    The fifth test problem: single hotspot to annulus. In
%                   this problem, the hotspot shifts to a rim with the same center.
%                   single hotspot to annulus:
%                   hotspot position of phase 1: (50,50)
%                   hotspot position of phase 2: (50,50)
%                   radius of phase 1: 10 (circle);
%                   radius of phase 2: 20 of inner ring and 30 of external ring
%                   hotspot user in phase 1: 1000
%                   hotspot user in phase 2: 1000
%                   background user: 1000
% 3:  interval_new: This is the iteration interval after which a new user
%     distribution is generated
% OUTPUT PARAMETERS:
% 1: user_array_1: This is the user distribution of the first phase
% 2: user_array_2: This is the user distribution of the second phase
% 3: indic_user_changed: This indicate whether the user distribution has
%    changed in this generation
%    value explanation:
%    '0': The user distribution did not change in this genration
%    '1': The user distribution has changed in this generation
%%
%Check if it is the time to generate the new user distribution
if ((rem(cnt_time,interval_new)==0)||(cnt_time==1))
    %ATTENTION: For the first generation, saying cnt_time=1, the
    %rem(cnt_time,interval_new)=0, and thus we have to generate the user
    %distribution anyway
    %Perform the generation
    switch user_distribution_type
        case 1
            %%
            % PROBLEM DESCRIPTION:
            % The first test problem: single hotspot shift
            % single hotspot:
            % hotspot position of phase 1: (20,50)
            % hotspot position of phase 2: (80,50)
            % radius: 20;
            % hotspot user in two phases: 1000
            % background user: 1000
            %%
            % Pre-allocate the space
            user_array_1=zeros(2000,2);
            user_array_2=zeros(2000,2);
            
            %For phase 1
            %Generate the hotspot user
            for cnt_1=1:1:1000
                while((user_array_1(cnt_1,1)<=0)||(user_array_1(cnt_1,1)>=area_x)||(user_array_1(cnt_1,2)<=0)||(user_array_1(cnt_1,2)>=area_y))
                    tmp_angle=2*pi*rand();  %Generate a random angle
                    tmp_radius=abs(normrnd(0,20));
                    user_array_1(cnt_1,1)=tmp_radius*cos(tmp_angle)+20;
                    user_array_1(cnt_1,2)=tmp_radius*sin(tmp_angle)+50;
                end
            end
            
            %Generate the background user
            for cnt_1=1001:1:2000
                while((user_array_1(cnt_1,1)<=0)||(user_array_1(cnt_1,1)>=area_x)||(user_array_1(cnt_1,2)<=0)||(user_array_1(cnt_1,2)>=area_y))
                    user_array_1(cnt_1,1)=area_x*rand();
                    user_array_1(cnt_1,2)=area_y*rand();
                end
            end
            
            %For phase 2
            %Generate the hotspot user
            for cnt_1=1:1:1000
                while((user_array_2(cnt_1,1)<=0)||(user_array_2(cnt_1,1)>=area_x)||(user_array_2(cnt_1,2)<=0)||(user_array_2(cnt_1,2)>=area_y))
                    tmp_angle=2*pi*rand();  %Generate a random angle
                    tmp_radius=abs(normrnd(0,20));
                    user_array_2(cnt_1,1)=tmp_radius*cos(tmp_angle)+80;
                    user_array_2(cnt_1,2)=tmp_radius*sin(tmp_angle)+50;
                end
            end
            
            %Generate the background user
            for cnt_1=1001:1:2000
                while((user_array_2(cnt_1,1)<=0)||(user_array_2(cnt_1,1)>=area_x)||(user_array_2(cnt_1,2)<=0)||(user_array_2(cnt_1,2)>=area_y))
                    user_array_2(cnt_1,1)=area_x*rand();
                    user_array_2(cnt_1,2)=area_y*rand();
                end
            end
        case 2
            % PROBLEM DESCRIPTION:
            % The second test problem: single hotspot to two hotspots
            % single hotspot to two hotspots:
            % hotspot position of phase 1: (20,50)
            % hotspot position of phase 2: (80,20) and (80,80)
            % radius: 20;
            % hotspot user in phase 1: 1000
            % hotspot user in phase 2: 500 each
            % background user: 1000
            %%
            % Pre-allocate the space
            user_array_1=zeros(2000,2);
            user_array_2=zeros(2000,2);
            
            %For phase 1
            %Generate the hotspot user
            for cnt_1=1:1:1000
                while((user_array_1(cnt_1,1)<=0)||(user_array_1(cnt_1,1)>=area_x)||(user_array_1(cnt_1,2)<=0)||(user_array_1(cnt_1,2)>=area_y))
                    tmp_angle=2*pi*rand();  %Generate a random angle
                    tmp_radius=abs(normrnd(0,20));
                    user_array_1(cnt_1,1)=tmp_radius*cos(tmp_angle)+20;
                    user_array_1(cnt_1,2)=tmp_radius*sin(tmp_angle)+50;
                end
            end
            
            %Generate the background user
            for cnt_1=1001:1:2000
                while((user_array_1(cnt_1,1)<=0)||(user_array_1(cnt_1,1)>=area_x)||(user_array_1(cnt_1,2)<=0)||(user_array_1(cnt_1,2)>=area_y))
                    user_array_1(cnt_1,1)=area_x*rand();
                    user_array_1(cnt_1,2)=area_y*rand();
                end
            end
            
            %For phase 2
            %Generate the hotspot user
            for cnt_1=1:1:500
                while((user_array_2(cnt_1,1)<=0)||(user_array_2(cnt_1,1)>=area_x)||(user_array_2(cnt_1,2)<=0)||(user_array_2(cnt_1,2)>=area_y))
                    tmp_angle=2*pi*rand();  %Generate a random angle
                    tmp_radius=abs(normrnd(0,20));
                    user_array_2(cnt_1,1)=tmp_radius*cos(tmp_angle)+80;
                    user_array_2(cnt_1,2)=tmp_radius*sin(tmp_angle)+20;
                end
            end
            for cnt_1=501:1:1000
                while((user_array_2(cnt_1,1)<=0)||(user_array_2(cnt_1,1)>=area_x)||(user_array_2(cnt_1,2)<=0)||(user_array_2(cnt_1,2)>=area_y))
                    tmp_angle=2*pi*rand();  %Generate a random angle
                    tmp_radius=abs(normrnd(0,20));
                    user_array_2(cnt_1,1)=tmp_radius*cos(tmp_angle)+80;
                    user_array_2(cnt_1,2)=tmp_radius*sin(tmp_angle)+80;
                end
            end
            
            %Generate the background user
            for cnt_1=1001:1:2000
                while((user_array_2(cnt_1,1)<=0)||(user_array_2(cnt_1,1)>=area_x)||(user_array_2(cnt_1,2)<=0)||(user_array_2(cnt_1,2)>=area_y))
                    user_array_2(cnt_1,1)=area_x*rand();
                    user_array_2(cnt_1,2)=area_y*rand();
                end
            end
        case 3
            % PROBLEM DESCRIPTION:
            % The third test problem: two hotspots shift
            % two hotspots shift:
            % hotspot position of phase 1: (20,20) and (20,80)
            % hotspot position of phase 2: (80,20) and (80,80)
            % radius: 20;
            % hotspot user in phase 1: 500 each
            % hotspot user in phase 2: 500 each
            % background user: 1000
            % Pre-allocate the space
            user_array_1=zeros(2000,2);
            user_array_2=zeros(2000,2);
            
            %For phase 1
            %Generate the hotspot user
            for cnt_1=1:1:500
                while((user_array_1(cnt_1,1)<=0)||(user_array_1(cnt_1,1)>=area_x)||(user_array_1(cnt_1,2)<=0)||(user_array_1(cnt_1,2)>=area_y))
                    tmp_angle=2*pi*rand();  %Generate a random angle
                    tmp_radius=abs(normrnd(0,20));
                    user_array_1(cnt_1,1)=tmp_radius*cos(tmp_angle)+20;
                    user_array_1(cnt_1,2)=tmp_radius*sin(tmp_angle)+20;
                end
            end
            for cnt_1=501:1:1000
                while((user_array_1(cnt_1,1)<=0)||(user_array_1(cnt_1,1)>=area_x)||(user_array_1(cnt_1,2)<=0)||(user_array_1(cnt_1,2)>=area_y))
                    tmp_angle=2*pi*rand();  %Generate a random angle
                    tmp_radius=abs(normrnd(0,20));
                    user_array_1(cnt_1,1)=tmp_radius*cos(tmp_angle)+20;
                    user_array_1(cnt_1,2)=tmp_radius*sin(tmp_angle)+80;
                end
            end
            
            %Generate the background user
            for cnt_1=1001:1:2000
                while((user_array_1(cnt_1,1)<=0)||(user_array_1(cnt_1,1)>=area_x)||(user_array_1(cnt_1,2)<=0)||(user_array_1(cnt_1,2)>=area_y))
                    user_array_1(cnt_1,1)=area_x*rand();
                    user_array_1(cnt_1,2)=area_y*rand();
                end
            end
            
            %For phase 2
            %Generate the hotspot user
            for cnt_1=1:1:500
                while((user_array_2(cnt_1,1)<=0)||(user_array_2(cnt_1,1)>=area_x)||(user_array_2(cnt_1,2)<=0)||(user_array_2(cnt_1,2)>=area_y))
                    tmp_angle=2*pi*rand();  %Generate a random angle
                    tmp_radius=abs(normrnd(0,20));
                    user_array_2(cnt_1,1)=tmp_radius*cos(tmp_angle)+80;
                    user_array_2(cnt_1,2)=tmp_radius*sin(tmp_angle)+20;
                end
            end
            for cnt_1=501:1:1000
                while((user_array_2(cnt_1,1)<=0)||(user_array_2(cnt_1,1)>=area_x)||(user_array_2(cnt_1,2)<=0)||(user_array_2(cnt_1,2)>=area_y))
                    tmp_angle=2*pi*rand();  %Generate a random angle
                    tmp_radius=abs(normrnd(0,20));
                    user_array_2(cnt_1,1)=tmp_radius*cos(tmp_angle)+80;
                    user_array_2(cnt_1,2)=tmp_radius*sin(tmp_angle)+80;
                end
            end
            
            %Generate the background user
            for cnt_1=1001:1:2000
                while((user_array_2(cnt_1,1)<=0)||(user_array_2(cnt_1,1)>=area_x)||(user_array_2(cnt_1,2)<=0)||(user_array_2(cnt_1,2)>=area_y))
                    user_array_2(cnt_1,1)=area_x*rand();
                    user_array_2(cnt_1,2)=area_y*rand();
                end
            end
            
        case 4
            % PROBLEM DESCRIPTION:
            % The forth test problem: single hotspot expand
            % single hotspot expand:
            % hotspot position of phase 1: (50,50)
            % hotspot position of phase 2: (50,50)
            % radius of phase 1: 10;
            % radius of phase 2: 30;
            % hotspot user in phase 1: 1000
            % hotspot user in phase 2: 1000
            % background user: 1000
            
            % Pre-allocate the space
            user_array_1=zeros(2000,2);
            user_array_2=zeros(2000,2);
            
            %For phase 1
            %Generate the hotspot user
            for cnt_1=1:1:1000
                while((user_array_1(cnt_1,1)<=0)||(user_array_1(cnt_1,1)>=area_x)||(user_array_1(cnt_1,2)<=0)||(user_array_1(cnt_1,2)>=area_y))
                    tmp_angle=2*pi*rand();  %Generate a random angle
                    tmp_radius=abs(normrnd(0,10));
                    user_array_1(cnt_1,1)=tmp_radius*cos(tmp_angle)+50;
                    user_array_1(cnt_1,2)=tmp_radius*sin(tmp_angle)+50;
                end
            end
            
            %Generate the background user
            for cnt_1=1001:1:2000
                while((user_array_1(cnt_1,1)<=0)||(user_array_1(cnt_1,1)>=area_x)||(user_array_1(cnt_1,2)<=0)||(user_array_1(cnt_1,2)>=area_y))
                    user_array_1(cnt_1,1)=area_x*rand();
                    user_array_1(cnt_1,2)=area_y*rand();
                end
            end
            
            %For phase 2
            %Generate the hotspot user
            for cnt_1=1:1:1000
                while((user_array_2(cnt_1,1)<=0)||(user_array_2(cnt_1,1)>=area_x)||(user_array_2(cnt_1,2)<=0)||(user_array_2(cnt_1,2)>=area_y))
                    tmp_angle=2*pi*rand();  %Generate a random angle
                    tmp_radius=abs(normrnd(0,30));
                    user_array_2(cnt_1,1)=tmp_radius*cos(tmp_angle)+50;
                    user_array_2(cnt_1,2)=tmp_radius*sin(tmp_angle)+50;
                end
            end
            
            %Generate the background user
            for cnt_1=1001:1:2000
                while((user_array_2(cnt_1,1)<=0)||(user_array_2(cnt_1,1)>=area_x)||(user_array_2(cnt_1,2)<=0)||(user_array_2(cnt_1,2)>=area_y))
                    user_array_2(cnt_1,1)=area_x*rand();
                    user_array_2(cnt_1,2)=area_y*rand();
                end
            end
        case 5
            % PROBLEM DESCRIPTION:
            % The fifth test problem: single hotspot to annulus
            % single hotspot to annulus:
            % hotspot position of phase 1: (50,50)
            % hotspot position of phase 2: (50,50)
            % radius of phase 1: 10 (circle);
            % radius of phase 2: 20 of inner ring and 30 of external ring
            % hotspot user in phase 1: 1000
            % hotspot user in phase 2: 1000
            % background user: 1000
            % Pre-allocate the space
            user_array_1=zeros(2000,2);
            user_array_2=zeros(2000,2);
            
            %For phase 1
            %Generate the hotspot user
            for cnt_1=1:1:1000
                while((user_array_1(cnt_1,1)<=0)||(user_array_1(cnt_1,1)>=area_x)||(user_array_1(cnt_1,2)<=0)||(user_array_1(cnt_1,2)>=area_y))
                    tmp_angle=2*pi*rand();  %Generate a random angle
                    tmp_radius=abs(normrnd(0,10));
                    user_array_1(cnt_1,1)=tmp_radius*cos(tmp_angle)+50;
                    user_array_1(cnt_1,2)=tmp_radius*sin(tmp_angle)+50;
                end
            end
            
            %Generate the background user
            for cnt_1=1001:1:2000
                while((user_array_1(cnt_1,1)<=0)||(user_array_1(cnt_1,1)>=area_x)||(user_array_1(cnt_1,2)<=0)||(user_array_1(cnt_1,2)>=area_y))
                    user_array_1(cnt_1,1)=area_x*rand();
                    user_array_1(cnt_1,2)=area_y*rand();
                end
            end
            
            %For phase 2
            %Generate the hotspot user
            for cnt_1=1:1:1000
                while((user_array_2(cnt_1,1)<=0)||(user_array_2(cnt_1,1)>=area_x)||(user_array_2(cnt_1,2)<=0)||(user_array_2(cnt_1,2)>=area_y))
                    tmp_angle=2*pi*rand();  %Generate a random angle
                    tmp_radius=abs(normrnd(0,10));
                    user_array_2(cnt_1,1)=(tmp_radius+20)*cos(tmp_angle)+50;
                    user_array_2(cnt_1,2)=(tmp_radius+20)*sin(tmp_angle)+50;
                end
            end
            
            %Generate the background user
            for cnt_1=1001:1:2000
                while((user_array_2(cnt_1,1)<=0)||(user_array_2(cnt_1,1)>=area_x)||(user_array_2(cnt_1,2)<=0)||(user_array_2(cnt_1,2)>=area_y))
                    user_array_2(cnt_1,1)=area_x*rand();
                    user_array_2(cnt_1,2)=area_y*rand();
                end
            end
    end
    indic_user_changed=1;
else
    %If no new user distribution is generated
    indic_user_changed=0;
end
end