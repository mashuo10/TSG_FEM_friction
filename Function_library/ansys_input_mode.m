function[]= ansys_input(N,C,A,t,b,index_s,name)
% /* This Source Code Form is subject to the terms of the Mozilla Public
% * License, v. 2.0. If a copy of the MPL was not distributed with this
% * file, You can obtain one at http://mozilla.org/MPL/2.0/.
%this function out put the code used in ANSYS from matlab
%% predefinition for output
[ne,nn]=size(C);
N_xyz_nn=N';
for i=1:ne
    El_123_nn(i,:)=find(C(i,:));
end
prestress=t./A;


%% output for ansys
fid11=fopen(name,'w');
%% 
  fprintf(fid11,'!����ڵ����꣬���˹�ϵ���������ԤӦ��\n!�������ԣ���������Ҫ�Լ�����\n\n');
 fprintf(fid11,'finish\n/clear \n/filename,tower  \n/title,the analysis of tower  \n!��λm��N��Pa��s\n\n');
 
 %%  material properties
  fprintf(fid11,'/prep7\n');
 fprintf(fid11,'!���嵥Ԫ���� \n et,1,link180 \n \n');
 fprintf(fid11,'!�����������(����) \n es=76000e6 \n eg=2.06e11 \nfd=2.15e08 \nfy=2.35e08 \n ft=1.57e09 \n ratio1=0.85 \nratio2=0.70\n');
 fprintf(fid11,'!�����������(����) \n mp,ex,1,es	!���嵯��ģ�� \n mp,prxy,1,0.3	!���������ɱ�\n mp,dens,1,7870	!���������ܶ�\nmp,alpx,1,6.5e-6	!����������ϵ��\n\n');
 fprintf(fid11,'!�����������(����) \n mp,ex,2,eg	!���嵯��ģ�� \n mp,prxy,2,0.3	!���������ɱ�\n mp,dens,2,7870	!���������ܶ�\nmp,alpx,2,6.5e-6	!����������ϵ��\n\n');

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
  for i=1:ne
     fprintf(fid11,'area(%d)=%4d !�����\n',i,A(i));
  end 
  fprintf(fid11,'\n');
%  fprintf(fid11,'*DO,J,1,%d\n sectype,J,link  !�����������Ϊ��\nsecdata,area(J)	!����˽��漸������\nseccontrol,,%d	!����ֻ����ѹ��1��������ѹ��0��\n*ENDDO\n',ne,max(i==index_s));
  
    for i=1:ne
         fprintf(fid11,'sectype,%d,link  !�����������Ϊ��\nsecdata,area(%d)   !����˽��漸������\nseccontrol,,%d       !����ֻ����ѹ��1��������ѹ��0��\n',i,i,max(i==index_s));
    end 
   fprintf(fid11,'\n');
   %% ����˼�����
       for i=1:ne
         fprintf(fid11,'!���嵥Ԫ����\nlsel,s,,,%d  !ѡ��˼�\nlatt,%d,,1,,,,%d  !����˼������\n',i,2-max(i==index_s),i);
    end    
      fprintf(fid11,'\n');
 %% prestress
 fprintf(fid11,'*dim,prestress,,%d\n',ne);
   for i=1:ne
     fprintf(fid11,' prestress(%d)=%4f  !ԤӦ��\n',i,prestress(i));
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
    
%% ģ̬����
%  fprintf(fid11,'!ģ̬����\n/SOLU\nANTYPE,2\nPRTRES,ON		!��ԤӦ��ЧӦ\nMODOPT,LANB,18\nPLLS,MFORCE,MFORCE,0.4\n',ne); 
% 
% 
% 
% 
% 
% 
% MXPAND,18,,,1
% /STATUS,SOLU	!�鿴���SOLUTION OPTION
% SOLVE
% 
% !������ɻ�ø���ģ̬Ƶ�ʡ�����ϵ����ģ̬ϵ��������ȵȲ���
% *DIM,FI,,18
% *DIM,PFI,,18
% *DIM,MCI,,18
% *DIM,DAI,,18
% *DO,I,1,18
% *GET,FI(I),MODE,I,FREQ 
% *GET,PFI(I),MODE,I,PFACT
% *GET,MCI(I),MODE,I,MCOEF
% *GET,DAI(I),MODE,I,DAMP
% *ENDDO
% FINISH
% 
% /POST1
% !SET,1,2
% !PLDISP,1
% !PLNSOL,U,Y
% !ETABLE,MFORCE,SMISC,1
% !PLLS,MFORCE,MFORCE,0.4
% 
% SET,LIST
% 
% !*CFOPEN,LOAD_DATA,TXT
% 
% *MWRITE,FI,FI,TXT
% (F20.10)
% 
% 
% !*CFCLOS,LOAD_DATA



  fclose(fid11);

end

