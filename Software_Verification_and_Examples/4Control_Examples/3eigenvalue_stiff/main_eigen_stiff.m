clear 
clc
% A=[0 1 0;0 0 1;-1 -5 -6];
% B=[0;0;1];
A=zeros(3);
B=eye(3)
%% controbility 
ctrb(A,B)
rank(ctrb(A,B))

%% pole placement

J=[-2+j*4 -2-j*4 -10];
[K,prec,message]=place(A,B,J)
%% LMI method




