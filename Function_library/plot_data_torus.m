function plot_data_torus(data_out,direction,saveimg)
% /* This Source Code Form is subject to the terms of the Mozilla Public
% * License, v. 2.0. If a copy of the MPL was not distributed with this
% * file, You can obtain one at http://mozilla.org/MPL/2.0/.
%
%plot the information of torus R=10
%%
N_out=data_out.N_out;
t_step=data_out.t_out;          %member force in every step
n_step=data_out.n_out;          %nodal coordinate in every step
substep=size(n_step,2);
%% plot member force and node coordinate

% plot_data_torus(data_out,direction,saveimg);
zb=1:substep;
if direction==1
    figure
    plot(zb,t_step(147,:),'k-o',zb,t_step(152,:),'k-^','linewidth',1.5);
    set(gca,'fontsize',18);
    legend('�⼹��','�ڼ���')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('����/N','fontsize',18);
    if saveimg==1
        saveas(gcf,'1��������.png');
    end
    
    figure
    plot(zb,t_step(149,:),'k-o',zb,t_step(154,:),'k-^','linewidth',1.5);
    set(gca,'fontsize',18);
    legend('��б��','��б��','location','northwest')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('����/N','fontsize',18);
    if saveimg==1
        saveas(gcf,'1б������.png');
    end
    
    figure
    plot(zb,t_step(372,:),'k-o',zb,t_step(156,:),'k-^',zb,t_step(157,:),'k-v','linewidth',1.5);
    set(gca,'fontsize',18);
    legend('�⻷��','�ڻ���','�ڻ�����','location','northwest')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('����/N','fontsize',18);
    if saveimg==1
        saveas(gcf,'1��������.png');
    end
    
    figure
    plot(zb,t_step(145,:),'k-o',zb,t_step(146,:),'k-^','linewidth',1.5);
    set(gca,'fontsize',18);
    legend('������','������')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('����/N','fontsize',18);
    if saveimg==1
        saveas(gcf,'1��������.png');
    end
    
    figure
    plot(zb,t_step(4,:),'k-o',zb,t_step(19,:),'k-^','linewidth',1.5);
    set(gca,'fontsize',18);
    legend('ˮƽ��','�ȶ���')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('����/N','fontsize',18);
    if saveimg==1
        saveas(gcf,'1��������.png');
    end
    
    figure
    plot(zb,t_step(55,:),'k-o',zb,t_step(76,:),'k-^','linewidth',1.5);
    set(gca,'fontsize',18);
    legend('������','��б��')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('����/N','fontsize',18);
    if saveimg==1
        saveas(gcf,'1����������.png');
    end
    
    z_whd_tv=n_step(55*3,:)-n_step(55*3,1);
    z_nhd_tv=n_step(56*3,:)-n_step(56*3,1);
    z_whd_bv=n_step(57*3,:)-n_step(57*3,1);
    z_nhd_bv=n_step(58*3,:)-n_step(58*3,1);
    figure
    plot(zb,z_whd_tv,'k-^',zb,z_nhd_tv,'k-o',zb,z_whd_bv,'k-v',zb,z_nhd_bv,'k-*','linewidth',1.5);
    set(gca,'fontsize',18);
    legend('�⻷���ڵ㣨V��','�ڻ����ڵ㣨V��','�⻷�׽ڵ㣨V��'...
        ,'�ڻ��׽ڵ㣨V��','location','southwest')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('λ��/m','fontsize',18);
    if saveimg==1
        saveas(gcf,'1�ڵ�λ��(V).png');
    end
    
    h_whd_th=sqrt(sum((n_step(55*3-[2,1],:)).^2))-norm(n_step(55*3-[2,1],1));
    h_nhd_th=sqrt(sum((n_step(56*3-[2,1],:)).^2))-norm(n_step(56*3-[2,1],1));
    h_whd_bh=sqrt(sum((n_step(57*3-[2,1],:)).^2))-norm(n_step(57*3-[2,1],1));
    h_nhd_bh=sqrt(sum((n_step(58*3-[2,1],:)).^2))-norm(n_step(58*3-[2,1],1));
    figure
    plot(zb,h_whd_th,'k-^',zb,h_nhd_th,'k-o',zb,h_whd_bh,'k-v',zb,h_nhd_bh,'k-*','linewidth',1.5);
    set(gca,'fontsize',18);
    legend('�⻷���ڵ㣨H��','�ڻ����ڵ㣨H��','�⻷�׽ڵ㣨H��'...
        ,'�ڻ��׽ڵ㣨H��','location','southwest')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('λ��/m','fontsize',18);
    if saveimg==1
        saveas(gcf,'1�ڵ�λ��(H).png');
    end
    
    wdd_h1=sqrt(sum((n_step(2*3-[2,1],:)).^2))-norm(n_step(2*3-[2,1],1));
    wdd_v1=n_step(2*3,:)-n_step(2*3,1);
    wdd_h2=sqrt(sum((n_step(5*3-[2,1],:)).^2))-norm(n_step(5*3-[2,1],1));
    wdd_v2=n_step(5*3,:)-n_step(5*3,1);
    wdd_h3=sqrt(sum((n_step(8*3-[2,1],:)).^2))-norm(n_step(8*3-[2,1],1));
    wdd_v3=n_step(8*3,:)-n_step(8*3,1);
        figure
    plot(zb,wdd_h1,'k-^',zb,wdd_v1,'k-*','linewidth',1.5);
    set(gca,'fontsize',18);
    legend('����ڵ㣨H��','����ڵ㣨V��','location','southwest')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('λ��/m','fontsize',18);
    if saveimg==1
        saveas(gcf,'1��������������ڵ�λ��.png');
    end
    
    l_14=sqrt(sum((n_step(28*3-[2,1,0],:)-n_step(1*3-[2,1,0],:)).^2))-2*R;
    l_25=sqrt(sum((n_step(34*3-[2,1,0],:)-n_step(7*3-[2,1,0],:)).^2))-2*R;
    l_36=sqrt(sum((n_step(40*3-[2,1,0],:)-n_step(13*3-[2,1,0],:)).^2))-2*R;
    figure
    plot(zb,l_14,'k-o',zb,l_25,'k-^',zb,l_36,'k-v','linewidth',1.5);
    set(gca,'fontsize',18);
    legend('1-10��֧�����','3-12��֧�����','5-14��֧�����','location','southwest')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('λ��/m','fontsize',18);
    if saveimg==1
        saveas(gcf,'1֧��λ��.png');
    end
elseif direction==2
    figure
    plot(zb,t_step(152,:),'k-+',zb,t_step(153,:),'k-o',zb,t_step(178,:),'k-*',zb,t_step(179,:),'k-d',...
        zb,t_step(204,:),'k-.',zb,t_step(205,:),'k-^',zb,t_step(230,:),'k-x',zb,t_step(231,:),'k-v',...
        zb,t_step(256,:),'k->',zb,t_step(257,:),'k-<','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('�ڼ���1','�ڼ���1.5','�ڼ���3','�ڼ���3.5','�ڼ���5','�ڼ���5.5',...
        '�ڼ���7','�ڼ���7.5','�ڼ���9','�ڼ���9.5','location','northeast')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('����/N','fontsize',18);
    if saveimg==1
        saveas(gcf,[num2str(direction),'�ڻ���������.png']);
    end
 
    figure
    plot(zb,t_step(147,:),'k-+',zb,t_step(148,:),'k-o',zb,t_step(173,:),'k-*',zb,t_step(174,:),'k-d',...
        zb,t_step(199,:),'k-.',zb,t_step(200,:),'k-^',zb,t_step(225,:),'k-x',zb,t_step(226,:),'k-v',...
        zb,t_step(251,:),'k->',zb,t_step(252,:),'k-<','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('�⼹��1','�⼹��1.5','�⼹��3','�⼹��3.5','�⼹��5','�⼹��5.5',...
        '�⼹��7','�⼹��7.5','�⼹��9','�⼹��9.5','location','southwest')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('����/N','fontsize',18);
    if saveimg==1
        saveas(gcf,[num2str(direction),'�⻷��������.png']);
    end
    
    figure
    plot(zb,t_step(154,:),'k-+',zb,t_step(155,:),'k-o',zb,t_step(180,:),'k-*',zb,t_step(181,:),'k-d',...
        zb,t_step(206,:),'k-.',zb,t_step(207,:),'k-^',zb,t_step(232,:),'k-x',zb,t_step(233,:),'k-v',...
        zb,t_step(258,:),'k->',zb,t_step(259,:),'k-<','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('��б��1','��б��1.5','��б��3','��б��3.5','��б��5','��б��5.5',...
        '��б��7','��б��7.5','��б��9','��б��9.5','location','northwest')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('����/N','fontsize',18);
    if saveimg==1
        saveas(gcf,[num2str(direction),'�ڻ�б������.png']);
    end
    
    figure
    plot(zb,t_step(149,:),'k-+',zb,t_step(150,:),'k-o',zb,t_step(175,:),'k-*',zb,t_step(176,:),'k-d',...
        zb,t_step(201,:),'k-.',zb,t_step(202,:),'k-^',zb,t_step(227,:),'k-x',zb,t_step(228,:),'k-v',...
        zb,t_step(253,:),'k->',zb,t_step(254,:),'k-<','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('��б��1','��б��1.5','��б��3','��б��3.5','��б��5','��б��5.5',...
        '��б��7','��б��7.5','��б��9','��б��9.5','location','northwest')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('����/N','fontsize',18);
    if saveimg==1
        saveas(gcf,[num2str(direction),'�⻷б������.png']);
    end
    
    figure
plot(zb,t_step(157,:),'k-+',zb,t_step(170,:),'k-o',zb,t_step(183,:),'k-*',zb,t_step(196,:),'k-d',...
        zb,t_step(209,:),'k-.',zb,t_step(222,:),'k-^',zb,t_step(235,:),'k-x',zb,t_step(248,:),'k-v',...
        zb,t_step(261,:),'k->','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('�ڻ�����1','�ڻ�����2','�ڻ�����3','�ڻ�����4','�ڻ�����5','�ڻ�����6',...
        '�ڻ�����7','�ڻ�����8','�ڻ�����9','location','northeast')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('����/N','fontsize',18);
    if saveimg==1
        saveas(gcf,[num2str(direction),'�ڻ���������.png']);
    end
    
    figure
plot(zb,t_step(156,:),'k-+',zb,t_step(169,:),'k-o',zb,t_step(182,:),'k-*',zb,t_step(195,:),'k-d',...
        zb,t_step(208,:),'k-.',zb,t_step(221,:),'k-^',zb,t_step(234,:),'k-x',zb,t_step(247,:),'k-v',...
        zb,t_step(260,:),'k->','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('�ڻ���1','�ڻ���2','�ڻ���3','�ڻ���4','�ڻ���5','�ڻ���6',...
        '�ڻ���7','�ڻ���8','�ڻ���9','location','northwest')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('����/N','fontsize',18);
    if saveimg==1
        saveas(gcf,[num2str(direction),'�ڻ�������.png']);
    end
    
    figure
plot(zb,t_step(372,:),'k-+',zb,t_step(151,:),'k-o',zb,t_step(164,:),'k-*',zb,t_step(177,:),'k-d',...
        zb,t_step(190,:),'k-.',zb,t_step(203,:),'k-^',zb,t_step(216,:),'k-x',zb,t_step(229,:),'k-v',...
        zb,t_step(242,:),'k->','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('�⻷��1','�⻷��2','�⻷��3','�⻷��4','�⻷��5','�⻷��6',...
        '�⻷��7','�⻷��8','�⻷��9','location','northwest')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('����/N','fontsize',18);
    if saveimg==1
        saveas(gcf,[num2str(direction),'�⻷������.png']);
    end
    
    figure
plot(zb,t_step(146,:),'k-+',zb,t_step(159,:),'k-o',zb,t_step(172,:),'k-*',zb,t_step(185,:),'k-d',...
        zb,t_step(198,:),'k-.',zb,t_step(211,:),'k-^',zb,t_step(224,:),'k-x',zb,t_step(237,:),'k-v',...
        zb,t_step(250,:),'k->','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('������1','������2','������3','������4','������5','������6',...
        '������7','������8','������9','location','southwest')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('����/N','fontsize',18);
    if saveimg==1
        saveas(gcf,[num2str(direction),'����������.png']);
    end
    
    figure
plot(zb,t_step(145,:),'k-+',zb,t_step(158,:),'k-o',zb,t_step(171,:),'k-*',zb,t_step(184,:),'k-d',...
        zb,t_step(197,:),'k-.',zb,t_step(210,:),'k-^',zb,t_step(223,:),'k-x',zb,t_step(236,:),'k-v',...
        zb,t_step(249,:),'k->','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('������1','������2','������3','������4','������5','������6',...
        '������7','������8','������9','location','southwest')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('����/N','fontsize',18);
    if saveimg==1
        saveas(gcf,[num2str(direction),'����������.png']);
    end
    
        figure
plot(zb,n_step(3*56,:)-n_step(3*56,1),'k-+',zb,n_step(3*60,:)-n_step(3*60,1),'k-o',zb,n_step(3*64,:)-n_step(3*64,1),'k-*',zb,n_step(3*68,:)-n_step(3*68,1),'k-d',...
        zb,n_step(3*72,:)-n_step(3*72,1),'k-.',zb,n_step(3*76,:)-n_step(3*76,1),'k-^',zb,n_step(3*80,:)-n_step(3*80,1),'k-x',zb,n_step(3*84,:)-n_step(3*84,1),'k-v',...
        zb,n_step(3*88,:)-n_step(3*88,1),'k->','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('�ڻ����ڵ�1��Z��','�ڻ����ڵ�2��Z��','�ڻ����ڵ�3��Z��','�ڻ����ڵ�4��Z��'...
        ,'�ڻ����ڵ�5��Z��','�ڻ����ڵ�6��Z��','�ڻ����ڵ�7��Z��',...
        '�ڻ����ڵ�8��Z��','�ڻ����ڵ�9��Z��','location','southwest')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('λ��/m','fontsize',18);
    if saveimg==1
        saveas(gcf,[num2str(direction),'�ڻ����ڵ�λ��Z.png']);
    end
    

        figure
plot(zb,n_step(3*58,:)-n_step(3*58,1),'k-+',zb,n_step(3*62,:)-n_step(3*62,1),'k-o',zb,n_step(3*66,:)-n_step(3*66,1),'k-*',zb,n_step(3*70,:)-n_step(3*70,1),'k-d',...
        zb,n_step(3*74,:)-n_step(3*74,1),'k-.',zb,n_step(3*78,:)-n_step(3*78,1),'k-^',zb,n_step(3*82,:)-n_step(3*82,1),'k-x',zb,n_step(3*86,:)-n_step(3*86,1),'k-v',...
        zb,n_step(3*90,:)-n_step(3*90,1),'k->','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('�ڻ��׽ڵ�1��Z��','�ڻ��׽ڵ�2��Z��','�ڻ��׽ڵ�3��Z��','�ڻ��׽ڵ�4��Z��'...
        ,'�ڻ��׽ڵ�5��Z��','�ڻ��׽ڵ�6��Z��','�ڻ��׽ڵ�7��Z��',...
        '�ڻ��׽ڵ�8��Z��','�ڻ��׽ڵ�9��Z��','location','southwest')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('λ��/m','fontsize',18);
    if saveimg==1
        saveas(gcf,[num2str(direction),'�ڻ��׽ڵ�λ��Z.png']);
    end
    

        figure
plot(zb,n_step(3*55,:)-n_step(3*55,1),'k-+',zb,n_step(3*59,:)-n_step(3*59,1),'k-o',zb,n_step(3*63,:)-n_step(3*63,1),'k-*',zb,n_step(3*67,:)-n_step(3*67,1),'k-d',...
        zb,n_step(3*71,:)-n_step(3*71,1),'k-.',zb,n_step(3*75,:)-n_step(3*75,1),'k-^',zb,n_step(3*79,:)-n_step(3*79,1),'k-x',zb,n_step(3*83,:)-n_step(3*83,1),'k-v',...
        zb,n_step(3*87,:)-n_step(3*87,1),'k->','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('�⻷���ڵ�1��Z��','�⻷���ڵ�2��Z��','�⻷���ڵ�3��Z��','�⻷���ڵ�4��Z��'...
        ,'�⻷���ڵ�5��Z��','�⻷���ڵ�6��Z��','�⻷���ڵ�7��Z��',...
        '�⻷���ڵ�8��Z��','�⻷���ڵ�9��Z��','location','southwest')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('λ��/m','fontsize',18);
    if saveimg==1
        saveas(gcf,[num2str(direction),'�⻷���ڵ�λ��Z.png']);
    end
    

        figure
plot(zb,n_step(3*57,:)-n_step(3*57,1),'k-+',zb,n_step(3*61,:)-n_step(3*61,1),'k-o',zb,n_step(3*65,:)-n_step(3*65,1),'k-*',zb,n_step(3*69,:)-n_step(3*69,1),'k-d',...
        zb,n_step(3*73,:)-n_step(3*73,1),'k-.',zb,n_step(3*77,:)-n_step(3*77,1),'k-^',zb,n_step(3*81,:)-n_step(3*81,1),'k-x',zb,n_step(3*85,:)-n_step(3*85,1),'k-v',...
        zb,n_step(3*89,:)-n_step(3*89,1),'k->','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('�⻷�׽ڵ�1��Z��','�⻷�׽ڵ�2��Z��','�⻷�׽ڵ�3��Z��','�⻷�׽ڵ�4��Z��'...
        ,'�⻷�׽ڵ�5��Z��','�⻷�׽ڵ�6��Z��','�⻷�׽ڵ�7��Z��',...
        '�⻷�׽ڵ�8��Z��','�⻷�׽ڵ�9��Z��','location','southwest')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('λ��/m','fontsize',18);
    if saveimg==1
        saveas(gcf,[num2str(direction),'�⻷�׽ڵ�λ��Z.png']);
    end
    
    %%%
            figure
plot(zb,n_step(3*56-2,:)-n_step(3*56-2,1),'k-+',zb,n_step(3*60-2,:)-n_step(3*60-2,1),'k-o',zb,n_step(3*64-2,:)-n_step(3*64-2,1),'k-*',zb,n_step(3*68-2,:)-n_step(3*68-2,1),'k-d',...
        zb,n_step(3*72-2,:)-n_step(3*72-2,1),'k-.',zb,n_step(3*76-2,:)-n_step(3*76-2,1),'k-^',zb,n_step(3*80-2,:)-n_step(3*80-2,1),'k-x',zb,n_step(3*84-2,:)-n_step(3*84-2,1),'k-v',...
        zb,n_step(3*88-2,:)-n_step(3*88-2,1),'k->','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('�ڻ����ڵ�1��X��','�ڻ����ڵ�2��X��','�ڻ����ڵ�3��X��','�ڻ����ڵ�4��X��'...
        ,'�ڻ����ڵ�5��X��','�ڻ����ڵ�6��X��','�ڻ����ڵ�7��X��',...
        '�ڻ����ڵ�8��X��','�ڻ����ڵ�9��X��','location','southwest')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('λ��/m','fontsize',18);
    if saveimg==1
        saveas(gcf,[num2str(direction),'�ڻ����ڵ�λ��X.png']);
    end
    

        figure
plot(zb,n_step(3*58-2,:)-n_step(3*58-2,1),'k-+',zb,n_step(3*62-2,:)-n_step(3*62-2,1),'k-o',zb,n_step(3*66-2,:)-n_step(3*66-2,1),'k-*',zb,n_step(3*70-2,:)-n_step(3*70-2,1),'k-d',...
        zb,n_step(3*74-2,:)-n_step(3*74-2,1),'k-.',zb,n_step(3*78-2,:)-n_step(3*78-2,1),'k-^',zb,n_step(3*82-2,:)-n_step(3*82-2,1),'k-x',zb,n_step(3*86-2,:)-n_step(3*86-2,1),'k-v',...
        zb,n_step(3*90-2,:)-n_step(3*90-2,1),'k->','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('�ڻ��׽ڵ�1��X��','�ڻ��׽ڵ�2��X��','�ڻ��׽ڵ�3��X��','�ڻ��׽ڵ�4��X��'...
        ,'�ڻ��׽ڵ�5��X��','�ڻ��׽ڵ�6��X��','�ڻ��׽ڵ�7��X��',...
        '�ڻ��׽ڵ�8��X��','�ڻ��׽ڵ�9��X��','location','northwest')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('λ��/m','fontsize',18);
    if saveimg==1
        saveas(gcf,[num2str(direction),'�ڻ��׽ڵ�λ��X.png']);
    end
    

        figure
plot(zb,n_step(3*55-2,:)-n_step(3*55-2,1),'k-+',zb,n_step(3*59-2,:)-n_step(3*59-2,1),'k-o',zb,n_step(3*63-2,:)-n_step(3*63-2,1),'k-*',zb,n_step(3*67-2,:)-n_step(3*67-2,1),'k-d',...
        zb,n_step(3*71-2,:)-n_step(3*71-2,1),'k-.',zb,n_step(3*75-2,:)-n_step(3*75-2,1),'k-^',zb,n_step(3*79-2,:)-n_step(3*79-2,1),'k-x',zb,n_step(3*83-2,:)-n_step(3*83-2,1),'k-v',...
        zb,n_step(3*87-2,:)-n_step(3*87-2,1),'k->','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('�⻷���ڵ�1��X��','�⻷���ڵ�2��X��','�⻷���ڵ�3��X��','�⻷���ڵ�4��X��'...
        ,'�⻷���ڵ�5��X��','�⻷���ڵ�6��X��','�⻷���ڵ�7��X��',...
        '�⻷���ڵ�8��X��','�⻷���ڵ�9��X��','location','southwest')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('λ��/m','fontsize',18);
    if saveimg==1
        saveas(gcf,[num2str(direction),'�⻷���ڵ�λ��X.png']);
    end
    

        figure
plot(zb,n_step(3*57-2,:)-n_step(3*57-2,1),'k-+',zb,n_step(3*61-2,:)-n_step(3*61-2,1),'k-o',zb,n_step(3*65-2,:)-n_step(3*65-2,1),'k-*',zb,n_step(3*69-2,:)-n_step(3*69-2,1),'k-d',...
        zb,n_step(3*73-2,:)-n_step(3*73-2,1),'k-.',zb,n_step(3*77-2,:)-n_step(3*77-2,1),'k-^',zb,n_step(3*81-2,:)-n_step(3*81-2,1),'k-x',zb,n_step(3*85-2,:)-n_step(3*85-2,1),'k-v',...
        zb,n_step(3*89-2,:)-n_step(3*89-2,1),'k->','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('�⻷�׽ڵ�1��X��','�⻷�׽ڵ�2��X��','�⻷�׽ڵ�3��X��','�⻷�׽ڵ�4��X��'...
        ,'�⻷�׽ڵ�5��X��','�⻷�׽ڵ�6��X��','�⻷�׽ڵ�7��X��',...
        '�⻷�׽ڵ�8��X��','�⻷�׽ڵ�9��X��','location','northwest')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('λ��/m','fontsize',18);
    if saveimg==1
        saveas(gcf,[num2str(direction),'�⻷�׽ڵ�λ��X.png']);
    end
    %%%
    figure
plot(zb,t_step(55,:),'k-+',zb,t_step(56,:),'k-o',zb,t_step(57,:),'k-*',zb,t_step(58,:),'k-d',...
        zb,t_step(59,:),'k-.',zb,t_step(60,:),'k-^',zb,t_step(61,:),'k-x',zb,t_step(62,:),'k-v',...
        zb,t_step(63,:),'k->','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('������1','������2','������3','������4','������5','������6',...
        '������7','������8','������9','location','southwest')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('����/N','fontsize',18);
    if saveimg==1
        saveas(gcf,[num2str(direction),'����������.png']);
    end
    
    figure
plot(zb,t_step(73,:),'k-+',zb,t_step(77,:),'k-o',zb,t_step(81,:),'k-*',zb,t_step(85,:),'k-d',...
        zb,t_step(89,:),'k-.',zb,t_step(93,:),'k-^',zb,t_step(97,:),'k-x',zb,t_step(101,:),'k-v',...
        zb,t_step(105,:),'k->','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('��б��1','��б��2','��б��3','��б��4','��б��5','��б��6',...
        '��б��7','��б��8','��б��9','location','southwest')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('����/N','fontsize',18);
    if saveimg==1
        saveas(gcf,[num2str(direction),'��б������.png']);
    end
    
    figure
plot(zb,t_step(2,:),'k-+',zb,t_step(3,:),'k-o',zb,t_step(4,:),'k-*',zb,t_step(5,:),'k-d',...
        zb,t_step(6,:),'k-.',zb,t_step(7,:),'k-^',zb,t_step(8,:),'k-x',zb,t_step(9,:),'k-v',...
        zb,t_step(10,:),'k->','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('ˮƽ��1','ˮƽ��2','ˮƽ��3','ˮƽ��4','ˮƽ��5','ˮƽ��6',...
        'ˮƽ��7','ˮƽ��8','ˮƽ��9','location','southwest')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('����/N','fontsize',18);
    if saveimg==1
        saveas(gcf,[num2str(direction),'ˮƽ������.png']);
    end
    
    figure
plot(zb,t_step(20,:),'k-+',zb,t_step(22,:),'k-o',zb,t_step(24,:),'k-*',zb,t_step(26,:),'k-d',...
        zb,t_step(28,:),'k-.',zb,t_step(30,:),'k-^',zb,t_step(32,:),'k-x',zb,t_step(34,:),'k-v',...
        zb,t_step(36,:),'k->','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('�ȶ���1','�ȶ���2','�ȶ���3','�ȶ���4','�ȶ���5','�ȶ���6',...
        '�ȶ���7','�ȶ���8','�ȶ���9','location','northwest')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('����/N','fontsize',18);
    if saveimg==1
        saveas(gcf,[num2str(direction),'�ȶ�������.png']);
    end
    
    l_1=sqrt(sum((n_step(28*3-[2,1,0],:)-n_step(1*3-[2,1,0],:)).^2))-2*R;
    l_3=sqrt(sum((n_step(34*3-[2,1,0],:)-n_step(7*3-[2,1,0],:)).^2))-2*R;
    l_5=sqrt(sum((n_step(40*3-[2,1,0],:)-n_step(13*3-[2,1,0],:)).^2))-2*R;
    l_7=sqrt(sum((n_step(46*3-[2,1,0],:)-n_step(19*3-[2,1,0],:)).^2))-2*R;
    l_9=sqrt(sum((n_step(52*3-[2,1,0],:)-n_step(25*3-[2,1,0],:)).^2))-2*R;
      figure
    plot(zb,l_1,'k-o',zb,l_3,'k-^',zb,l_5,'k-v', zb,l_7,'k-.',zb,l_9,'k-x','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('1-10��֧�����','3-12��֧�����','5-14��֧�����','7-16��֧�����','9-18��֧�����','location','southwest')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('λ��/m','fontsize',18);
    if saveimg==1
        saveas(gcf,'1֧��λ��.png');
    end
    
    wdd_h1=sqrt(sum((n_step(2*3-[2,1],:)).^2))-norm(n_step(2*3-[2,1],1));
    wdd_v1=n_step(2*3,:)-n_step(2*3,1);
    wdd_h3=sqrt(sum((n_step(8*3-[2,1],:)).^2))-norm(n_step(8*3-[2,1],1));
    wdd_v3=n_step(8*3,:)-n_step(8*3,1);
    wdd_h5=sqrt(sum((n_step(14*3-[2,1],:)).^2))-norm(n_step(14*3-[2,1],1));
    wdd_v5=n_step(14*3,:)-n_step(14*3,1);
    wdd_h7=sqrt(sum((n_step(20*3-[2,1],:)).^2))-norm(n_step(20*3-[2,1],1));
    wdd_v7=n_step(20*3,:)-n_step(20*3,1);
    wdd_h9=sqrt(sum((n_step(26*3-[2,1],:)).^2))-norm(n_step(26*3-[2,1],1));
    wdd_v9=n_step(26*3,:)-n_step(26*3,1);   
       
    figure
     plot(zb,wdd_h1,'k-^',zb,wdd_h3,'k-o',zb,wdd_h5,'k-v',...
        zb,wdd_h7,'k-*',zb,wdd_h9,'k-+','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('����ڵ�1��H��','����ڵ�3��H��','����ڵ�5��H��',...
        '����ڵ�7��H��','����ڵ�9��H��','location','southwest')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('λ��/m','fontsize',18);
    if saveimg==1
        saveas(gcf,'1��������������ڵ�λ�ƣ�H��.png');
    end
    
        figure
     plot(zb,wdd_v1,'k-^',zb,wdd_v3,'k-o',zb,wdd_v5,'k-v',...
        zb,wdd_v7,'k-*',zb,wdd_v9,'k-+','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('����ڵ�1��V��','����ڵ�3��V��','����ڵ�5��V��',...
        '����ڵ�7��V��','����ڵ�9��V��','location','southwest')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('λ��/m','fontsize',18);
    if saveimg==1
        saveas(gcf,'1��������������ڵ�λ�ƣ�V��.png');
    end
    
    
    
    
else
       figure
    plot(zb,t_step(152,:),'k-+',zb,t_step(153,:),'k-o',zb,t_step(178,:),'k-*',zb,t_step(179,:),'k-d',...
        zb,t_step(204,:),'k-.',zb,t_step(205,:),'k-^',zb,t_step(230,:),'k-x',zb,t_step(231,:),'k-v',...
        zb,t_step(256,:),'k->',zb,t_step(257,:),'k-<','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('�ڼ���1','�ڼ���1.5','�ڼ���3','�ڼ���3.5','�ڼ���5','�ڼ���5.5',...
        '�ڼ���7','�ڼ���7.5','�ڼ���9','�ڼ���9.5','location','northeast')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('����/N','fontsize',18);
    if saveimg==1
        saveas(gcf,[num2str(direction),'�ڻ���������.png']);
    end
 
    figure
    plot(zb,t_step(147,:),'k-+',zb,t_step(148,:),'k-o',zb,t_step(173,:),'k-*',zb,t_step(174,:),'k-d',...
        zb,t_step(199,:),'k-.',zb,t_step(200,:),'k-^',zb,t_step(225,:),'k-x',zb,t_step(226,:),'k-v',...
        zb,t_step(251,:),'k->',zb,t_step(252,:),'k-<','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('�⼹��1','�⼹��1.5','�⼹��3','�⼹��3.5','�⼹��5','�⼹��5.5',...
        '�⼹��7','�⼹��7.5','�⼹��9','�⼹��9.5','location','northeast')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('����/N','fontsize',18);
    if saveimg==1
        saveas(gcf,[num2str(direction),'�⻷��������.png']);
    end
    
    figure
    plot(zb,t_step(154,:),'k-+',zb,t_step(155,:),'k-o',zb,t_step(180,:),'k-*',zb,t_step(181,:),'k-d',...
        zb,t_step(206,:),'k-.',zb,t_step(207,:),'k-^',zb,t_step(232,:),'k-x',zb,t_step(233,:),'k-v',...
        zb,t_step(258,:),'k->',zb,t_step(259,:),'k-<','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('��б��1','��б��1.5','��б��3','��б��3.5','��б��5','��б��5.5',...
        '��б��7','��б��7.5','��б��9','��б��9.5','location','northeast')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('����/N','fontsize',18);
    if saveimg==1
        saveas(gcf,[num2str(direction),'�ڻ�б������.png']);
    end
    
    figure
    plot(zb,t_step(149,:),'k-+',zb,t_step(150,:),'k-o',zb,t_step(175,:),'k-*',zb,t_step(176,:),'k-d',...
        zb,t_step(201,:),'k-.',zb,t_step(202,:),'k-^',zb,t_step(227,:),'k-x',zb,t_step(228,:),'k-v',...
        zb,t_step(253,:),'k->',zb,t_step(254,:),'k-<','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('��б��1','��б��1.5','��б��3','��б��3.5','��б��5','��б��5.5',...
        '��б��7','��б��7.5','��б��9','��б��9.5','location','northeast')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('����/N','fontsize',18);
    if saveimg==1
        saveas(gcf,[num2str(direction),'�⻷б������.png']);
    end
    
    figure
plot(zb,t_step(157,:),'k-+',zb,t_step(170,:),'k-o',zb,t_step(183,:),'k-*',zb,t_step(196,:),'k-d',...
        zb,t_step(209,:),'k-.',zb,t_step(222,:),'k-^',zb,t_step(235,:),'k-x',zb,t_step(248,:),'k-v',...
        zb,t_step(261,:),'k->','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('�ڻ�����1','�ڻ�����2','�ڻ�����3','�ڻ�����4','�ڻ�����5','�ڻ�����6',...
        '�ڻ�����7','�ڻ�����8','�ڻ�����9','location','southwest')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('����/N','fontsize',18);
    if saveimg==1
        saveas(gcf,[num2str(direction),'�ڻ���������.png']);
    end
    
    figure
plot(zb,t_step(156,:),'k-+',zb,t_step(169,:),'k-o',zb,t_step(182,:),'k-*',zb,t_step(195,:),'k-d',...
        zb,t_step(208,:),'k-.',zb,t_step(221,:),'k-^',zb,t_step(234,:),'k-x',zb,t_step(247,:),'k-v',...
        zb,t_step(260,:),'k->','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('�ڻ���1','�ڻ���2','�ڻ���3','�ڻ���4','�ڻ���5','�ڻ���6',...
        '�ڻ���7','�ڻ���8','�ڻ���9','location','southwest')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('����/N','fontsize',18);
    if saveimg==1
        saveas(gcf,[num2str(direction),'�ڻ�������.png']);
    end
    
    figure
plot(zb,t_step(372,:),'k-+',zb,t_step(151,:),'k-o',zb,t_step(164,:),'k-*',zb,t_step(177,:),'k-d',...
        zb,t_step(190,:),'k-.',zb,t_step(203,:),'k-^',zb,t_step(216,:),'k-x',zb,t_step(229,:),'k-v',...
        zb,t_step(242,:),'k->','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('�⻷��1','�⻷��2','�⻷��3','�⻷��4','�⻷��5','�⻷��6',...
        '�⻷��7','�⻷��8','�⻷��9','location','northeast')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('����/N','fontsize',18);
    if saveimg==1
        saveas(gcf,[num2str(direction),'�⻷������.png']);
    end
    
    figure
plot(zb,t_step(146,:),'k-+',zb,t_step(159,:),'k-o',zb,t_step(172,:),'k-*',zb,t_step(185,:),'k-d',...
        zb,t_step(198,:),'k-.',zb,t_step(211,:),'k-^',zb,t_step(224,:),'k-x',zb,t_step(237,:),'k-v',...
        zb,t_step(250,:),'k->','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('������1','������2','������3','������4','������5','������6',...
        '������7','������8','������9','location','southeast')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('����/N','fontsize',18);
    if saveimg==1
        saveas(gcf,[num2str(direction),'����������.png']);
    end
    
    figure
plot(zb,t_step(145,:),'k-+',zb,t_step(158,:),'k-o',zb,t_step(171,:),'k-*',zb,t_step(184,:),'k-d',...
        zb,t_step(197,:),'k-.',zb,t_step(210,:),'k-^',zb,t_step(223,:),'k-x',zb,t_step(236,:),'k-v',...
        zb,t_step(249,:),'k->','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('������1','������2','������3','������4','������5','������6',...
        '������7','������8','������9','location','southwest')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('����/N','fontsize',18);
    if saveimg==1
        saveas(gcf,[num2str(direction),'����������.png']);
    end
    
        figure
plot(zb,n_step(3*56,:)-n_step(3*56,1),'k-+',zb,n_step(3*60,:)-n_step(3*60,1),'k-o',zb,n_step(3*64,:)-n_step(3*64,1),'k-*',zb,n_step(3*68,:)-n_step(3*68,1),'k-d',...
        zb,n_step(3*72,:)-n_step(3*72,1),'k-.',zb,n_step(3*76,:)-n_step(3*76,1),'k-^',zb,n_step(3*80,:)-n_step(3*80,1),'k-x',zb,n_step(3*84,:)-n_step(3*84,1),'k-v',...
        zb,n_step(3*88,:)-n_step(3*88,1),'k->','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('�ڻ����ڵ�1��Z��','�ڻ����ڵ�2��Z��','�ڻ����ڵ�3��Z��','�ڻ����ڵ�4��Z��'...
        ,'�ڻ����ڵ�5��Z��','�ڻ����ڵ�6��Z��','�ڻ����ڵ�7��Z��',...
        '�ڻ����ڵ�8��Z��','�ڻ����ڵ�9��Z��','location','southwest')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('λ��/m','fontsize',18);
    if saveimg==1
        saveas(gcf,[num2str(direction),'�ڻ����ڵ�λ��Z.png']);
    end
    

        figure
plot(zb,n_step(3*58,:)-n_step(3*58,1),'k-+',zb,n_step(3*62,:)-n_step(3*62,1),'k-o',zb,n_step(3*66,:)-n_step(3*66,1),'k-*',zb,n_step(3*70,:)-n_step(3*70,1),'k-d',...
        zb,n_step(3*74,:)-n_step(3*74,1),'k-.',zb,n_step(3*78,:)-n_step(3*78,1),'k-^',zb,n_step(3*82,:)-n_step(3*82,1),'k-x',zb,n_step(3*86,:)-n_step(3*86,1),'k-v',...
        zb,n_step(3*90,:)-n_step(3*90,1),'k->','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('�ڻ��׽ڵ�1��Z��','�ڻ��׽ڵ�2��Z��','�ڻ��׽ڵ�3��Z��','�ڻ��׽ڵ�4��Z��'...
        ,'�ڻ��׽ڵ�5��Z��','�ڻ��׽ڵ�6��Z��','�ڻ��׽ڵ�7��Z��',...
        '�ڻ��׽ڵ�8��Z��','�ڻ��׽ڵ�9��Z��','location','southwest')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('λ��/m','fontsize',18);
    if saveimg==1
        saveas(gcf,[num2str(direction),'�ڻ��׽ڵ�λ��Z.png']);
    end
    

        figure
plot(zb,n_step(3*55,:)-n_step(3*55,1),'k-+',zb,n_step(3*59,:)-n_step(3*59,1),'k-o',zb,n_step(3*63,:)-n_step(3*63,1),'k-*',zb,n_step(3*67,:)-n_step(3*67,1),'k-d',...
        zb,n_step(3*71,:)-n_step(3*71,1),'k-.',zb,n_step(3*75,:)-n_step(3*75,1),'k-^',zb,n_step(3*79,:)-n_step(3*79,1),'k-x',zb,n_step(3*83,:)-n_step(3*83,1),'k-v',...
        zb,n_step(3*87,:)-n_step(3*87,1),'k->','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('�⻷���ڵ�1��Z��','�⻷���ڵ�2��Z��','�⻷���ڵ�3��Z��','�⻷���ڵ�4��Z��'...
        ,'�⻷���ڵ�5��Z��','�⻷���ڵ�6��Z��','�⻷���ڵ�7��Z��',...
        '�⻷���ڵ�8��Z��','�⻷���ڵ�9��Z��','location','southwest')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('λ��/m','fontsize',18);
    if saveimg==1
        saveas(gcf,[num2str(direction),'�⻷���ڵ�λ��Z.png']);
    end
    

        figure
plot(zb,n_step(3*57,:)-n_step(3*57,1),'k-+',zb,n_step(3*61,:)-n_step(3*61,1),'k-o',zb,n_step(3*65,:)-n_step(3*65,1),'k-*',zb,n_step(3*69,:)-n_step(3*69,1),'k-d',...
        zb,n_step(3*73,:)-n_step(3*73,1),'k-.',zb,n_step(3*77,:)-n_step(3*77,1),'k-^',zb,n_step(3*81,:)-n_step(3*81,1),'k-x',zb,n_step(3*85,:)-n_step(3*85,1),'k-v',...
        zb,n_step(3*89,:)-n_step(3*89,1),'k->','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('�⻷�׽ڵ�1��Z��','�⻷�׽ڵ�2��Z��','�⻷�׽ڵ�3��Z��','�⻷�׽ڵ�4��Z��'...
        ,'�⻷�׽ڵ�5��Z��','�⻷�׽ڵ�6��Z��','�⻷�׽ڵ�7��Z��',...
        '�⻷�׽ڵ�8��Z��','�⻷�׽ڵ�9��Z��','location','southwest')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('λ��/m','fontsize',18);
    if saveimg==1
        saveas(gcf,[num2str(direction),'�⻷�׽ڵ�λ��Z.png']);
    end
    
    %%%
            figure
plot(zb,n_step(3*56-2,:)-n_step(3*56-2,1),'k-+',zb,n_step(3*60-2,:)-n_step(3*60-2,1),'k-o',zb,n_step(3*64-2,:)-n_step(3*64-2,1),'k-*',zb,n_step(3*68-2,:)-n_step(3*68-2,1),'k-d',...
        zb,n_step(3*72-2,:)-n_step(3*72-2,1),'k-.',zb,n_step(3*76-2,:)-n_step(3*76-2,1),'k-^',zb,n_step(3*80-2,:)-n_step(3*80-2,1),'k-x',zb,n_step(3*84-2,:)-n_step(3*84-2,1),'k-v',...
        zb,n_step(3*88-2,:)-n_step(3*88-2,1),'k->','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('�ڻ����ڵ�1��X��','�ڻ����ڵ�2��X��','�ڻ����ڵ�3��X��','�ڻ����ڵ�4��X��'...
        ,'�ڻ����ڵ�5��X��','�ڻ����ڵ�6��X��','�ڻ����ڵ�7��X��',...
        '�ڻ����ڵ�8��X��','�ڻ����ڵ�9��X��','location','southwest')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('λ��/m','fontsize',18);
    if saveimg==1
        saveas(gcf,[num2str(direction),'�ڻ����ڵ�λ��X.png']);
    end
    

        figure
plot(zb,n_step(3*58-2,:)-n_step(3*58-2,1),'k-+',zb,n_step(3*62-2,:)-n_step(3*62-2,1),'k-o',zb,n_step(3*66-2,:)-n_step(3*66-2,1),'k-*',zb,n_step(3*70-2,:)-n_step(3*70-2,1),'k-d',...
        zb,n_step(3*74-2,:)-n_step(3*74-2,1),'k-.',zb,n_step(3*78-2,:)-n_step(3*78-2,1),'k-^',zb,n_step(3*82-2,:)-n_step(3*82-2,1),'k-x',zb,n_step(3*86-2,:)-n_step(3*86-2,1),'k-v',...
        zb,n_step(3*90-2,:)-n_step(3*90-2,1),'k->','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('�ڻ��׽ڵ�1��X��','�ڻ��׽ڵ�2��X��','�ڻ��׽ڵ�3��X��','�ڻ��׽ڵ�4��X��'...
        ,'�ڻ��׽ڵ�5��X��','�ڻ��׽ڵ�6��X��','�ڻ��׽ڵ�7��X��',...
        '�ڻ��׽ڵ�8��X��','�ڻ��׽ڵ�9��X��','location','southwest')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('λ��/m','fontsize',18);
    if saveimg==1
        saveas(gcf,[num2str(direction),'�ڻ��׽ڵ�λ��X.png']);
    end
    

        figure
plot(zb,n_step(3*55-2,:)-n_step(3*55-2,1),'k-+',zb,n_step(3*59-2,:)-n_step(3*59-2,1),'k-o',zb,n_step(3*63-2,:)-n_step(3*63-2,1),'k-*',zb,n_step(3*67-2,:)-n_step(3*67-2,1),'k-d',...
        zb,n_step(3*71-2,:)-n_step(3*71-2,1),'k-.',zb,n_step(3*75-2,:)-n_step(3*75-2,1),'k-^',zb,n_step(3*79-2,:)-n_step(3*79-2,1),'k-x',zb,n_step(3*83-2,:)-n_step(3*83-2,1),'k-v',...
        zb,n_step(3*87-2,:)-n_step(3*87-2,1),'k->','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('�⻷���ڵ�1��X��','�⻷���ڵ�2��X��','�⻷���ڵ�3��X��','�⻷���ڵ�4��X��'...
        ,'�⻷���ڵ�5��X��','�⻷���ڵ�6��X��','�⻷���ڵ�7��X��',...
        '�⻷���ڵ�8��X��','�⻷���ڵ�9��X��','location','southwest')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('λ��/m','fontsize',18);
    if saveimg==1
        saveas(gcf,[num2str(direction),'�⻷���ڵ�λ��X.png']);
    end
    

        figure
plot(zb,n_step(3*57-2,:)-n_step(3*57-2,1),'k-+',zb,n_step(3*61-2,:)-n_step(3*61-2,1),'k-o',zb,n_step(3*65-2,:)-n_step(3*65-2,1),'k-*',zb,n_step(3*69-2,:)-n_step(3*69-2,1),'k-d',...
        zb,n_step(3*73-2,:)-n_step(3*73-2,1),'k-.',zb,n_step(3*77-2,:)-n_step(3*77-2,1),'k-^',zb,n_step(3*81-2,:)-n_step(3*81-2,1),'k-x',zb,n_step(3*85-2,:)-n_step(3*85-2,1),'k-v',...
        zb,n_step(3*89-2,:)-n_step(3*89-2,1),'k->','linewidth',1.5);
    set(gca,'fontsize',12);
    legend('�⻷�׽ڵ�1��X��','�⻷�׽ڵ�2��X��','�⻷�׽ڵ�3��X��','�⻷�׽ڵ�4��X��'...
        ,'�⻷�׽ڵ�5��X��','�⻷�׽ڵ�6��X��','�⻷�׽ڵ�7��X��',...
        '�⻷�׽ڵ�8��X��','�⻷�׽ڵ�9��X��','location','northwest')
    xlabel('�����Ӳ�','fontsize',18);
    ylabel('λ��/m','fontsize',18);
    if saveimg==1
        saveas(gcf,[num2str(direction),'�⻷�׽ڵ�λ��X.png']);
    end
 
end

end

