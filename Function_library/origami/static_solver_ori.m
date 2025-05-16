function data_out=static_solver_ori(data)
%solve nonlinear equilibrium equations using modified Newton method
%converge to stable equilibrium, considering substep, for origami( including
%CTS, TTS)

global E A l0 Ia Ib C S w ne Xb Xa dXa f_int l_int theta_0 k_h E_n_total node_in_hinge
% minimize total energy? (1: use, 0: not use) it's time consuming
use_energy=1;

%% input data
C=data.C;
ne=data.ne;
nn=data.nn;
Ia=data.Ia;
Ib=data.Ib;
S=data.S;
index_b=data.index_b;
index_s=data.index_s;
substep=data.substep;
E0=data.E;
consti_data=data.consti_data;
material=data.material;
A=data.A;
theta_0_t=data.theta_0_t;   % initial angle
k_h=data.k_h;               % stiffness of hinge
E_n=data.E_n;               % transfer matrix from matrix to structure
     E_n_total=cell2mat(E_n);        % transformation matrix of the whole structure
node_in_hinge=data.node_in_hinge;       % node in triangle element in hinge

% w0=data.w;
if  isfield(data,'w_t')
    if size(data.w_t,2)==substep
        w_t=data.w_t;
    elseif size(data.w_t,2)==1
        w_t=data.w_t*linspace(0,1,substep);
    end
else
    w_t=linspace(0,0,substep);
end

% dXb=data.dXb;
if  isfield(data,'dnb_t')
    if size(data.dnb_t,2)==substep
        dXb_t=data.dnb_t;
    elseif size(data.dnb_t,2)==1
        dXb_t=data.dnb_t*linspace(0,1,substep);
    end
else
    dXb_t=linspace(0,0,substep);
end
% l0_0=data.l0;
if size(data.l0_t,2)==substep
    l0_t=data.l0_t;
elseif size(data.l0_t,2)==1
    l0_t=data.l0_t*linspace(1,1,substep);
end

if  isfield(data,'subsubstep')
    subsubstep=data.subsubstep;
else
    subsubstep=30;          %default ssubstep
end

X0=data.N(:);
data_out=data;     %initialize output data
data_out.E_out=E0*ones(1,substep);


%% calculate equilibrium
X=X0;               %initialize configuration
Xb0=Ib'*X;           %pinned node
E=E0;
% lamda=linspace(0,1,substep);    %coefficient for substep
num_slack=ne*zeros(substep+1,1);    %num of string slack
Xa=Ia'*X;
cont=2;
u=1e-2;
for k=1:substep
    w=w_t(:,k);               %external force
    Xb=Xb0+dXb_t(:,k);         %forced node displacement
    l0=l0_t(:,k);         %forced enlongation of string
    theta_0=theta_0_t(:,k);     % initial angle
    disp(k);


    X=[Ia';Ib']\[Xa;Xb];
    l=sqrt(sum((reshape(X,3,[])*C').^2))'; %bar length
    l_c=S*l;

    strain=(l_c-l0)./l0;        %strain of member
    [E,sigma]=stress_strain(consti_data,index_b,index_s,strain,material);

    t_c=sigma.*A;         %member force
    t=S'*t_c;
    q_c=t_c./l_c;
    q=t./l;      %reculate force density

    l_int=l;   f_int=t;

    for i=1:1e3
        % recalculate configuration
        X=[Ia';Ib']\[Xa;Xb];
        l=sqrt(sum((reshape(X,3,[])*C').^2))'; %bar length
        l_c=S*l;

        % member force (of truss)
        %         q=E.*A.*(1./l0-1./l);      %force density
        strain=(l_c-l0)./l0;        %strain of member
        [E,sigma]=stress_strain(consti_data,index_b,index_s,strain,material);
        t_c=sigma.*A;         %member force
        t=S'*t_c;
        q_c=t_c./l_c;
        q=t./l;      %reculate force density
        q_bar=diag(q);

        % angle and jacobian (of hinge)
        [phpn_e,phTpn,theta]=jacobian_ori(node_in_hinge,reshape(X,3,[]),E_n_total);       % jacobian matrix
  
        % moment of hinge
        M=diag(k_h)*(theta-theta_0);

        % equilibrium matrix (of truss)
        N=reshape(X,3,[]);
        H=N*C';
        Cell_H=mat2cell(H,3,ones(1,size(H,2)));          % transfer matrix H into a cell: Cell_H
        A_2a=Ia'*kron(C',eye(3))*blkdiag(Cell_H{:})*diag(l.^-1);     % equilibrium matrix
        A_2ac=A_2a*S';

        % equilibrium matrix (or truss + hinge)
        A_o_a=[A_2ac,Ia'*phTpn];

        % unbalanced force
        K=kron(C'*q_bar*C,eye(3));                      %stiffness matrix of truss
        Fp=w-K*X-phTpn*M;                               %unbalanced force
        Fp_a=Ia'*Fp;                                    %see the norm of unbalanced force
        norm(Fp_a)
        if norm(Fp_a)<1e-7
            break
        end

        % tangent stiffness matrix (of truss)
        Kg_aa=Ia'*K*Ia-A_2a*q_bar*A_2a';
        Ke_aa=A_2ac*diag(E.*A./l0)*A_2ac';
        Kt_aa=Kg_aa+(Ke_aa+Ke_aa')/2;       

        % jacobian matrix (of hinge)
        [ph2pn2_e,ph2pn2]=hessian_ori(node_in_hinge,N,E_n);         % calculate hessian matrix
        G=cell2mat(ph2pn2);

        % tangenet stiffness (truss +hinge)
        K_t_oa=Kt_aa+Ia'*(phTpn*diag(k_h)*phTpn'+G*kron(M,eye(3*nn)))*Ia;

        % A_2c=kron(C',eye(3))*blkdiag(Cell_H{:})*diag(l.^-1)*S';     % equilibrium matrix
        % K_t=K+A_2c*diag(E.*A./(l0.^-1))*A_2c';
        %         K_taa=Ia'*0.5*(K_t+K_t')*Ia;

        %         for j=1:ne
        %             Ki{j,1}=q_bar(j,j)*eye(3)+E(j)*A(j)*l(j)^(-3)*B(:,j)*B(:,j)';
        %         end
        %         K_t=kron(C',eye(3))*blkdiag(Ki{:})*kron(C,eye(3));


        %modify the stiffness matrix
        [V_mode,D]=eig(K_t_oa);                       %�նȾ���������
        d=diag(D);                            %eigen value
        lmd=min(d);                     %�նȾ�����С������
        if lmd>0
            Km=K_t_oa+u*eye(size(K_t_oa)); %�����ĸնȾ���
        else
            Km=K_t_oa+(abs(lmd)+u)*eye(size(K_t_oa));
        end
        dXa=Km\Fp_a;
        %          dXa=(lmd*eye(size(Km)))\Fp_a;
        x=1;
        % line search
        if use_energy==1
            opt=optimset('TolX',1e-5);
            [x,V]=fminbnd(@energy_ori,0,5,opt);
        end
        Xa=Xa+x*dXa;
    end
    %
    %     % change youngs mudulus if string slack
    %     strain=(l-l0)./l0;        %strain of member
    %     [E,stress]=stress_strain(consti_data,index_b,index_s,strain,material);
    % %     [E,sigma]=stress_strain(consti_data,index_b,index_s,strain,slack,plastic);
    %     f=stress.*A;         %member force
    %     q=f./l;      %reculate force density
    %     num_slack(k+1)=numel(find(E==0));
    %        % if string slack, recalculate with more steps
    %     if num_slack(k+1)>num_slack(k)
    %         p_s=k-1;
    %           p_e=k;
    %         [E,f,q] = nonlinear_solver(data,Xb0,w_t,dXb_t,l0_t,data_out.E_out(:,k-1),p_s,p_e,subsubstep,material);
    %     end
    %     num_slack(k+1)=numel(find(E==0));
    %
    %     if min(E)==0
    %         if cont<2
    %             [d_sort,idx]=sort(d);               %sorted eigenvalue
    %             D_sort=diag(d_sort);                  %sorted eigenvalue matrix
    %             V_mode_sort=V_mode(:,idx);              %sorted eigenvector
    %             index_bk=find(d_sort<1e-5);             %index for buckling mode
    %             cont=cont+1;
    %             Xa=Xa+0.0*min(l)*real(mean(V_mode_sort(:,index_bk),2));    %add unstable mode if needed
    %         end
    %     end


    %     if slack
    %         if sum(q_i(index_s)<1e-6)
    %             index_slack=find(q_i(index_s)<0);
    %             index_string_slack=index_s(index_slack);       %slack stings'number
    %             % change youngs mudulus of slack string E_ss=0
    %             E=E0;
    %             E(index_string_slack)=0;
    %             q=E.*A.*(1./l0-1./l);      %reculate force density
    %             q_bar=diag(q);
    %
    %             %give initial error in coordinate, prevent unstable solution
    %             if cont<3
    %             [d_sort,idx]=sort(d);               %sorted eigenvalue
    %             D_sort=diag(d_sort);                  %sorted eigenvalue matrix
    %             V_mode_sort=V_mode(:,idx);              %sorted eigenvector
    %             index_bk=find(d_sort<1e-5);             %index for buckling mode
    %             cont=cont+1;
    %             end
    %             Xa=Xa+0*min(l)*real(mean(V_mode_sort(:,index_bk),2));    %add unstable mode if needed
    %         else
    %             E=E0;              %use initial young's muldus
    %         end
    %     end


    %% output data

    data_out.N_out{k}=reshape(X,3,[]);
    data_out.n_out(:,k)=X;
    %     data_out.l_out(:,k)=l;
    %     data_out.q_out(:,k)=q;
    %     data_out.E_out(:,k)=E;
    data_out.t_out(:,k)=t;      %member force
    data_out.M_out(:,k)=M;      % moment of hinge
    data_out.theta_out(:,k)=theta;      %member force
    % data_out.V{k}=energy_cal(data_out);
    data_out.Fpn_out(k)=norm(Ia'*Fp);
end
data_out.E=E;
data_out.N=reshape(X,3,[]);









