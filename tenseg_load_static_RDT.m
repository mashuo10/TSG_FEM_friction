function [w_t,dqb_t,l0_t,E_qa_new,E_qb_new]=tenseg_load_static_RDT(substep,ind_w,w,ind_dqb,dqb0,ind_l0,dl0,l0,E_qa,E_qb,gravity,acc,C,mass)
% /* This Source Code Form is subject to the terms of the Mozilla Public
% * License, v. 2.0. If a copy of the MPL was not distributed with this
% * file, You can obtain one at http://mozilla.org/MPL/2.0/.
%
% This function output the external force, nodal displacement, and
% shrink of rest length.
%
% Inputs:
%   substep:
%   ind_w: index of nodal coordinate in external force(a vector);
%   w0: external force vector;
%   ind_dn: index of nodal coordinate in forced nodal displacement(a vector);
%   dn0: forced nodal displacement vector;
%   ind_l0: index of the element with changing rest length(a vector);
%   dl0: difference of rest length;
%	l0: rest length 
%   b: index of pinned coordinates
%   gravity:considering gravity or not(1 yes;0 no)
%   acc: acceleration vector:[0;0;9.8]
%	C: connectivity matrix
%   mass: mass vector of all elements
%
% Outputs:
%   w_t: time history of external force
%   dnb_t: displacement of pinned nodes
%   l0_t: time history of rest length
%   Ia: transform matrix of free coordinates (renewed if dnb_t is used)
%   Ib: transform matrix of fixed coordinates
%% external force
%gravity force vector
% G=(gravity)*[-0.5*kron(abs(C)'*mass,acc)];
G=zeros(size(E_qb,1),1);        %zero gravity force
%initialize force 
w1=zeros(size(G,1),1); %zero external force
w1(ind_w)=w;  %force exerted on bottom nodes
w_t=w1*linspace(0,1,substep)+G*linspace(1,1,substep);

%% nodal displacement
[row,col,v]=find(E_qa(ind_dqb,:));
index_E_qa=setdiff(1:size(E_qa,2),col);

E_qa_new=E_qa(:,index_E_qa);        % new E_qa
E_qb_new=[E_qb,E_qa(:,col)];        % new E_qb
%% forced node movement
dq=zeros(size(E_qb_new,1),1);
% d3nn=zeros(size(E_qb_new,1),1);
dq(ind_dqb)=dqb0;
dqb=E_qb_new\dq;
% dq=d3nn(b_new);
% dn(ind_dn)=dn0;
dqb_t=dqb*linspace(0,1,substep);

% b_new=sort(unique([find(sum(E_qb,2));ind_dqb]));
% a_new=setdiff(1:size(E_qb,1),b_new);  %index of free node direction

% b_new=sort(unique([b;ind_dn]));
% a_new=setdiff(1:size(G,1),b_new);  %index of free node direction
% I=eye(size(E_qb,1));
% Ia=I(:,a_new);  %free node index
% Ib=I(:,b_new);  %pinned nod index


%% rest length
dl0_i=zeros(size(l0));
dl0_i(ind_l0)=dl0;
dl0_t=dl0_i*linspace(0,1,substep);
l0_t=dl0_t+l0*linspace(1,1,substep);

end
% 
% dnb_t=zeros(numel(b),substep);     %move boundary nodes
% l0_t=zeros(size(C,1),substep);     %move boundary nodes
% 
% w_t(ind_w,:)=w0*linspace(0,1,substep);  % load in c_index
% w_t=w_t+G*ones(1,substep);            % add gravity force
% 
% 
% 
% dz_a_t=[];
% 
% switch type
%     case 'impluse'
%         w_t(c_index,find(tspan<0.05))=amplitude*20;        % impluse load in c_index
%         w_t=w_t+G*ones(size(tspan));            % add gravity force
%     case 'step'
%         w_t(c_index,:)=amplitude;        % load in c_index
%         w_t=w_t+G*ones(size(tspan));            % add gravity force
%     case 'ramp'
%         w_t(c_index,:)=amplitude*ones(numel(c_index),1)*linspace(0,1,size(tspan,2));  % load in c_index
%         w_t=w_t+G*ones(size(tspan));            % add gravity force
%     
%     
%     
%     
%     
%     case 'vib_force'
%         dz_d_t=-amplitude/(2*pi/period)^2*sin(2*pi/period*tspan);    % displacement of ground motion (time serises)
%         dz_v_t=-amplitude/(2*pi/period)*cos(2*pi/period*tspan);    % velocity of ground motion (time serises)
%         dz_a_t=amplitude*sin(2*pi/period*tspan);    % acceleration of ground motion (time serises)
%         
%         w_0=-0.5*kron(abs(C)'*mass,[1;1;1]*dz_a_t);        %load in c_index
%         w_t(c_index,:)=w_0(c_index,:);
%         w_t=w_t+G*ones(size(tspan));            % add gravity force
% 
%         %    [dz_d_t,dz_v_t,dz_a_t]=ground_motion(amplitude,period,tspan,1,0,0);
%         %    [w_t,dnb_t,dnb_d_t,dnb_dd_t]=tenseg_earthquake(G,C,mass,b,dz_d_t,dz_v_t,dz_a_t,move_ground);
%         
%     case 'vib_nodes'
%         w_t=w_t+G*ones(size(tspan));            % add gravity force
%         % displacement, velocity, acceleration of ground
%         dz_d_t=-amplitude/(2*pi/period)^2*sin(2*pi/period*tspan);    % displacement of ground motion (time serises)
%         dz_v_t=-amplitude/(2*pi/period)*cos(2*pi/period*tspan);    % velocity of ground motion (time serises)
%         dz_a_t=amplitude*sin(2*pi/period*tspan);    % acceleration of ground motion (time serises)
%         
%         dnb_t0=kron(ones(numel(b),1),[1;1;1]*dz_d_t);              %move boundary nodes
%         dnb_d_t0=kron(ones(numel(b),1),[1;1;1]*dz_v_t);    %velocity of moved boundary nodes
%         dnb_dd_t0=kron(ones(numel(b),1),[1;1;1]*dz_a_t);   %acceleration of moved boundary nodes
%         
%         dnb_t(c_index,:)=dnb_t0(c_index,:);
%         dnb_d_t(c_index,:)=dnb_d_t0(c_index,:);
%         dnb_dd_t(c_index,:)=dnb_dd_t0(c_index,:);
%         
% 
%     case 'self_define'
% end

