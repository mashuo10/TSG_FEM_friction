%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%A CTS T bar example: nonlinear shape control %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% /* This Source Code Form is subject to the terms of the Mozilla Public
% * License, v. 2.0. If a copy of the MPL was not distributed with this
% * file, You can obtain one at http://mozilla.org/MPL/2.0/.
%
% [1] structure design(calculate equilibrium matrix,
% group matrix,prestress mode, minimal mass design)
% [2] modal analysis(calculate tangent stiffness matrix, material
% stiffness, geometry stiffness, generalized eigenvalue analysis)
% [3] dynamic simulation

%EXAMPLE
clc; clear all; close all;
% Global variable
global M 
[consti_data,Eb,Es,sigmab,sigmas,rho_b,rho_s]=material_lib('Steel_Q345','Steel_string');
material{1}='linear_elastic'; % index for material properties: multielastic, plastic.
material{2}=0; % index for considering slack of string (1) for yes,(0) for no (for compare with ANSYS)

% cross section design cofficient
thick=6e-3;        % thickness of hollow bar
hollow_solid=0;          % use hollow bar or solid bar in minimal mass design (1)hollow (0)solid
c_b=0.1;           % coefficient of safty of bars 0.5
c_s=0.01;           % coefficient of safty of strings 0.3

% static analysis set
% substep=10;                                     %�����Ӳ�
lumped=0;               % use lumped matrix 1-yes,0-no
saveimg=0;              % save image or not (1) yes (0)no
savedata=1;             % save data or not (1) yes (0)no
savevideo=1;            % make video(1) or not(0)
gravity=0;              % consider gravity 1 for yes, 0 for no
% move_ground=0;          % for earthquake, use pinned nodes motion(1) or add inertia force in free node(0) 

%dynamic analysis set
dt=1e-4;               % time step in dynamic simulation
auto_dt=0;              % use(1 or 0) auto time step, converengency is guaranteed if used
tf=1;                   % final time of dynamic simulation
out_dt=0.002;            % output data interval(approximately, not exatly)

amplitude=0;            % amplitude of external force of ground motion 
period=0.5;             %period of seismic

%% N C of the structure
% Manually specify node positions of double layer prism.
R=50;          %radius
p=12;          %complexity for cable dome
m=6;   %number of circle of the vertical bars
% for m=[2,3,4]
h=0.15*2*R;   %hight of the dome
beta=30*pi/180*ones(m,1);    %all angle of diagonal string
% [N,C_b,C_s,C] =generat_cable_dome(R,p,m,h,beta);
rate=0.1;
[N,C_b,C_s,C] =N_cable_dome_2(R,rate,p,m,h,beta);
[ne,nn]=size(C);% ne:No.of element;nn:No.of node

tenseg_plot(N,C_b,C_s);
% title('Cable dome');
% tenseg_plot(N,[],C);
axis off
view(2);
%% plot hyperbolic paraboloid
if 1
ld=2*R;
Rd=(h^2+(ld/2)^2)/(2*h); %radius of the arch
xp=1.1*linspace(-R,R,40);
yp=1.1*linspace(-R,R,40);
[Xp,Yp]=meshgrid(xp,yp); %
% square surface
sq2cirl=diag(sqrt(1-linspace(-1,1,40).^2));
Xp=sq2cirl*Xp;
% Yp=Yp*sq2cirl;

% .*abs(sin(0,pi,40))
%first surface
Zp=sqrt(Rd^2-(Xp).^2-(Yp).^2)-(Rd-h);
ss=surf(Xp,Yp,Zp,'FaceAlpha',0.4);
ss.EdgeColor = 'none';
view(-30,45);
%second surface
% Zp=sqrt(Rd^2-(Xp).^2-(Yp).^2)-(Rd-h)-9;
% ss=surf(Xp,Yp,Zp,'FaceAlpha',0.4);
% ss.EdgeColor = 'none';
% view(-30,45);
end

%% Boundary constraints
pinned_X=([5:5:60])'; pinned_Y=([5:5:60])'; pinned_Z=([5:5:60])';
[Ia,Ib,a,b]=tenseg_boundary(pinned_X,pinned_Y,pinned_Z,nn);

%% Group/Clustered information 
%generate group index
gr_whg=[1:13:13*(p-1)+1];    % whs
gr_nhg=[2:13:13*(p-1)+2];    % nhg
gr_whs=[7:13:13*(p-1)+7];    % whs
gr_nhs=[12:13:13*(p-1)+12];     % nhs
gr_nhds=[13:13:13*(p-1)+13];     % nhds
gr_wxs=[kron(ones(1,p),[5,6])+13*kron(0:p-1,[1,1])];     % wxs
gr_nxs=[kron(ones(1,p),[10,11])+13*kron(0:p-1,[1,1])];     % nxs
gr_wjs=[kron(ones(1,p),[3,4])+13*kron(0:p-1,[1,1])];    % wjs
gr_njs=[kron(ones(1,p),[8,9])+13*kron(0:p-1,[1,1])];    %njs
gr={gr_whg;gr_nhg;gr_whs;gr_nhs;gr_nhds;gr_wxs;gr_nxs;gr_wjs;gr_njs};

% several clustered string in one group of ridge and diagonal strings
num_clu=3;
gr_whs2=reshape(gr_whs,numel(gr_whs)/num_clu,[])';
gr_nhs2=reshape(gr_nhs,numel(gr_nhs)/num_clu,[])';
gr_nhds2=reshape(gr_nhds,numel(gr_nhds)/num_clu,[])';
gr_wxs2=reshape(gr_wxs,numel(gr_wxs)/num_clu,[])';
gr_nxs2=reshape(gr_nxs,numel(gr_nxs)/num_clu,[])';
gr_wjs2=reshape(gr_wjs,numel(gr_wjs)/num_clu,[])';
gr_njs2=reshape(gr_njs,numel(gr_njs)/num_clu,[])';

gr2=[mat2cell(gr_whg',ones(1,p));       %group matrix considering CTS
    mat2cell(gr_nhg',ones(1,p));
    mat2cell(gr_whs2,ones(1,num_clu));
    mat2cell(gr_nhs2,ones(1,num_clu));
    mat2cell(gr_nhds2,ones(1,num_clu));
    mat2cell(gr_wxs2,ones(1,num_clu));
    mat2cell(gr_nxs2,ones(1,num_clu));
    mat2cell(gr_wjs2,ones(1,num_clu));
    mat2cell(gr_njs2,ones(1,num_clu))];

Gp=tenseg_str_gp2(gr,C);    %generate group matrix1
Gp2=tenseg_str_gp2(gr2,C);    %generate group matrix2
S=Gp2';                      % clustering matrix


%% self-stress design
%Calculate equilibrium matrix and member length
[A_1a,A_1ag,A_2a,A_2ag,l,l_gp]=tenseg_equilibrium_matrix1(N,C,Gp,Ia);
[A_1,A_1g,A_2,A_2g,l,l_gp]=tenseg_equilibrium_matrix2(N,C,Gp,Ia);
A_1ac=A_1a*S';          %equilibrium matrix CTS
A_2ac=A_2a*S';          %equilibrium matrix CTS
l_c=S*l;                % length vector CTS
A_2c=A_1*S'/diag(l_c);
%SVD of equilibrium matrix
[U1,U2,V1,V2,S1]=tenseg_svd(A_1ag);

%external force in equilibrium design
w0=zeros(numel(N),1); w0a=Ia'*w0;

%prestress design
index_gp=[6];                   % number of groups with designed force
fd=1000;                        % force in bar is given as -1000
[q_gp,t_gp,q,t]=tenseg_prestress_design(Gp,l,l_gp,A_1ag,V2,w0a,index_gp,fd);    %prestress design
t_c=diag(sum(S,2))\S*t;
q_c=diag(sum(S,2))\S*q;
% 
% t_c=pinv(S')*t;
% q_c=pinv(S')*q;
%% cross sectional design
index_b=find(t_c<0);              % index of bar in compression
index_s=setdiff(1:size(S,1),index_b);	% index of strings
[A_b,A_s,A_c,A,r_b,r_s,r_gp,radius,E_c,l0_c,rho,mass_c]=tenseg_minimass(t_c,l_c,eye(size(S,1)),sigmas,sigmab,Eb,Es,index_b,index_s,c_b,c_s,rho_b,rho_s,thick,hollow_solid);
     %increase area of active member
E=S'*E_c;     %Young's modulus TTS
A=S'*A_c;     % Cross sectional area TTS
l0=(t+E.*A).\(E.*A.*l);
mass=S'*rho.*A.*l0;
% % Plot the structure with radius
% R3Ddata.Bradius=interp1([min(radius),max(radius)],[0.03,.1],r_b);
% R3Ddata.Sradius=interp1([min(radius),max(radius)],[0.03,.1],r_s);
% R3Ddata.Nradius=0.1*ones(nn,1);
% tenseg_plot(N,C_b,C_s,[],[],[],'Double layer prism',R3Ddata);
%% plot CTS
fig_handle=figure;
tenseg_plot_CTS(N,C,[gr_whg,gr_nhg],S,fig_handle);
view(0,0);
axis off;
%% plot hyperbolic paraboloid
if 0
ld=2*R;
Rd=(h^2+(ld/2)^2)/(2*h); %radius of the arch
xp=1.1*linspace(-R,R,40);
yp=1.1*linspace(-R,R,40);
[Xp,Yp]=meshgrid(xp,yp); %
Zp=sqrt(Rd^2-(Xp).^2-(Yp).^2)-(Rd-h);
ss=surf(Xp,Yp,Zp,'FaceAlpha',0.4);
ss.EdgeColor = 'none';
view(-30,45);
end

%% tangent stiffness matrix
[Kt_aa,Kg_aa,Ke_aa,K_mode,k]=tenseg_stiff_CTS(Ia,C,S,q,A_1a,E_c,A_c,l_c);
% plot the mode shape of tangent stiffness matrix
num_plt=1:4;
plot_mode(K_mode,k,N,Ia,C_b,C_s,l,'tangent stiffness matrix',...
    'Order of Eigenvalue','Eigenvalue of Stiffness (N/m)',num_plt,0.2,saveimg);

%% mass matrix and damping matrix
M=tenseg_mass_matrix(mass,C,lumped); % generate mass matrix
% damping matrix
d=0.00;     %damping coefficient
d_cri=damping_critical(rho,E_c,A_c);
d_c=d*d_cri;          %damping coefficient of all members
D=A_2c*diag(d_c)*A_2c';     %damping matrix

%% mode analysis
[V_mode,D1] = eig(Kt_aa,Ia'*M*Ia);         % calculate vibration mode
w_2=diag(D1);                                    % eigen value of 
omega=real(sqrt(w_2))/2/pi;                   % frequency in Hz
plot_mode(V_mode,omega,N,Ia,C_b,C_s,l,'natrual vibration',...
    'Order of Vibration Mode','Frequency (Hz)',num_plt,0.2,saveimg);


%% shape control
  % add external force, control the structure back to target
%% Step 1: External force
substep=5;
load=3e2;
ind_w=3*[[1:5:56]';[2:5:57]'];w=-load*ones(2*p,1);
ind_dnb=[]; dnb0=[];
%ind_dl0_c=[1,2,3,4]'; dl0_c=[-400,-300,200,100]';
ind_dl0_c=[]'; dl0_c=[]';
% ind_dl0_c=[1,2,3]'; dl0_c=[-40,-30,10]';
[w_t,dnb_t,l0_ct,Ia_new,Ib_new]=tenseg_load_prestress(substep,ind_w,w,ind_dnb,dnb0,ind_dl0_c,dl0_c,l0_c,b,gravity,[0;9.8;0],C,mass);
% input data
data.N=N; data.C=C; data.ne=ne; data.nn=nn; data.Ia=Ia_new; data.Ib=Ib_new;data.S=S;
data.E=E_c; data.A=A_c; data.index_b=index_b; data.index_s=index_s;
data.consti_data=consti_data;   data.material=material; %constitue info
data.w_t=w_t;  % external force
data.dnb_t=dnb_t;% forced movement of pinned nodes
data.l0_t=l0_ct;% forced movement of pinned nodes
data.substep=substep;    % substep

data_out1=static_solver_CTS(data);
t_t1=data_out1.t_out;          %member force in every step
n_t1=data_out1.n_out;          %nodal coordinate in every step
N_out1=data_out1.N_out;
t_c_t1=pinv(S')*t_t1;
%% plot member force 
tenseg_plot_result(1:substep,t_c_t1,{'ODC', 'IDC', 'HC'},{'Substep','Force / N'},'plot_member_force.png',saveimg);

%% Plot nodal coordinate curve X Y
tenseg_plot_result(1:substep,n_t1([1*3,2*3],:),{'1Z','2Z'},{'Substep','Coordinate /m)'},'plot_coordinate.png',saveimg);
%% make video of the dynamic
if 0
name=['cable_net_CTS_load'];
% tenseg_video(n_t,C_b,C_s,[],min(substep,50),name,savevideo,R3Ddata);
% tenseg_video_slack(n_t,C_b,C_s,l0_ct,index_s,[],[],[],min(substep,50),name,savevideo,material{2})
tenseg_video(n_t1,C_b,C_s,[],min(substep,50),name,savevideo,material{2})
end

%% calculate sensitivity matrix
K_l0c=-A_2c*diag(E_c.*A_c.*l_c.*l0_c.^(-2));    %sensitivity matrix of l0_c to Kn
Kt_na_l0c=-Kt_aa\Ia'*K_l0c;         %sensitivity matrix of l0c to na
Kt_tc_l0c=diag(E_c.*A_c.\l0_c)*(A_2c'*Ia*Kt_na_l0c-diag(l_c.\l0_c));%sensitivity matrix of l0c to tc











return;
%% external force, forced motion of nodes, shrink of strings
% time step
if auto_dt
dt=pi/(8*max(omega)); 	% time step dt is 1/8 of the smallest period, guarantee convergence in solving ODE
end
tspan=0:dt:tf;
out_tspan=interp1(tspan,tspan,0:out_dt:tf, 'nearest','extrap');  % output data time span

% calculate external force and 
ind_w=[];w=[];
% ind_dl0_c=[3]; dl0_c=[-1.0];
ind_dl0_c=[]; dl0_c=[];
[w_t,l0_ct]=tenseg_load_prestress_CTS(tspan,ind_w,w,'ramp',ind_dl0_c,dl0_c,l0_c,gravity,[0;0;0],C,mass);

% boundary node motion info
[~,dnb_t,dnb_d_t,dnb_dd_t,dz_a_t]=tenseg_ex_force(tspan,a,b,'vib_force',gravity,[0;0;9.8],C,mass,[1,2],amplitude,period);

% give initial speed of free coordinates
n0a_d=zeros(numel(a),1);                    %initial speed in X direction
    
%% Specify control objectives
rate=0.8;
[N_1,C_b,C_s,C] =N_cable_dome(R,rate,p,m,h,beta);
rate=0.8;
[N_2,C_b,C_s,C] =N_cable_dome(R,rate,p,m,h,beta);

ind_n_ct=a;
n_ct1=N_1(:);n_ct1=n_ct1(ind_n_ct);     % control target start configuration
n_ct2=N_2(:);n_ct2=n_ct2(ind_n_ct);     % control target start configuration
% ind_n_ct=[7:8];n_ct1=[1.8;0.3];n_ct2=[1.8;0.3];
Ic=transfer_matrix(ind_n_ct,a);         %transfer matrix for control coordinate
[n_ct_t,n_ct_dt,n_ct_ddt]=coord_vel_acc(tspan,n_ct1,n_ct2);     %nodal coordinate of control target

a_c=2*sqrt(100);    % coefficient in error dynamics(damping term)
b_c=100;            % coeffieient in error dynamics(stiffness term)

%% choose active, passive members
% ind_act=[3:6]; ind_pas=[1,2];
ind_pas=(1:2*p)';ind_act=setdiff([1:size(Gp2,2)]',ind_pas); 
% ind_act=[1:6]; ind_pas=[];
G_c=kron(eye(7),ones(3,1));         % group of control variable
% G_c=reduced_control_variable(gr2(2*p+1:end,1),gr(3:end,1));

I_act=transfer_matrix(ind_act,1:size(S,1));
I_pas=transfer_matrix(ind_pas,1:size(S,1));
% lower bound and upper bound of actuator
lb=zeros(numel(ind_act),1);    %lower bound of active string positive
% lb=-sigmas*I_act'*A_c;    %lower bound of active string positive
ub=sigmas*I_act'*A_c;             %upper bound is yielding force
%% dynamics calculation

% input data
data.N=N; data.C=C; data.ne=ne; data.nn=nn; data.Ia=Ia; data.Ib=Ib;data.S=S;
data.E=E_c; data.A=A_c; data.index_b=index_b; data.index_s=index_s;
data.consti_data=consti_data;   data.material=material; %constitue info
data.w_t=w_t;           % external force
data.dnb_t=dnb_t; data.dnb_d_t=dnb_d_t;  data.dnb_dd_t=dnb_dd_t; % forced movement of pinned nodes
data.l0_t=l0_c;         % forced movement of pinned nodes
data.n0a_d=n0a_d;        %initial speed of free coordinates
data.M=M;data.D=D;
data.rho=rho_s;
data.tf=tf;data.dt=dt;data.tspan=tspan;data.out_tspan=out_tspan;
data.Ic=Ic; data.n_ct_t=n_ct_t;data.n_ct_dt=n_ct_dt;data.n_ct_ddt=n_ct_ddt;
data.a_c=a_c;data.b_c=b_c;
data.I_act=I_act;data.I_pas=I_pas;
data.lb=lb;data.ub=ub;
data.G_c=G_c;
%% shape control analysis
% solve dynamic equation with closed loop control
data_out=shape_control_CTS(data);
% time history of structure in shape control
t_t=data_out.t_t;   %time history of members' force
n_t=data_out.n_t;   %time history of nodal coordinate 
l_t=data_out.l_t;   %time history of members' length 
l0c_t=data_out.l0_t; %time history of members' rest length 
nd_t=data_out.nd_t;   %time history of nodal coordinate
exitflag_t=data_out.exitflag_t;   % exitflag of lsqlin

%% plot member force 
tenseg_plot_result(out_tspan,t_t([1,2,7,12,13,5,10,3,8],:),{'OB','IB','OHS','IHS','ITS','ODS','IDS','ORS','IRS'},{'Time (s)','Force (N)'},'plot_member_force.png',saveimg);
grid on;
columnlegend(3, {'OB','IB','OHS','IHS','ITS','ODS','IDS','ORS','IRS'}, 'location','southwest');

%% Plot nodal coordinate curve X Y
tenseg_plot_result(out_tspan,n_t([4*3-2],:),{'4X'},{'Time (s)','Coordinate (m)'},'plot_coordinate.png',saveimg);
grid on

%% Plot rest length l0_t
tenseg_plot_result(out_tspan,l0c_t([1,13,25,28,31,34,37,40,43],:),{'OB','IB','OHS','IHS','ITS','ODS','IDS','ORS','IRS'},{'Time (s)','Rest length (m)'},'plot_coordinate.png',saveimg);
grid on;
columnlegend(3, {'OB','IB','OHS','IHS','ITS','ODS','IDS','ORS','IRS'}, 'location','southwest');

%% plot exitflag
tenseg_plot_result(out_tspan,exitflag_t,{'Exitflag'},{'Time (s)','Length (m)'},'plot_coordinate.png',saveimg);

 
%% Plot final configuration
% tenseg_plot_catenary( reshape(n_t(:,end),3,[]),C_b,C_s,[],[],[0,0],[],[],l0_ct(index_s,end))
tenseg_plot( reshape(n_t(:,end),3,[]),C_b,C_s,[],[],[0,90])
axis off 
%% save output data
if savedata==1
    save (['cable_dome_control','.mat']);
end
%% make video of the dynamic
name=['CTS_cable_dome'];
% % tenseg_video(n_t,C_b,C_s,[],min(substep,50),name,savevideo,R3Ddata);
% tenseg_video_slack(n_t,C_b,C_s,l0_ct,index_s,[],[],[],min(substep,50),name,savevideo,material{2})
tenseg_video(n_t,C_b,C_s,[],50,name,savevideo,material{2});
name=['CTS_cable_dome_color'];
tenseg_video_CTS(n_t,C,[gr_whg,gr_nhg],S,[],[],[1,2],[],[],[],t_t,[],min(numel(out_tspan),50),tf,name,savevideo)

%output data to tecplot
tenseg_tecplot(C,n_t,t_t,interp1([min(radius),max(radius)],[0.2,0.8],radius));
