%Kabat McMahon Applications Lab 
%Lab 5, Rev 1
clear 
clc

%Initial Values to be converted to metric
b1=40; %Ball diameter in mm, tol is +/-0.1 in
m1=2.75; %Ball mass in grams, tol is +/- 0.05 in
od1=1.9; %Pipe outer diamter in in, tol is +/- 0.01 in
id1=1.590; %Pipe inner diameter in in, tol is +/- 0.02 in
l1=60; %Pipe length in in, tol is +/-0.5 in
c=1;

% Conversion Calculation
ball_mass=m1*0.001; %Ball mass in kg
b=b1*0.001; %Ball diameter in meters
od=od1/39.37; %Pipe outer diamter in meters
id=id1/39.37; %Pipe inner diamter in meters
length=l1/39.37; %Pipe length in meters

%Constants
air_density=1.293; %kg/m^3
Kent=0.78; %Bernouli Correction Coefficient
pressure_rupt = 300000; %Rupture pressure of tape pa
pressure_atm=101325; %Atmospheric pressure in Pa
dt=0.00005; %Change of time used in Euler's Method, in seconds

%Area Calculations
ball_area=pi*(b/2)^2; %Cross sectional area of ball m^2
pipe_area=pi*(id/2)^2; %Inner cross sectional area of pipe in m^2

%Initial Volume pipe calculations
volume_1=length*pipe_area; %Intial volume in m^3

%Delta Values
mass_tol=5*(10^-5);%kg
ball_mass_ub=ball_mass+mass_tol;%kg
ball_mass_lb=ball_mass-mass_tol;%kg
ball_di_tol = 0.001;%meters
ball_ub =b+ball_di_tol;%meters
ball_lb=b-ball_di_tol;%meters
ball_area_ub=pi*(ball_ub/2)^2;%meters squared 
ball_area_lb=pi*(ball_lb/2)^2; %meters squared
length_tol=0.0254;%meters
length_ub=length+length_tol;%meters
length_lb=length-length_tol;%meters
volume_1_l_ub=length_ub*pipe_area;%meters cubed
volume_1_l_lb=length_lb*pipe_area;%meters cubed
pipe_tol_ub=0.000254; %meters
pipe_tol_lb=0.000508;%meters
pipe_di_ub= pipe_tol_ub+id;%meters
pipe_di_lb= id-pipe_tol_lb; %meters
pipe_area_ub=pi*(pipe_di_ub/2)^2;%meters squared
pipe_area_lb=pi*(pipe_di_lb/2)^2;%meters squared
volume_1_pa_ub=length*pipe_area_ub;%meters cubed
volume_1_pa_lb=length*pipe_area_lb;%meters cubed
pressure_rupt_ub = 400000;
pressure_rupt_lb = 200000;

%Initialize Arrays
n_pts = 100000;
time = NaN(n_pts,1);
velocity = NaN(n_pts,5);
distance = NaN(n_pts,5);
fv = NaN(5,1); %final velocity array to create final velocity and pressure plot
fvub=NaN(5,1);%upper bound velocity vector
fvlb=NaN(5,1);%lower bound velocity vector
pressure_downstream = NaN(n_pts,5);%pressure vector
acceleration = NaN(n_pts,5);%acceleration vector

%Delta arrays initializing for calculations
velocity_mass_ub = NaN(n_pts,5);
velocity_length_ub = NaN(n_pts,5);
velocity_pipe_area_ub = NaN(n_pts,5);
velocity_ball_area_ub = NaN(n_pts,5);
velocity_mass_lb = NaN(n_pts,5);
velocity_length_lb = NaN(n_pts,5);
velocity_pipe_area_lb = NaN(n_pts,5);
velocity_ball_area_lb = NaN(n_pts,5);
velocity_pr_lb = NaN(n_pts,5);
velocity_pr_ub = NaN(n_pts,5);
pressure_downstream_m_ub = NaN(n_pts,1);
pressure_downstream_l_ub = NaN(n_pts,1);
pressure_downstream_pa_ub = NaN(n_pts,1);
pressure_downstream_ba_ub = NaN(n_pts,1);
pressure_downstream_m_lb = NaN(n_pts,1);
pressure_downstream_l_lb = NaN(n_pts,1);
pressure_downstream_pa_lb = NaN(n_pts,1);
pressure_downstream_ba_lb = NaN(n_pts,1);
pressure_downstream_pr_ub = NaN(n_pts,1);
pressure_downstream_pr_lb = NaN(n_pts,1);
distance_m_ub = NaN(n_pts,1);
distance_l_ub = NaN(n_pts,1);
distance_pa_ub = NaN(n_pts,1);
distance_ba_ub = NaN(n_pts,1);
distance_m_lb = NaN(n_pts,1);
distance_l_lb = NaN(n_pts,1);
distance_pa_lb = NaN(n_pts,1);
distance_ba_lb = NaN(n_pts,1);
distance_pr_ub = NaN(n_pts,1);
distance_pr_lb = NaN(n_pts,1);
acceleration_delta = NaN(n_pts,5);
time_m_ub = NaN(n_pts,1);
time_l_ub = NaN(n_pts,1);
time_pa_ub = NaN(n_pts,1);
time_ba_ub = NaN(n_pts,1);
time_m_lb = NaN(n_pts,1);
time_l_lb = NaN(n_pts,1);
time_pa_lb = NaN(n_pts,1);
time_ba_lb = NaN(n_pts,1);
time_pr_lb = NaN(n_pts,1);
time_pr_ub = NaN(n_pts,1);

for loopcount=2:2:10

%Initial Values
velocity(1,c)=0; %Inital Velocity, m/s
distance(1,c)=0; %Starting distance of ball in tube, m
time(1)=0; %Initial time, s
n=1; %Increment counter starting point
TR=0; %True false if tape ruptured

%Starting the counter for while loops
m_ub=1;
ba_ub=1;
pa_ub=1;
l_ub=1;
m_lb=1;
ba_lb=1;
pa_lb=1;
l_lb=1;
pr_ub=1;
pr_lb=1;


%Initializing distance for delta calcs
distance_m_ub(1) = 0; %meters
distance_l_ub (1)= 0;%meters
distance_pa_ub(1) = 0;%meters
distance_ba_ub(1) = 0;%meters
distance_m_lb(1) = 0;%meters
distance_l_lb (1)= 0;%meters
distance_pa_lb(1) = 0;%meters
distance_ba_lb(1) = 0;%meters
distance_pr_lb(1) = 0;%meters
distance_pr_ub(1) = 0;%meters

%INitilizing velocity for delta calcs
velocity_mass_ub (1,c)= 0; %m/s
velocity_length_ub (1,c)= 0;%m/s
velocity_pipe_area_ub (1,c)= 0;%m/s
velocity_ball_area_ub(1,c)= 0;%m/s
velocity_mass_lb (1,c)= 0;%m/s
velocity_length_lb (1,c)= 0;%m/s
velocity_pipe_area_lb (1,c)= 0;%m/s
velocity_ball_area_lb(1,c)= 0;%m/s
velocity_pr_lb (1,c)= 0;%m/s
velocity_pr_ub(1,c)= 0;%m/s

%Delta time arrays
time_m_ub(1)=0; %seconds
time_l_ub(1)=0;%seconds
time_pa_ub(1)=0;%seconds
time_ba_ub(1)=0;%seconds
time_m_lb(1)=0;%seconds
time_l_lb(1)=0;%seconds
time_pa_lb(1)=0;%seconds
time_ba_lb(1)=0;%seconds
time_pr_lb(1)=0;%seconds
time_pr_ub(1)=0;%seconds

%Input values
%p1pa=input("What is the launch pressure in kPa? ");%The value the pressure vaccuum gets to when the ball is launch
p1pa=loopcount;
pressure_downstream(1,c)=p1pa*1000; %Convert Kpa to Pa for calculations

%CReating the first downstream pressur evalue for delta calcs
pressure_downstream_m_ub(1,c)=p1pa*1000; %kpa
pressure_downstream_l_ub(1,c)=p1pa*1000;%kpa
pressure_downstream_pa_ub (1,c)=p1pa*1000;%kpa
pressure_downstream_ba_ub (1,c)=p1pa*1000;%kpa
pressure_downstream_m_lb(1,c)=p1pa*1000;%kpa
pressure_downstream_l_lb(1,c)=p1pa*1000;%kpa
pressure_downstream_pa_lb (1,c)=p1pa*1000;%kpa
pressure_downstream_ba_lb (1,c)=p1pa*1000;%kpa
pressure_downstream_pr_lb (1,c)=p1pa*1000;%kpa
pressure_downstream_pr_ub (1,c)=p1pa*1000;%kpa

%While loop used to continously calculate velocity in Euler's
%Once the ball travels the length of the pipe the loop stops because that is the exit velocity

while length>=distance(n,c)
    n=n+1; %add increment
   
   %Calculation of velocity
   [velocity(n,c),acceleration(n-1,c),pressure_downstream(n,c),TR,distance(n,c)]= calculations(velocity(n-1,c),dt,ball_area,pressure_downstream(1,c),volume_1,pressure_atm,air_density,pressure_rupt,TR,Kent,distance(n-1,c),length,pipe_area,ball_mass);
    %velocity is in m/s
   time(n)=time(n-1)+dt; %adding values to the time array in seconds
    
end

TR=0;

%upper bound mass while loop
while length>=distance_m_ub(m_ub)
    m_ub=m_ub+1;
  
    %Calculation of velcoity with change of mass
   [velocity_mass_ub(m_ub,c),acceleration_delta(m_ub-1,c),pressure_downstream_m_ub(m_ub,c),TR,distance_m_ub(m_ub)]= calculations(velocity_mass_ub(m_ub-1,c),dt,ball_area,pressure_downstream_m_ub(1,c),volume_1,pressure_atm,air_density,pressure_rupt,TR,Kent,distance_m_ub(m_ub-1),length,pipe_area,ball_mass_ub);
    %velocity is in m/s
   time_m_ub(m_ub)=time_m_ub(m_ub-1)+dt; %seconds
end
TR=0;

%lower bound mass while loop
while length>=distance_m_lb(m_lb)
    m_lb=m_lb+1;
  
    %Calculation of velcoity with change of mass
   [velocity_mass_lb(m_lb,c),acceleration_delta(m_lb-1,c),pressure_downstream_m_ub(m_lb,c),TR,distance_m_lb(m_lb)]= calculations(velocity_mass_lb(m_lb-1,c),dt,ball_area,pressure_downstream_m_lb(1,c),volume_1,pressure_atm,air_density,pressure_rupt,TR,Kent,distance_m_lb(m_lb-1),length,pipe_area,ball_mass_lb);
    %velocity is in m/s
   time_m_lb(m_lb)=time_m_ub(m_lb-1)+dt; %in seconds
end

TR=0;

%while loop for upper ball diameter
while length>=distance_ba_ub(ba_ub)
    
   ba_ub=ba_ub+1;
   %Calculation of velocity with change of ball diameter
   [velocity_ball_area_ub(ba_ub,c),acceleration_delta(ba_ub-1,c),pressure_downstream_ba_ub(ba_ub,c),TR,distance_ba_ub(ba_ub)]= calculations(velocity_ball_area_ub(ba_ub-1,c),dt,ball_area_ub,pressure_downstream_ba_ub(1,c),volume_1,pressure_atm,air_density,pressure_rupt,TR,Kent,distance_ba_ub(ba_ub-1),length,pipe_area,ball_mass);
    %velocity is in m/s
   time_ba_ub(ba_ub)=time_ba_ub(ba_ub-1)+dt; %seconds
end


TR=0;

%while loop for lower ball diameter
while length>=distance_ba_lb(ba_lb)
    
   ba_lb=ba_lb+1;
   %Calculation of velocity with change of ball diameter
   [velocity_ball_area_lb(ba_lb,c),acceleration_delta(ba_lb-1,c),pressure_downstream_ba_lb(ba_lb,c),TR,distance_ba_lb(ba_lb)]= calculations(velocity_ball_area_lb(ba_lb-1,c),dt,ball_area_lb,pressure_downstream_ba_lb(1,c),volume_1,pressure_atm,air_density,pressure_rupt,TR,Kent,distance_ba_lb(ba_lb-1),length,pipe_area,ball_mass);
    %velocity is in m/s
   time_ba_lb(ba_lb)=time_ba_lb(ba_lb-1)+dt; %seconds
end

TR=0;

%while loop for upper pipe area
while length>=distance_pa_ub(pa_ub)
   pa_ub=pa_ub+1;

   %Calculation of velocity with change in pipe area
  [velocity_pipe_area_ub(pa_ub,c),acceleration_delta(pa_ub-1,c),pressure_downstream_pa_ub(pa_ub,c),TR,distance_pa_ub(pa_ub)]= calculations(velocity_pipe_area_ub(pa_ub-1,c),dt,ball_area,pressure_downstream_pa_ub(1,c),volume_1_pa_ub,pressure_atm,air_density,pressure_rupt,TR,Kent,distance_pa_ub(pa_ub-1),length,pipe_area_ub,ball_mass);
 %velocity is in m/s
  time_pa_ub(pa_ub)=time_pa_ub(pa_ub-1)+dt; %seconds
end

TR=0;

%while loop for lower pipe area
while length>=distance_pa_lb(pa_lb)
   pa_lb=pa_lb+1;

   %Calculation of velocity with change in pipe area
  [velocity_pipe_area_lb(pa_lb,c),acceleration_delta(pa_lb-1,c),pressure_downstream_pa_lb(pa_lb,c),TR,distance_pa_lb(pa_lb)]= calculations(velocity_pipe_area_lb(pa_lb-1,c),dt,ball_area,pressure_downstream_pa_lb(1,c),volume_1_pa_lb,pressure_atm,air_density,pressure_rupt,TR,Kent,distance_pa_lb(pa_lb-1),length,pipe_area_lb,ball_mass);
 %velocity is in m/s
  time_pa_lb(pa_ub)=time_pa_lb(pa_lb-1)+dt; %seconds
end

TR=0;

%while loop for upper length
while length_ub>=distance_l_ub(l_ub)
    l_ub=l_ub+1;

   %calculation of velocity with change in pipe length
    [velocity_length_ub(l_ub,c),acceleration_delta(l_ub-1,c),pressure_downstream_l_ub(l_ub,c),TR,distance_l_ub(l_ub)]= calculations(velocity_length_ub(l_ub-1,c),dt,ball_area,pressure_downstream_l_ub(1,c),volume_1_l_ub,pressure_atm,air_density,pressure_rupt,TR,Kent,distance_l_ub(l_ub-1),length_ub,pipe_area,ball_mass);
   %velocity is in m/s
    time_l_ub(l_ub)=time(l_ub-1)+dt; %adding values to the time array in seconds
    
end

TR=0;

%while loop for lower pipe length
while length_lb>=distance_l_lb(l_lb)
    l_lb=l_lb+1;

   %calculation of velocity with change in pipe length
    [velocity_length_lb(l_lb,c),acceleration_delta(l_lb-1,c),pressure_downstream_l_lb(l_lb,c),TR,distance_l_lb(l_lb)]= calculations(velocity_length_lb(l_lb-1,c),dt,ball_area,pressure_downstream_l_lb(1,c),volume_1_l_lb,pressure_atm,air_density,pressure_rupt,TR,Kent,distance_l_lb(l_lb-1),length_lb,pipe_area,ball_mass);
   %velocity is in m/s
    time_l_lb(l_lb)=time(l_lb-1)+dt; %adding values to the time array in seconds
    
end


TR=0;
%Pressure Rupt lower bound while loop
while length>=distance_pr_lb(pr_lb)
    pr_lb=pr_lb+1;

   %calculation of velocity with change in pipe length
    [velocity_pr_lb(pr_lb,c),acceleration_delta(pr_lb-1,c),pressure_downstream_pr_lb(pr_lb,c),TR,distance_pr_lb(pr_lb)]= calculations(velocity_pr_lb(pr_lb-1,c),dt,ball_area,pressure_downstream_pr_lb(1,c),volume_1,pressure_atm,air_density,pressure_rupt_lb,TR,Kent,distance_pr_lb(pr_lb-1),length,pipe_area,ball_mass);
   %velocity is in m/s
    time_pr_lb(pr_lb)=time(pr_lb-1)+dt; %adding values to the time array in seconds
    
end

TR=0;
%Pressure Rupt upper bound while loop
while length>=distance_pr_ub(pr_ub)
    pr_ub=pr_ub+1;

   %calculation of velocity with change in pipe length
    [velocity_pr_ub(pr_ub,c),acceleration_delta(pr_ub-1,c),pressure_downstream_pr_ub(pr_ub,c),TR,distance_pr_ub(pr_ub)]= calculations(velocity_pr_ub(pr_ub-1,c),dt,ball_area,pressure_downstream_pr_ub(1,c),volume_1,pressure_atm,air_density,pressure_rupt_ub,TR,Kent,distance_pr_ub(pr_ub-1),length,pipe_area,ball_mass);
   %velocity is in m/s
    time_pr_lb(pr_lb)=time(pr_lb-1)+dt; %adding values to the time array in seconds
    
end


%Delta Calculations
upper_delta=sqrt( (velocity(n,c)-velocity_mass_ub(m_ub,c))^(2) + (velocity(n,c)-velocity_ball_area_ub(ba_ub,c))^(2) + (velocity(n,c)-velocity_length_ub(l_ub,c))^(2) + (velocity(n,c)-velocity_pipe_area_ub(pa_ub,c))^(2)+(velocity(n,c)-velocity_pr_ub(pr_ub,c))^(2));
lower_delta=sqrt( (velocity(n,c)-velocity_mass_lb(m_lb,c))^(2) + (velocity(n,c)-velocity_ball_area_lb(ba_lb,c))^(2) + (velocity(n,c)-velocity_length_lb(l_lb,c))^(2) + (velocity(n,c)-velocity_pipe_area_lb(pa_lb,c))^(2)+(velocity(n,c)-velocity_pr_ub(pr_ub,c))^(2));
%delta values are in m/s

%Output Values
fprintf('\nVaccuum Pressure is %1.0f Kpa\n',loopcount);
fprintf('Final Velocity is %5.3f m/s \n',velocity(n,c)); 
fprintf('Final time is %5.3f ms \n',(time(n)*1000));
fprintf('Final count of cycles is %1.0f\n',n);
fprintf('Upper Bound Velocity Delta is %1.5f\n',upper_delta);
fprintf('Lower Bound Velocity Delta is %1.5f\n',lower_delta);


fv(c)=velocity(n,c);
fvub(c)=velocity(n,c)+upper_delta;
fvlb(c)=velocity(n,c)-lower_delta;
c=c+1;

end %this is end of for loop

%Pressure vs Final Velocity figure
p=[2;4;6;8;10]; %array for pressure in KPA

%Experimental data point
%The average pressure and velocity from the experimental values
%approx 3 kpa trials average values
avep3=2.986; %pressure in kpa
avev3=179.63;%velocity in m/s
%approx 10 kpa trials average values
avep10=9.714; %pressure in kpa
avev10=152.66;%velocity in m/s

%error values
errorp=1; %pressure tolerance in kpa
sys=11.5;%systematic errir in m/s
ran3=23.85/sqrt(5);%random error for 3kpa trials in m/s
ran10=27.85/sqrt(5);%random error for 10 kpa trials in m/s
errorv3=sqrt(sys^2+ran3^2); %summing random and systematic error in m/s for 3 kpa trials
errorv10=sqrt(sys^2+ran10^2);%summing random and systematic error in m/s for 10 kpa trials

%plotting final velocity and upper and lower bounds for velocity at each
%pressure values
figure(1)
plot(p,fv,'-m')
hold on
plot(p,fvub,'-b')
plot(p,fvlb,'-g')

%Plotting experimental values
%with error bars 
errorbar(avep3,avev3,errorv3,errorv3,errorp,errorp,'ok')
errorbar(avep10,avev10,errorv10,errorv10,errorp,errorp,'oc')

%Labeling plot
title("Vaccuum Pressure vs Final Velocity")
legend('Calculated Values','Upper Limit','Lower Limit','Experimental Value for 3 KPa','Experimental Value for 10 KPa')
xlabel("Pressure (KPa)")
ylabel("Exit Velocity (m/s)")





%Pressure Function
function [pressure_downstream_output,pressure_upstream_output,TR]= pressure_calc(pressure_downstream_input,volume_1,volume_2,pressure_atm,velocity_input,air_density,pressure_rupt,TR,Kent,distance,length)
f=0.02; %This is the friction factor estimated and calculated from the moody diagram

friction_pressure=f*(distance/length)*0.5*air_density*velocity_input^2;
pressure_upstream_output=pressure_atm-(0.5*air_density*(velocity_input)^2)-(Kent*0.5*air_density*(velocity_input)^2)-friction_pressure; %add equations to account for bernoulim inlet for atmospheric pressure    
   
    if TR == 0
        pressure_downstream_output=(pressure_downstream_input)*(volume_1/volume_2)^1.4; %calculates the downstream pressure
        
        if pressure_downstream_output >= pressure_rupt
            TR=1;
        end

    else
        pressure_downstream_output = pressure_atm;
    end
end




function[velocity_output,acceleration,pressure_downstream_output,TR,distance_output]=calculations(velocity_input,dt,ball_area,pressure_downstream_input,volume_1,pressure_atm,air_density,pressure_rupt,TR,Kent,distance,length,pipe_area,ball_mass)
    
    volume_2=(length-distance)*pipe_area; %The downstream volume of the tube after each iteration, in m^3
    air_mass=volume_2*air_density; %finding air mass for total mass calcs
    total_mass=air_mass+ball_mass; %for mass for acceleration calc
    
    %pressure calculations
    [pressure_downstream_output,pressure_upstream_output,TR]= pressure_calc(pressure_downstream_input,volume_1,volume_2,pressure_atm,velocity_input,air_density,pressure_rupt,TR,Kent,distance,length);
   
    %Acceleration and vel calcs and distance
    acceleration=((pressure_upstream_output*ball_area)-(pressure_downstream_output*ball_area))/total_mass; %acceleration calculation, m/s^2
    velocity_output=velocity_input+acceleration*dt; %velocity calculations, m/s

    distance_output=distance+velocity_output*dt;

end






