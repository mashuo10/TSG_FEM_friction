function [Kt_aa,Kg_aa,Ke_aa,K_mode_sort,k_sort]=tenseg_stiff_CTS3(Ia,C,S,t_c,A_2a,E_c,A_c,l0,l)
% /* This Source Code Form is subject to the terms of the Mozilla Public
% * License, v. 2.0. If a copy of the MPL was not distributed with this
% * file, You can obtain one at http://mozilla.org/MPL/2.0/.
%
% This function calculates the tangent stiffness matrix information of
% CTS(clustered tensegrity structures)
%
% Inputs:
%   b_material: bar material name
%   s_material: string material name
% Outputs:
%	consti_data.data_b1: strain of bar
%	consti_data.data_b2: stress of bar
%	consti_data.data_s1: strain of string
%	consti_data.data_s2: stress of string
%   Eb: Young's modulus of bar
%   Es: Young's modulus of string
%   sigma_b: yielding stress of bar
%   sigma_s: yielding stress of string
%   rho_b: density of bar
%   rho_s: density of string


l0_c=S*l0;
l_c=S*l;
A_2ac=A_2a*S';
q=(S'*t_c)./l;
Kg_aa=Ia'*kron(C'*diag(q)*C,eye(3))*Ia-A_2a*diag(q)*A_2a';
Ke_aa=A_2ac*diag(E_c.*A_c./l0_c)*A_2ac';
Kt_aa=Kg_aa+(Ke_aa+Ke_aa')/2;       % this is to 
[K_mode,D1] = eig(Kt_aa);         % eigenvalue of tangent stiffness matrix
k=diag(D1);   
[k_sort,I]=sort(k);
K_mode_sort=K_mode(:,I);

end

