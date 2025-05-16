%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%A kresling origami with string%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% /* This Source Code Form is subject to the terms of the Mozilla Public
% * License, v. 2.0. If a copy of the MPL was not distributed with this
% * file, You can obtain one at http://mozilla.org/MPL/2.0/.
%
%this file study the stiffness of kresling origami with string in different 
% configuration (\phi and h) 

%EXAMPLE
clc; clear all; close all;
% Global variable
[consti_data,Eb,Es,sigmab,sigmas,rho_b,rho_s]=material_lib('Steel_Q345','Steel_string');
material{1}='linear_elastic'; % index for material properties: multielastic, plastic.
material{2}=0; % index for considering slack of string (1) for yes,(0) for no (for compare with ANSYS)

% cross section design cofficient
thick=6e-4;        % thickness of hollow bar
hollow_solid=0;          % use hollow bar or solid bar in minimal mass design (1)hollow (0)solid
c_b=0.1;           % coefficient of safty of bars 0.5
c_s=0.1;           % coefficient of safty of strings 0.3

% static analysis set
substep=40;                                     %�����Ӳ�
lumped=0;               % use lumped matrix 1-yes,0-no
saveimg=0;              % save image or not (1) yes (0)no
savedata=1;             % save data or not (1) yes (0)no
savevideo=1;            % make video(1) or not(0)
gravity=0;              % consider gravity 1 for yes, 0 for no
% move_ground=0;          % for earthquake, use pinned nodes motion(1) or add inertia force in free node(0) 
%% %% N C of the structure

h_t=linspace(5,15,substep);         %height 
beta_t=linspace(-pi/4,pi/4,substep);    % angle
stiff_str=zeros(substep,substep);   % stiff in string
stiff_X=zeros(substep,substep);     % stiff in X
stiff_Z=zeros(substep,substep);     % stiff in Z
stiff_R=zeros(substep,substep);     % stiff in R
R=10;  p=5; level=3;        % radius; height; number of edge, level

for ii=1:substep
    for jj=1:substep
% Manually specify node positions
h=h_t(ii);  % height
beta=beta_t(jj);
% beta=15*pi/180; 	% rotation angle

angle=kron(ones(1,level+1),2*pi*((1:p)-1)./p)+kron(0:level,beta*ones(1,p));
N=R*[cos(angle); sin(angle); zeros(1,p*(level+1))]+kron(0:level,[0;0;h]*ones(1,p));

% Manually specify connectivity indices.
C_b_in_h=[(1:p*(level+1))',kron(ones(level+1,1),[2:p,1]')+kron((0:level)',p*ones(p,1))];% horizontal bar
C_b_in_v=[(1:p*level)',(p+1:(level+1)*p)'];% vertical bar
C_b_in_d=[(1:p*level)',kron(ones(level,1),[2:p,1]')+kron((1:level)',p*ones(p,1))];% diagonal bar
% strings
C_s_in=[(1:p*level)',kron(ones(level,1),[p,1:p-1]')+kron((1:level)',p*ones(p,1))]; %diagonal string

C_b_in = [C_b_in_h;C_b_in_v;C_b_in_d];   % This is indicating the bar connection
C_in=[C_b_in;C_s_in];
% Convert the above matrices into full connectivity matrices.
C = tenseg_ind2C(C_in,N);
[ne,nn]=size(C);        % ne:No.of element;nn:No.of node

C_b=tenseg_ind2C(C_b_in,N);;C_s=tenseg_ind2C(C_s_in,N);
n_b=size(C_b,1);n_s=size(C_s,1);        % number of bars and string

% connectivity matrix for plot
C_bar_in=[];      % real bars
C_bar=tenseg_ind2C(C_bar_in,N);
C_rot_h_in=C_b_in;             %rotational hinges
C_rot_h=tenseg_ind2C(C_rot_h_in,N);

% Plot the structure to make sure it looks right
% tenseg_plot(N,C_b,C_s);

%% define hinge, rigid hinge
% C_in_h is the connectivity of higes, can be written in a function!!!!!!!!!
C_in_h=[C_b_in_h(p+1:(level)*p,:);C_b_in_v;C_b_in_d];
n_h=size(C_in_h,1);         % number of hinge

[~,index_h]=ismember(C_in_h,C_in,'rows');   % index_h is the index number of hinge
index_rh=[];index_rh_in_h=[];
% [~,index_rh]=ismember(C_in_2,C_in,'rows');   % index_h is the index number of rigid hinge
% [~,index_rh_in_h]=ismember(C_in_2,C_in_h,'rows');   % index_h is the index of rigid hinge in all hinge

C_h=tenseg_ind2C(C_in(setdiff([1:ne]',index_rh),:),N);     % connectivity matrix of all edges
C_rig_h=tenseg_ind2C(C_in(index_rh,:),N); % connectivity matrix of rigid edges
% Plot the structure to make sure it looks right
% tenseg_plot(N,C_b,C_s);

%% connectivity of triangle element Ca
% Ca can be written in a function!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
Ca=kron(ones(1,level),[[1:p;[2:p,1];[p+2:2*p,p+1]],[1:p;[p+2:2*p,p+1];p+1:2*p]])+kron(0:level-1,p*ones(3,p*2));
% Ca=generate_Ca(C_in,N);
% Ca=zeros(3,1)

[~,np]=size(Ca);        % ne:No.of element;np:No.of plate

% plot the origami configuration
if 0
tenseg_plot_ori(N,C_b,C_s,[],C_rig_h,[],[],[],[] ,[],Ca);
axis off;
end
%% transformation matrix from element to structure

E_n=cell(1,n_h);            %transformation matrix from element node to total node
node_in_hinge=zeros(n_h,4);
I=eye(3*nn);

for i=1:n_h
node2=C_in_h(i,1);  % start node of the hinge
node3=C_in_h(i,2);  % end node of the hinge
for j=1:np
    if (node2==Ca(1,j)&node3==Ca(2,j))|(node2==Ca(2,j)&node3==Ca(3,j))|(node2==Ca(3,j)&node3==Ca(1,j))
        node1=setdiff(Ca(:,j),[node2;node3]);
    elseif (node2==Ca(2,j)&node3==Ca(1,j))|(node2==Ca(3,j)&node3==Ca(2,j))|(node2==Ca(1,j)&node3==Ca(3,j))
        node4=setdiff(Ca(:,j),[node2;node3]);
    end
end
node_in_hinge(i,:)=[node1,node2,node3,node4];
E_n{i}=I(:,kron(node_in_hinge(i,:),3*ones(1,3))-kron(ones(1,4),[2,1,0]));
end
E_n_total=cell2mat(E_n);        % transformation matrix of the whole structure
%% Boundary constraints
pinned_X=[1:p]'; pinned_Y=[1:p]'; pinned_Z=[1:p]';
[Ia,Ib,a,b]=tenseg_boundary(pinned_X,pinned_Y,pinned_Z,nn);

%% generate group index for tensegrity torus structure
gr=[];                      %no group is used
Gp=tenseg_str_gp(gr,C);    %generate group matrix
S=Gp';                      % clustering matrix
%% equilibrium matrix

% equilibrium matrix of truss
[A_1,A_1c,A_1a,A_1ac,A_2,A_2c,A_2a,A_2ac,l,l_c]=tenseg_equilibrium_matrix_CTS(N,C,S,Ia);
% [A_1,A_1g,A_2,A_2g,l,l_gp]=tenseg_equilibrium_matrix2(N,C,Gp,Ia);

% equilibrium matrix of hinge
[phpn_e,phTpn,theta]=jacobian_ori(node_in_hinge,N,E_n_total);       % jacobian matrix
A_o=[A_2,phTpn];
A_o_a=Ia'*A_o;
% A_o_a=A_o;
%% SVD of equilibrium matrix
[U1,U2,V1,V2,S1]=tenseg_svd(A_o_a);         % equilibrium of truss with hinge
% [U1,U2,V1,V2,S1]=tenseg_svd(A_2);           % equilibrium of turss without hinge

%% self-stress design (of truss)
t=zeros(ne,1);      %member force
q=t./l;             % force density
%% self-stress design (of hinge)
M=zeros(n_h,1);
%% cross sectional design (of truss)
A_c=1e-4*ones(ne,1);
E_c=1e6*ones(ne,1);
index_b=[1:ne]';              % index of bar in compression
index_s=setdiff(1:size(S,1),index_b);	% index of strings
%% hinge section design  (of hinge)
k_h=1/12*E_c(index_h).*l(index_h)*thick^3;
k_h(index_rh_in_h)=1e2*1/12*E_c(index_rh).*l(index_rh)*thick^3;      % increase stiffness of rigid hinge
%% rest length (of truss), initial angle (of hinge)
l0_c=l;                     %rest length of truss
theta_0=theta;     % initial angle of hinge
%% tangent stiffness matrix of bars
% [Kt_aa,Kg_aa,Ke_aa,K_mode,k]=tenseg_stiff_CTS(Ia,C,S,q,A_1a,E_c,A_c,l_c);
[Kt_aa,Kg_aa,Ke_aa,K_mode,k]=tenseg_stiff_CTS2(Ia,C,q,A_2ac,E_c,A_c,l0_c);

%% tangent stiffness matrix of hinge

%ph2px2 is the hessian matrix of theta to nodal coordinate
[ph2pn2_e,ph2pn2]=hessian_ori(node_in_hinge,N,E_n);         % calculate hessian matrix
G=cell2mat(ph2pn2);

%% tangent stiffness of the whole origami

K_t_oa=Kt_aa+Ia'*(phTpn*diag(k_h)*phTpn'+G*kron(M,eye(3*nn)))*Ia;
if 0
[K_mode,D1] = eig(K_t_oa);         % eigenvalue of tangent stiffness matrix
k=diag(D1); 
[k, ind] = sort(k);
K_mode = K_mode(:, ind);
% plot the mode shape of tangent stiffness matrix

num_plt=1:9;
plot_mode_ori(round(K_mode,12),k,N,Ia,C_bar,C_s,C_rot_h,C_rig_h,l,'tangent stiffness matrix',...
    'Order of Eigenvalue','Eigenvalue of Stiffness (N/m)',num_plt,0.3,saveimg,3,Ca);
end


%% sensitivity analysis t/l0
K_l0c=-A_2*diag(E_c.*A_c.*l./(l0_c.^2));    % sensitivity of l0c to nodal force
K_na_l0c=-K_t_oa\Ia'*K_l0c;                 % sensitivity of l0c to nodal coordinate
K_t_l0c=diag(E_c.*A_c./l0_c)*(A_2'*Ia*K_na_l0c-diag(l./l0_c));      % sensitivity of l0c to member force

% stiffness in string
dl0c=zeros(ne,1); dl0c(n_b+1:end)=1;    % rest length change
dl0c=dl0c/norm(dl0c);                   % normalized rest length change
stiff_str(ii,jj)=-dl0c'*K_t_l0c*dl0c;

%%  stiffness in XYZ direction
    
F_dir=zeros(3*nn,4);
F_dir([3*(level*p+1)-2:3*(level*p+p)],1:3)=kron(ones(p,1),eye(3));   % force with direction X Y Z
 % rotation direction force
    F_dir([3*(level*p+1)-2:3*(level*p+p)],4)=reshape(cross([0 0 1]'*ones(1,p),N(:,(level*p+1):(level*p+p))),[],1);
F_dir=F_dir/diag(sqrt(diag(F_dir'*F_dir))); %normalized


compliance_dir=zeros(4,1);    % compliance with direction X Y Z
stiff_dir=zeros(4,1);         % stiff with direction X Y Z
 disp_dir=K_t_oa\(Ia'*F_dir);
compliance_dir=diag(disp_dir'*K_t_oa'*disp_dir);     
stiff_dir=1./compliance_dir;
stiff_X(ii,jj)=stiff_dir(1);
stiff_Z(ii,jj)=stiff_dir(3);
stiff_R(ii,jj)=stiff_dir(4);
    end 
end

%%  stiffness in XZR str direction
    

[X,Y] = meshgrid(h_t,beta_t*180/pi);
%% plot countor stiff in string 
figure
contour(X,Y,stiff_str,'ShowText','on')
xlabel('height','fontsize',18,'Interpreter','tex');
ylabel('angle','fontsize',18);
title('stiff in str');
colorbar
% plot stiff in X
figure
contour(X,Y,stiff_X,'ShowText','on')
xlabel('height','fontsize',18,'Interpreter','tex');
ylabel('angle','fontsize',18);
title('stiff in X');
colorbar
% plot stiff in Z
figure
contour(X,Y,stiff_Z,'ShowText','on')
xlabel('height','fontsize',18,'Interpreter','tex');
ylabel('angle','fontsize',18);
title('stiff in Z');
colorbar
% plot stiff in R
figure
contour(X,Y,stiff_R,'ShowText','on')
xlabel('height','fontsize',18,'Interpreter','tex');
ylabel('angle','fontsize',18);
title('stiff in R');
colorbar

%% plot contour in subplot
% plot countor stiff in string 
figure
subplot(2,2,3)
contourf(X,Y,stiff_str,'ShowText','on')
xlabel('Height (m)','fontsize',18,'Interpreter','tex');
ylabel('Angle ({\circ})','fontsize',18);
title('stiffness in string actuation','fontsize',18);
colorbar
% plot stiff in X
subplot(2,2,1)
contourf(X,Y,stiff_X,'ShowText','on')
xlabel('Height (m)','fontsize',18,'Interpreter','tex');
ylabel('Angle ({\circ})','fontsize',18);
title('stiffness in X direction','fontsize',18);
colorbar
% plot stiff in Z
subplot(2,2,2)
contourf(X,Y,stiff_Z,'ShowText','on')
xlabel('Height (m)','fontsize',18,'Interpreter','tex');
ylabel('Angle ({\circ})','fontsize',18);
title('stiffness in Z direction','fontsize',18);
colorbar
% plot stiff in R
subplot(2,2,4)
contourf(X,Y,stiff_R,'ShowText','on')
xlabel('Height (m)','fontsize',18,'Interpreter','tex');
ylabel('Angle ({\circ})','fontsize',18);
title('stiffness in rotation','fontsize',18);
colorbar


%% plot mesh
% plot stiff in string 
subplot(2,2,1)
mesh(X,Y,stiff_str)
xlabel('height','fontsize',18,'Interpreter','tex');
ylabel('angle','fontsize',18);
title('stiff in str');
colorbar
% plot stiff in X
subplot(2,2,2)
mesh(X,Y,stiff_X)
xlabel('height','fontsize',18,'Interpreter','tex');
ylabel('angle','fontsize',18);
title('stiff in X');
colorbar
% plot stiff in Z
subplot(2,2,3)
mesh(X,Y,stiff_Z)
xlabel('height','fontsize',18,'Interpreter','tex');
ylabel('angle','fontsize',18);
title('stiff in Z');
colorbar
% plot stiff in R
subplot(2,2,4)
mesh(X,Y,stiff_R)
xlabel('height','fontsize',18,'Interpreter','tex');
ylabel('angle','fontsize',18);
title('stiff in R');
colorbar











