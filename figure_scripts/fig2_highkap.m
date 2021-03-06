% Script to plot column of time series for Demetri's paper
% Version using lag1-AC

clear
close all

% Import data files

sim_data_lin = importdata('sim_data/simdata_highkap_lin.txt');
sim_data_tri = importdata('sim_data/simdata_highkap_tri.txt');

wcrit = 5e-4;

figure(1)

% Specifications
lw = 1.2; % line width
nudgeup = 0.01; % shift figures up to reduce vertical space
nudgedown = 0.015; % shift all figures down to space out bif plot
fs = 9; % font size for axes
fsl = 8; % font size for legend

% Set figure size
set(gcf,'Units','Centimeters')
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) 8 20],'PaperPositionMode','Auto',...
    'PaperUnits','Centimeters','PaperSize',[8.5 17],...
    'PaperPosition',[.25 -1.7 8 20]) %[left bottom width height]


ax1 = subplot(7,1,1); % plot 1
ax2 = subplot(7,1,2); % plot 2
ax3 = subplot(7,1,3); % plot 3
ax4 = subplot(7,1,4); % plot 4
ax5 = subplot(7,1,5); % plot 5
ax6 = subplot(7,1,6); % plot 6
ax7 = subplot(7,1,7); % plot 7


% Reduce vertical spacing between plots
p = get(ax2, 'pos');
p(2) = p(2) - 0.02;
set(ax2,'pos',p);

p = get(ax3, 'pos');
p(2) = p(2) -nudgedown + nudgeup;
set(ax3,'pos',p);

p = get(ax4, 'pos');
p(2) = p(2) -nudgedown + 2* nudgeup;
set(ax4,'pos',p);

p = get(ax5, 'pos');
p(2) = p(2) -nudgedown + 3*nudgeup;
set(ax5,'pos',p);

p = get(ax6, 'pos');
p(2) = p(2) -nudgedown + 4*nudgeup;
set(ax6,'pos',p);

p = get(ax7, 'pos');
p(2) = p(2) -nudgedown + 5*nudgeup;
set(ax7,'pos',p);

% figure label position
labx = 0.02;
laby = 0.87;



%------------------------------------------------------------
% plot 1 - bifurcation diagram
%------------------------------------------------------------

% Properties
dw = 1e-6;      % Resolution
w_fin = 7e-4;   % Omega range

% Fixed parameter values for Measles - time unit years
u=1/50;                 % Birth - Death rate
R0=16;                  % R0 value
g=365/13;               % Recovery rate
b=R0*(g+u);             % Transmission rate

% Social parameters
d = 5e-4;

% Intersection points on bif plot
w_int1 = d;
w_int2 = d*(1-2/R0);
w_int3 = (u/b)*(R0-1) - d;

% Construct e1
w1f = 0:dw:w_int1;
w1s = w_int1:dw:w_fin;
e1f = w1f.^0;
e1s = w1s.^0;

% Construct e3
w3 = 0:dw:w_int1;
e3 = (1/2)*(1+w3/d);

% Construct e4
w4f = 0:dw:w_int3;
w4s = w_int3:dw:w_fin;
e4f = 0*w4f.^0;
e4s = 0*w4s.^0;

% Construct e5
w5 = w_int3:dw:w_int2;
e5 = (u*(1-1/R0) - (d+w5)*(u+g))/(u-2*d*(u+g));


% -------Make Plot-------------

subplot(ax1)
hold on

% Axes properties
axis([0,w_fin,-0.02,1])
set(gca,'FontSize',fs)
ylabp = get(gca,'YLabel'); % move y label
set(ylabp,'Position',get(ylabp,'Position')+[0.1e-4,0,0])
xlabp = get(gca,'XLabel'); % move x label
set(xlabp,'Position',get(xlabp,'Position')+[3.6e-4,0.29,0])
ylabel('Uptake')
xlabel('w\times10^{-4}')
ax = gca;
ax.XTick = [0,1e-4,2e-4,3e-4,4e-4,5e-4,6e-4];
ax.XTickLabel = {'0','1','2','3','4','5','6'};


% plot e1
plot(w1f,e1f,'Color','k','DisplayName','e1','LineWidth',lw)
plot(w1s,e1s,'--','Color','k','LineWidth',lw)

% plot e3
plot(w3,e3,'--','Color','k','DisplayName','e3','LineWidth',lw)

% plot e4
plot(w4f,e4f,'--','Color','k','DisplayName','e4','LineWidth',lw)
plot(w4s,e4s,'-','Color','k','LineWidth',lw)

% plot e5
plot(w5,e5,'--','Color','k','LineWidth',lw)


% subfigure label
text(labx,laby,'a','Units','normalized','FontWeight','bold','FontSize',fs)

hold off


%-------------------------
% Linear Increase Plots
%-------------------------


% chosen plot number
plot_num_lin = 34;

% time column
t = sim_data_lin(:,1);



%------------------------
% plot 2 - risk function
%------------------------

subplot(ax2)

plot(t,sim_data_lin(:,2),'Color','k','DisplayName','w(t)','LineWidth',lw)
axis([-inf,inf,0,7e-4])
set(gca,'xticklabel',[],'FontSize',fs,'YColor','k')

hold on
plot(t,ones(1,length(t))*wcrit,':k','DisplayName','wcrit','LineWidth',lw)

ylabp = get(gca,'YLabel'); % move y label to the left
set(ylabp,'Position',get(ylabp,'Position')-[2.5,0,0])
ylabel('Risk')


% legend
% legend('show','FontSize',fsl,'Location','southeast');

% subfigure label
text(labx,laby,'b','Units','normalized','FontWeight','bold','FontSize',fs)


hold off

%-----------------------------
% plot 3 - disease dynamics
%-----------------------------

subplot(ax3)

yyaxis left
plot(t,sim_data_lin(:,3*plot_num_lin+2),'b','LineWidth',lw)
axis([-inf,inf,0,1])
set(gca,'xticklabel',[],'FontSize',fs,'YColor','b')

ylabp = get(gca,'YLabel'); % move y label to the left
set(ylabp,'Position',get(ylabp,'Position')-[0,0,0])
ylabel('Uptake') % proportion of newborns getting vaccinated


yyaxis right
plot(t,sim_data_lin(:,3*plot_num_lin+1),'r','LineWidth',lw)
set(gca,'YColor','r')
axis([-inf,inf,0,6.2e-3])
% change ticks
ax = gca;
ax.YTick = [0,2e-3,4e-3,6e-3];
ax.YTickLabel = {'0','2','4','6'};

ylabp = get(gca,'YLabel'); % move y label to the left
set(ylabp,'Position',get(ylabp,'Position')-[2,0,0])
ylabel('Infected')

% base
text(100,7.2e-3,'\times10^{-3}','Color','r','FontSize',fs)

% subfigure label
text(labx,laby,'c','Units','normalized','FontWeight','bold','FontSize',fs)



%------------------------
% Plot 4 - lag 1 AC
%------------------------

% set up grid
subplot(ax4)



% Import data
ac_struct = importdata('ac_data/ac_highkap_lin.txt');
ac_temp = ac_struct.data;

% Work with data up to tcrit
    tcrit = 80;
    time_indices = ac_temp(:,1);
    temp = abs(time_indices-tcrit);
    [val,idx] = min(temp);
    ac = ac_temp(1:idx,:);


% Find mean and standard deviation
num_comps = size(ac,2);
ac_mean_lin = mean(ac(:,2:num_comps),2);
ac_deviation_lin = std(ac(:,2:num_comps),0,2);

% Stop plot at t=tcrit i.e where threshold is passed
time_indices = ac(:,1);

% Find Kendall Tau of mean ac (2dp)
[corMatrix,pvals] = corr([time_indices,ac_mean_lin],'type','Kendall');
ktau_lin = round(corMatrix(1,2),2);

% plot with shaded error bars
shadedErrorBar(time_indices,ac_mean_lin,ac_deviation_lin,'k'); 


% Plot range
xlow=0; xhigh=100; ylow=0.5; yhigh=0.9;
axis([xlow xhigh ylow yhigh ])

% Specifications
set(gca,'xticklabel',[],'FontSize',fs,'YColor','k')
% change ticks
ax = gca;
ax.YTick = [0.5 0.6,0.7,0.8];
ylabp = get(gca,'YLabel'); % move y label to the right
set(ylabp,'Position',get(ylabp,'Position')+[0.5,0,0])
ylabel('Lag-1 AC')

% Draw window arrow
xpos_arrow = [0.135,0.28];
ypos_arrow = [0.49,0.49];
xpos_text = 10;
ypos_text = 0.755; 

annotation('doublearrow',xpos_arrow,ypos_arrow,'LineWidth',0.3,...
    'Head1Width',5,'Head2Width',5,'Head1Style','vback2','Head2Style','vback2',...
    'Head1Length',5,'Head2Length',5)

% Kendall tau text
ktxt = ['\tau = ',num2str(ktau_lin,'%.2f')];
text(0.8,0.14,ktxt,'Units','normalized','FontSize',fs)

% Make sure axes are drawn on top of grahpics
set(gca,'Layer','top')


% subfigure label
text(labx,laby,'d','Units','normalized','FontWeight','bold','FontSize',fs)



%-------------------------
% Triangular function plots
%-------------------------

% chosen plot number
plot_num_tri = 5;


%-----------------------
% Plot 5 - risk function
%-----------------------

subplot(ax5)

plot(t,sim_data_tri(:,2),'Color','k','DisplayName','w(t)','LineWidth',lw)
axis([-inf,inf,0,7e-4])
set(gca,'xticklabel',[],'FontSize',fs,'YColor','k')

hold on

plot(t,ones(1,length(t))*wcrit,':k','DisplayName','wcrit','LineWidth',lw)

ylabp = get(gca,'YLabel'); % move y label to the left
set(ylabp,'Position',get(ylabp,'Position')-[2.5,0,0])
ylabel('Risk')

% legend
% legend('show','FontSize',fsl,'Location','southeast');

% subfigure label
text(labx,laby,'e','Units','normalized','FontWeight','bold','FontSize',fs)


hold off

%-----------------------------
% Plot 6 - disease dynamics
%-----------------------------

subplot(ax6)

yyaxis left
plot(t,sim_data_tri(:,3*plot_num_tri+2),'b','LineWidth',lw)
axis([-inf,inf,0.5,1])
set(gca,'xticklabel',[],'FontSize',fs,'YColor','b')

ylabp = get(gca,'YLabel'); % move y label to the left
set(ylabp,'Position',get(ylabp,'Position')-[0,0,0])
ylabel('Uptake') % proportion of newborns getting vaccinated

yyaxis right
plot(t,sim_data_tri(:,3*plot_num_tri+1),'r','LineWidth',lw)
set(gca,'YColor','r')
axis([-inf,inf,0,4e-3])
% change ticks
ax = gca;
ax.YTick = [0,2e-3,4e-3];
ax.YTickLabel = {'0','2','4'};

% base
text(100,4.7e-3,'\times10^{-3}','Color','r','FontSize',fs)

ylabp = get(gca,'YLabel'); % move y label to the right
set(ylabp,'Position',get(ylabp,'Position')-[2,0,0])
ylabel('Infected')

% subfigure label
text(labx,laby,'f','Units','normalized','FontWeight','bold','FontSize',fs)



%-------------------------------
% Plot 7 - lag-1 AC
%-------------------------------


% set up grid
subplot(ax7)

% Import data
ac_struct = importdata('ac_data/ac_highkap_tri.txt');
ac = ac_struct.data;

% Find mean and standard deviation
num_comps = size(ac,2);
ac_mean_tri = mean(ac(:,2:num_comps),2);
ac_deviation_tri = std(ac(:,2:num_comps),0,2);

% Find Kendall Tau of mean ac before and after peak
time_indices = ac(:,1);
[max_ac,max_index] = max(ac_mean_tri);
tpeak = time_indices(max_index);

% PreTau (2dp)
[corMatrix,pvals1] = corr([time_indices(1:max_index),ac_mean_tri(1:max_index)],'type','Kendall');
ktau_tri_pre = round(corMatrix(1,2),2);


[corMatrix,pvals2] = corr([time_indices(max_index:end),ac_mean_tri(max_index:end)],'type','Kendall');
ktau_tri_post = round(corMatrix(1,2),2);

% Plot with shaded error bars
shadedErrorBar(time_indices,ac_mean_tri,ac_deviation_tri,'k'); 
hold on

% Plot vertical line at tpeak
plot(tpeak*ones(1,1000),linspace(0.4,0.9,1000),':k','LineWidth',lw)

% Plot range
xlow=0; xhigh=100; ylow=0.4; yhigh=0.9;
axis([xlow xhigh ylow yhigh ])


% Axes Specifications
set(gca,'FontSize',fs,'YColor','k','XColor','k')
% change ticks
ax = gca;
ax.YTick = [0.4 0.5 0.6,0.7,0.8];

ylabp = get(gca,'YLabel'); % move y label to the right
set(ylabp,'Position',get(ylabp,'Position')+[0.5,0,0])
ylabel('Lag-1 AC')
xlabel('Time (years)')

% Draw window arrow
xpos_arrow = [0.135,0.28];
ypos_arrow = [0.155,0.155];
annotation('doublearrow',xpos_arrow,ypos_arrow,'LineWidth',0.3,...
    'Head1Width',5,'Head2Width',5,'Head1Style','vback2','Head2Style','vback2',...
    'Head1Length',5,'Head2Length',5)

% Kendall tau text
ktxt_pre = ['\tau = ',num2str(ktau_tri_pre,'%.2f')];
ktxt_post = ['\tau = ',num2str(ktau_tri_post,'%.2f')];
text(0.25,0.14,ktxt_pre,'Units','normalized','FontSize',fs)
text(0.78,0.14,ktxt_post,'Units','normalized','FontSize',fs)

% Make sure axes are drawn on top of grahpics
set(gca,'Layer','top')

% subfigure label
text(labx,laby,'g','Units','normalized','FontWeight','bold','FontSize',fs)



%-------------------
% Export figure
%-------------------

 %Export at 300 dpi 
 print('../../Research/vaccine_behaviour_16/PNAS_demetri/figures/fig2_highkap','-dpdf','-r300')



