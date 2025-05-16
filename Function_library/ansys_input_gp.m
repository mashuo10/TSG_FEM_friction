function[]= ansys_input_gp(N,C,A_gp,t_gp,b,Eb,Es,rho_b,rho_s,Gp,index_s,index_s_gp,name)
% /* This Source Code Form is subject to the terms of the Mozilla Public
% * License, v. 2.0. If a copy of the MPL was not distributed with this
% * file, You can obtain one at http://mozilla.org/MPL/2.0/.
%
% This function out put the code used in ANSYS from matlab.
%
% Inputs:
%   N: node coordinate matrix 
%	C: connectivity matrix
%   A_gp: cross sectional area in group
%	t_gp: members' force in group
%   b: constraint coordinate indes
%	Eb,Es: Young's modulus of bars and strings
%   rho_b,rho_s: density of bars and strings
%   Gp: group matrix of members
%   index_s: index of strings
%   index_s_gp: index of strings in group
%   name: a string indicating the name of output txt file
%
% Outputs:
% txt file for input of ANSYS
language=0;   % 0 for English,1 for Chinese
%% predefinition for output
[ne,nn]=size(C);
ng=size(Gp,2);
N_xyz_nn=N';
for i=1:ne
    El_123_nn(i,:)=find(C(i,:));
end
prestress_gp=t_gp./A_gp;


%% output for ansys
fid11=fopen([name,'.txt'],'w');
%%
if language==0
  % fprintf(fid11,'!����ڵ����꣬���˹�ϵ���������ԤӦ��\n\n');
fprintf(fid11,'!nodal coordinate, topology, cross sectional area, prestress for ANSYS APDL\n\n');
fprintf(fid11,'finish\n/clear \n/filename,tower  \n/title,the analysis of tower  \n!Unit:m��N��Pa��s\n\n');

%%  material properties
fprintf(fid11,'/prep7\n');
fprintf(fid11,'!specify element type \n et,1,link180 \n \n');
fprintf(fid11,'!specify Youngs modulus \n es=%17.15f \n eg=%17.15f \n\n',Es,Eb);
fprintf(fid11,'!specify string material property \n mp,ex,1,es	!Youngs modulus \n mp,prxy,1,0.3	!Poisson ratio\n mp,dens,1,%d	!Material density\nmp,alpx,1,6.5e-6	!coefficient of linear expansion\n\n',rho_s);
fprintf(fid11,'!specify string material property \n mp,ex,2,eg	!Youngs modulus \n mp,prxy,2,0.3	!Poisson ratio\n mp,dens,2,%d	!Material density\nmp,alpx,2,6.5e-6	!coefficient of linear expansion\n\n',rho_b);

% fprintf(fid11,'!���嵥Ԫ���� \n et,1,link180 \n \n');
% fprintf(fid11,'!�����������(����) \n es=%17.15f \n eg=%17.15f \n\n',Es,Eb);
% fprintf(fid11,'!�����������(����) \n mp,ex,1,es	!���嵯��ģ�� \n mp,prxy,1,0.3	!���������ɱ�\n mp,dens,1,%d	!���������ܶ�\nmp,alpx,1,6.5e-6	!����������ϵ��\n\n',rho_s);
% fprintf(fid11,'!�����������(����) \n mp,ex,2,eg	!���嵯��ģ�� \n mp,prxy,2,0.3	!���������ɱ�\n mp,dens,2,%d	!���������ܶ�\nmp,alpx,2,6.5e-6	!����������ϵ��\n\n',rho_b);

%% nodal coordinates,connectivity

for i=1:nn
%     fprintf(fid11,'K,%d,%17.15f,%17.15f,%17.15f  !�ڵ�����\n',i,N_xyz_nn(i,:));
    fprintf(fid11,'K,%d,%17.15f,%17.15f,%17.15f  !nodal coordinate\n',i,N_xyz_nn(i,:));
end
fprintf(fid11,'\n');
for i=1:ne
%     fprintf(fid11,'L,%4d,%4d  !������\n',El_123_nn(i,:));
    fprintf(fid11,'L,%4d,%4d  !line\n',El_123_nn(i,:));
end
fprintf(fid11,'\n');
%% area
fprintf(fid11,'*dim,area,,%d\n',ne);
for i=1:ng
%     fprintf(fid11,'area(%d)=%4d !�����\n',i,A_gp(i));
    fprintf(fid11,'area(%d)=%4d !cross sectional area\n',i,A_gp(i));
end
fprintf(fid11,'\n');
%  fprintf(fid11,'*DO,J,1,%d\n sectype,J,link  !�����������Ϊ��\nsecdata,area(J)	!����˽��漸������\nseccontrol,,%d	!����ֻ����ѹ��1��������ѹ��0��\n*ENDDO\n',ne,max(i==index_s));

for i=1:ng
%     fprintf(fid11,'sectype,%d,link  !�����������Ϊ��\nsecdata,area(%d)   !����˽��漸������\nseccontrol,,%d       !����ֻ����ѹ��1��������ѹ��0��\n',i,i,max(i==index_s_gp));
fprintf(fid11,'sectype,%d,link  !specify section type\nsecdata,area(%d)   !specify section data\nseccontrol,,%d       !only in tension(1) both tension and compression(0) \n',i,i,max(i==index_s_gp));

end
fprintf(fid11,'\n');
%% specify cross sectional area
gr_2=zeros(ne,1);
for i=1:ne
    for j=1:ng
        gr_2(i)=find(Gp(i,:)==1);
        %                cc=j*sum(gr{j}==i);
        %                gr_2(i)=gr_2(i)+cc;
    end
end
% fprintf(fid11,'!���嵥Ԫ����\n');
fprintf(fid11,'!define element type\n');
for i=1:ne
%     fprintf(fid11,'lsel,s,,,%d  !ѡ��˼�\nlatt,%d,,1,,,,%d  !����˼������\n',i,2-max(i==index_s),gr_2(i));
    fprintf(fid11,'lsel,s,,,%d  !select element\nlatt,%d,,1,,,,%d  !specify section area\n',i,2-max(i==index_s),gr_2(i));
end
fprintf(fid11,'\n');
%% prestress
fprintf(fid11,'*dim,prestress,,%d\n',ne);
for i=1:ne
%     fprintf(fid11,' prestress(%d)=%4f  !ԤӦ��\n',i,prestress_gp(gr_2(i)));
    fprintf(fid11,' prestress(%d)=%4f  !prestress\n',i,prestress_gp(gr_2(i)));
end
fprintf(fid11,'\n');
%% mesh
% fprintf(fid11,'!���ֵ�Ԫ \n LSEL,ALL \n LESIZE,ALL,,,1\nLMESH,ALL\nfinish\n');
fprintf(fid11,'!line mesh \n LSEL,ALL \n LESIZE,ALL,,,1\nLMESH,ALL\nfinish\n');
fprintf(fid11,'\n');
%% first solve
% fprintf(fid11,'!��һ����⣨��ƽ�⣩\n/SOLU\nANTYPE,0 \nNLGEO!���Ǵ���� \nSSTIF,ON	!����Ӧ���ջ� \nNSUBST,100	!���ú��ز����Ӳ��� \nAUTOTS,ON	!�Զ����ز� \n  OUTRES,ALL,ALL 	!������� \n');
fprintf(fid11,'!First solve for self-equilibrium��\n/SOLU\nANTYPE,0 \nNLGEO!consider large deformation \nSSTIF,ON	!prestress stiffness  \nNSUBST,100	!Substep \nAUTOTS,ON	!Automatic time stepping \n  OUTRES,ALL,ALL 	!Output result \n');
fprintf(fid11,'\n');
%% boundary constraints

for i=1:numel(b)
    fprintf(fid11,'DK,%d,U%c\n',ceil(b(i)/3),char(88+mod(b(i)+2,3)));
end

fprintf(fid11,'\n');

%% prestress and solve
% fprintf(fid11,'*DO,J,1,%d	!��������ԤӦ������\n	INISTATE,DEFINE,J,,,,PRESTRESS(J)\n*ENDDO\n',ne);
fprintf(fid11,'*DO,J,1,%d	!Prestress in initial state\n	INISTATE,DEFINE,J,,,,PRESTRESS(J)\n*ENDDO\n',ne);
fprintf(fid11,'\n');
fprintf(fid11,'ALLSEL,ALL\nSOLVE\nFINISH\n');

fprintf(fid11,'\n');
%% post1
%fprintf(fid11,'!����\n/POST1\nPLDISP !��ʾ���κ��ͼ��\nALLSEL,ALL  !��ʾ������ͼ\nETABLE,MFORCE,SMISC,1\nPLLS,MFORCE,MFORCE,0.4\n',ne);
% fprintf(fid11,'!����\n/POST1\nETABLE,MSTRESS,LS,1\n');
fprintf(fid11,'!Post analysis\n/POST1\nPLDISP !Plot deformed shape\nALLSEL,ALL\n');  

else
    
    
%%
fprintf(fid11,'!����ڵ����꣬���˹�ϵ���������ԤӦ��\n\n');
fprintf(fid11,'finish\n/clear \n/filename,tower  \n/title,the analysis of tower  \n!��λm��N��Pa��s\n\n');

%%  material properties
fprintf(fid11,'/prep7\n');
fprintf(fid11,'!���嵥Ԫ���� \n et,1,link180 \n \n');
fprintf(fid11,'!�����������(����) \n es=%17.15f \n eg=%17.15f \n\n',Es,Eb);
fprintf(fid11,'!�����������(����) \n mp,ex,1,es	!���嵯��ģ�� \n mp,prxy,1,0.3	!���������ɱ�\n mp,dens,1,%d	!���������ܶ�\nmp,alpx,1,6.5e-6	!����������ϵ��\n\n',rho_s);
fprintf(fid11,'!�����������(����) \n mp,ex,2,eg	!���嵯��ģ�� \n mp,prxy,2,0.3	!���������ɱ�\n mp,dens,2,%d	!���������ܶ�\nmp,alpx,2,6.5e-6	!����������ϵ��\n\n',rho_b);

%% nodal coordinates,connectivity

for i=1:nn
    fprintf(fid11,'K,%d,%17.15f,%17.15f,%17.15f  !�ڵ�����\n',i,N_xyz_nn(i,:));
end
fprintf(fid11,'\n');
for i=1:ne
    fprintf(fid11,'L,%4d,%4d  !������\n',El_123_nn(i,:));
end
fprintf(fid11,'\n');
%% area
fprintf(fid11,'*dim,area,,%d\n',ne);
for i=1:ng
    fprintf(fid11,'area(%d)=%4d !�����\n',i,A_gp(i));
end
fprintf(fid11,'\n');
%  fprintf(fid11,'*DO,J,1,%d\n sectype,J,link  !�����������Ϊ��\nsecdata,area(J)	!����˽��漸������\nseccontrol,,%d	!����ֻ����ѹ��1��������ѹ��0��\n*ENDDO\n',ne,max(i==index_s));

for i=1:ng
    fprintf(fid11,'sectype,%d,link  !�����������Ϊ��\nsecdata,area(%d)   !����˽��漸������\nseccontrol,,%d       !����ֻ����ѹ��1��������ѹ��0��\n',i,i,max(i==index_s_gp));
end
fprintf(fid11,'\n');
%% ����˼�����
gr_2=zeros(ne,1);
for i=1:ne
    for j=1:ng
        gr_2(i)=find(Gp(i,:)==1);
        %                cc=j*sum(gr{j}==i);
        %                gr_2(i)=gr_2(i)+cc;
    end
end
fprintf(fid11,'!���嵥Ԫ����\n');
for i=1:ne
    fprintf(fid11,'lsel,s,,,%d  !ѡ��˼�\nlatt,%d,,1,,,,%d  !����˼������\n',i,2-max(i==index_s),gr_2(i));
end
fprintf(fid11,'\n');
%% prestress
fprintf(fid11,'*dim,prestress,,%d\n',ne);
for i=1:ne
    fprintf(fid11,' prestress(%d)=%4f  !ԤӦ��\n',i,prestress_gp(gr_2(i)));
end
fprintf(fid11,'\n');
%% mesh
fprintf(fid11,'!���ֵ�Ԫ \n LSEL,ALL \n LESIZE,ALL,,,1\nLMESH,ALL\nfinish\n');
fprintf(fid11,'\n');
%% solve
fprintf(fid11,'!��һ����⣨��ƽ�⣩\n/SOLU\nANTYPE,0 \nNLGEO!���Ǵ���� \nSSTIF,ON	!����Ӧ���ջ� \nNSUBST,100	!���ú��ز����Ӳ��� \nAUTOTS,ON	!�Զ����ز� \n  OUTRES,ALL,ALL 	!������� \n');
fprintf(fid11,'\n');
%% boundary constraints

for i=1:numel(b)
    switch b(i)-3*(ceil(b(i)/3)-1)
        case 1
            fprintf(fid11,'DK,%d,UX\n',ceil(b(i)/3));
        case 2
            fprintf(fid11,'DK,%d,UY\n',ceil(b(i)/3));
        case 3
            fprintf(fid11,'DK,%d,UZ\n',ceil(b(i)/3));
    end
end
fprintf(fid11,'\n');


%% prestress and solve
fprintf(fid11,'*DO,J,1,%d	!��������ԤӦ������\n	INISTATE,DEFINE,J,,,,PRESTRESS(J)\n*ENDDO\n',ne);
fprintf(fid11,'\n');
fprintf(fid11,'ALLSEL,ALL\nSOLVE\nFINISH\n');

fprintf(fid11,'\n');
%% post1
fprintf(fid11,'!����\n/POST1\nPLDISP !��ʾ���κ��ͼ��\nALLSEL,ALL  !��ʾ������ͼ\nETABLE,MFORCE,SMISC,1\nPLLS,MFORCE,MFORCE,0.4\n',ne);

end
fclose(fid11);
end

