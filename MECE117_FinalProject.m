%Clare McMahon MECE 117 Boedo Wed/Fri Final Project Air Hockey


clear
clc
close all

%the  globals
global KeyID
global    puck b1Cx b1Cy b2Cx b2Cy pCx pCy
      

%intializing some variables
h=0;
a=0;
Xs=0 ;
Ys=0;
t=0;
dt=0.01;
pxs=0;
pys=100;
xi=10;
yi=10;
pyi=10;
pxi=10;
Vp2y=60;
Vp2x=40;
puckxpos=150;
puckypos=225;

%calling function to create the rink and score board
[player1,player2]= rink;
[scorebox1, scorebox2,timebox]=scoreboard(a,h);



%the while loop to keep the puck running
while t<60
   
    %calling the function

    
%user blocker 1 nanc two setting
    set(player1, "XData", b1Cx+Xs, "YData", b1Cy+Ys)
    set(player2,'XData',b2Cx+pxs,"YData",b2Cy+pys)

    %the function for the blockers
    [Xs,Ys,pxs,pys]=blockermovement(xi,yi,pxi,pyi,Xs,Ys,pxs,pys);
   

    %for the positions for the calling physics functions
  posx1=b1Cx(1)-20+Xs;
  posy1=b1Cy(1)+Ys;
  posx2=b2Cx(1)-20+pxs;
  posy2=b2Cy(1)+pys;
  

%the score board thing
    timebox.String=num2str(60-t,'%0.2f');
    t=t+dt;
    pause(0.01)

%so it stops going out of bounds like a stupid puck
if puckxpos>=285
    puckxpos=285;
end
if puckxpos<=15
    puckxpos=15;
end
if puckypos<=15
    puckypos=15;
end
if puckypos >=435
    puckypos=435;
end


  %if statement for puck to bounce
    if puckxpos>=285 || puckxpos<=15
      %so now just create the velocity to be negative
        Vp2x=Vp2x*-1;
     

    end
  if puckypos<=15 || puckypos>=435
       %so now just create the velocity to be negative  
      Vp2y=Vp2y*-1;
      
  
  end
  
  %calc position with velocity
    puckxpos=puckxpos+Vp2x*dt;
    puckypos=puckypos+Vp2y*dt;



    
    %the physics function for player 1
    if sqrt((puckxpos-posx1)^2+(puckypos-posy1)^2)<=(15+20)     % Bottom
        [Vp2x,Vp2y,puckxpos,puckypos] =puckmovement(posx1,posy1,Vp2y,Vp2x,puckxpos,puckypos);
    end

    %physics for player 2
    if sqrt(((puckxpos-posx2)^2)+(puckypos-posy2)^2)<=(15+20)       % Top
        [Vp2x,Vp2y,puckxpos,puckypos] =puckmovement(posx2,posy2,Vp2y,Vp2x,puckxpos,puckypos);
    end

   
  

 %we calculating
  set(puck,'XData',pCx+puckxpos,'Ydata',pCy+puckypos)
  
%the score keeper
[Vp2x,Vp2y,puckxpos,puckypos,a,h]= goal(puckxpos,puckypos,Vp2x,Vp2y,scorebox1, scorebox2,a,h);

end



%so to announce who wins

if a>h
    %now create a giant box that says THE AWAY TEAM WINS
    winner=uicontrol('Style','text','String',"THE AWAY TEAM WINS",'Position',[150, 150, 250, 350],'ForegroundColor','m','FontSize',50);
end

if h>a
    %now to say home team wins
    winner=uicontrol('Style','text','String',"THE HOME TEAM WINS",'Position',[150, 150, 250, 350],'ForegroundColor','m','FontSize',50);
end

if h==a
    %now say tie
    winner=uicontrol('Style','text','String',"ITS A TIE",'Position',[150, 150, 200, 350],'ForegroundColor','m','FontSize',50);
end





%the function for rink
function[player1,player2]= rink()
global b1Cx b1Cy b2Cx b2Cy
global puck pCx pCy
%creating the rink
hockey = figure('units','normalized','outerposition',[0 0 1 1]);
hold on
%so the axis isnt annoying

axis off

axis equal
xp=150;
yp=225;
%dimensions of rink and patching
x=[0,300,300,0];
y=[0,0,450,450];
court=patch(x,y,'w');
%a line
c7 =[0,300,300,0];
c8=[215,215,235,235];
line=patch(c7,c8,'g');

%my attempt at a cirlce of rink
%issue with the circle is idk how to move it
%NEED SOME HELPPPPPPPPPPPPPPPPPPP
rad=50;
th=linspace(0,2*pi);
liv=rad*cos(th)+150;
claire=rad*sin(th)+225;
circle=patch(liv,claire,'g');

%creating the puck
rad=15;
th=linspace(0,2*pi);
pCx=rad*cos(th);
pCy=rad*sin(th);
puck=patch(pCx,pCy,'k');

%creating goal 1
goal1x=[100,100,200,200];
goal1y=[450,440,440,450];
goal1=patch(goal1x,goal1y,'g');

% %creating goal 2
goal2x=[100,100,200,200];
goal2y=[0,10,10,0];
goal2=patch(goal2x,goal2y,'g');
axis manual

% %creating the blocker 1
rad2=20;
th=linspace(0,2*pi);
b1Cx=rad2*cos(th)+150;
b1Cy=rad2*sin(th);
% global player1
player1=patch(b1Cx,b1Cy,'m');

%creating the blocker 2
rad=20;
th=linspace(0,2*pi);
b2Cx=rad*cos(th)+150;
b2Cy=rad*sin(th)+430;
% global player2
player2=patch(b2Cx,b2Cy,'m');

set(hockey, 'KeyPressFcn', @KeyDownListener)

end

%the function for the score board
function[scorebox1, scorebox2,timebox]= scoreboard(a,h)

scorebox1=uicontrol("Style","edit","Position",[1100,500,150,100],'Enable','inactive',"FontSize",30);
scorebox2=uicontrol("Style","edit","Position",[1300,500,150,100],'Enable','inactive',"FontSize",30);
home=uicontrol('Style','text','String',"HOME",'Position',[1100, 605, 150, 20],'ForegroundColor','m','FontSize',15);
away=uicontrol('Style','text','String',"AWAY",'Position',[1300, 605, 150, 20],'ForegroundColor','m','FontSize',15);
titly=uicontrol('Style','text','String',"SCORE",'Position',[1180, 650, 200, 50],'BackgroundColor','m','FontSize',25);
timebox=uicontrol("Style","edit","Position",[1200,200,150,100],'Enable','inactive','FontSize',20);
timtext=uicontrol('Style','text','String',"TIME",'Position',[1200, 310, 150, 20],'ForegroundColor','m','FontSize',15);
scorebox2.String=num2str(a,'%0.0f');
scorebox1.String=num2str(h,'%0.0f');

%the code for the directions
howto=uicontrol('Style','text','String',"How to Play",'Position',[150, 440, 250, 350],'ForegroundColor','m','FontSize',20);
keys1=uicontrol('Style','text','String',"Player 1 use up down left right arrows",'Position',[150, 400, 250, 350],'ForegroundColor','m','FontSize',10);
keys2=uicontrol('Style','text','String',"Player 2 use W S A D keys",'Position',[150, 380, 250, 350],'ForegroundColor','m','FontSize',10);
dir=uicontrol('Style','text','String',"Hit the puck into the goal and HAVE FUN!!",'Position',[150, 360, 250, 350],'ForegroundColor','m','FontSize',10);

end

% Key-press 'listener' function
function KeyDownListener(src, event)
global KeyID
KeyID = event.Key;
end

%blocker movement function
function[Xs,Ys,pxs,pys]=blockermovement(xi,yi,pxi,pyi,Xs,Ys,pxs,pys)
global KeyID 
%to do the key thing for player one
  %player 1 blocker key listener
    if (strcmp(KeyID,'leftarrow'))
           Xs = Xs - xi; 
          KeyID = ' '; 
          
    elseif (strcmp(KeyID,'rightarrow'))
           Xs = Xs + xi; 
          KeyID = ' '; 
          
    elseif (strcmp(KeyID,'uparrow'))
          Ys = Ys + yi; 
          KeyID = ' '; 
          
    elseif (strcmp(KeyID,'downarrow'))
           Ys = Ys - yi; 
          KeyID = ' '; 
          
    end

   %to do the thing for player 2
    if (strcmp(KeyID,'a'))
           pxs = pxs - pxi; 
          KeyID = ' '; 
         
    elseif (strcmp(KeyID,'d'))
           pxs = pxs + pxi; 
          KeyID = ' '; 
          
    elseif (strcmp(KeyID,'w'))
          pys = pys + pyi; 
          KeyID = ' ';
          
    elseif (strcmp(KeyID,'s'))
           pys = pys - pyi; 
          KeyID = ' ';
          
    end

    %to mkae sure player 1 doesnt go out of bounds
    %dont forget to add radius so it bounces
     if Xs>=130
         Xs=150-20;
     end
     if Xs<=-130
         Xs=-130;
     end
     if Ys>=205
         Ys=225-20;
     end
    if Ys<=20
         Ys=0+20;
     end

    %to make sure player 2 doesnt go out of bounds
    %dont forget to add radius so it bounces
     if pxs<=-130
         pxs=-130;
     end
     if pxs>=130
         pxs=130;
     end
     if pys<=-185
         pys=-185;
     end
    if pys>=0
         pys=0;
    end
end

%goal function to finish once physics is done
function[Vp2x,Vp2y,puckxpos,puckypos,a,h] =goal(puckxpos,puckypos,Vp2x,Vp2y,scorebox1, scorebox2,a,h)
%finish this part once you do physics
    %call them globals
    global  puck pCx pCy 

    %if a goal is scored by player 1
    if puckxpos>=100 && puckxpos<=200 
       if  puckypos>=430
        %there is a goal for player 1
        puckxpos=150;
        puckypos=225;
        set(puck,'XData',pCx+puckxpos,'YData',pCy+puckypos)
      
        
        %to increment score
        h=h+1;
        %to display score
        scorebox1.String=num2str(h,'%0.0f');
       
        %to change the velocity back to intiall
        Vp2x=50;
        Vp2y=30;


       end
    end
    
 
    
    if puckxpos>=100 && puckxpos<=200
        if  puckypos<=30
        %there is a goal for player 2
        puckxpos=150;
        puckypos=225;
        set(puck,'XData',pCx+puckxpos,'YData',pCy+puckypos)
        pause(0.1)
        %to display
          a=a+1;
        scorebox2.String=num2str(a,'%0.0f');
   
        %to change the velocity back to intiall but its negative so its a
        %make it take it type of game
        Vp2x=-10;
        Vp2y=-10;

        end
    end
   
puckxpos;
puckypos; 
end
 

%the physics function
function[Vp2x,Vp2y,pxs2,pys2] =puckmovement(X,Y,Vp2y,Vp2x,pxs2,pys2)

mp=1;
mb=10;

   
        %intializing angles
        %alpha=atan2(Vy,Vx);
        theta=-atan2(Y-pys2,X-pxs2);
        beta=atan2(Vp2y,Vp2x);
        vp=sqrt(Vp2y^2+Vp2x^2);
       V=25;

%         %intializing positions
        pxs2=X-(20+15)*cos(theta);
        pys2=Y+(20+15)*sin(theta);
        
        %some fun velocities
        Vb1n=-V;
        Vb1s=0;
        Vp1n=vp*cos(theta+beta);
        Vp1s=vp*sin(theta*beta);

        %momentum calc
        p1n=mp*Vp1n+mb*Vb1n;

        %kenetic energy calc
        KE1=(1/2)*mp*(vp^2)+(1/2)*mb*(V)^2;

        %finding values for quadratic equations
        a=(mp^2+mp*mb)/mb;
        b=-(2*p1n*mp)/mb;
        c=((p1n^2)/mb)+mp*(Vp1s^2)+mb*(Vb1s^2)-2*KE1;

        %calculating new velocitie of puck
        %ok so we need if statements and calc both points and then from
        Veloci1=(-b+sqrt(b^2-4*a*c))/(2*a);
        Veloci2=(-b-sqrt(b^2-4*a*c))/(2*a);
        %now for the if statements
    
                if Veloci2<Veloci1
                    Vp2n=real(Veloci2);
               
                else
                    Vp2n=real(Veloci1);
                end


%         %Quick little thing that i forgot
         Vp2s=Vp1s;
       
        %now to calc the final velocity
        Vp2=sqrt(Vp2n^2+Vp2s^2);
        beta2=atan2(Vp2s,Vp2n)-theta;
      
      
        %now we convert back
        Vp2x=Vp2*cos(beta2);
        Vp2y=Vp2*sin(beta2);

        %now i definitely have to do something with the patch but idk what
        %THIS IS WHERE I LEFT OFF
        %update patch will be in while loop
     

end
