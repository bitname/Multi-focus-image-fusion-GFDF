function mValues=EvalFusion(A,B,F)
if size(A,3)>1
    A=rgb2gray(A);
    B=rgb2gray(B);
    F=rgb2gray(F);
end
   QG = metricXydeas(A,B,F);% Xydeas,2000
   QP = metricZhao(A,B,F);% ZhaoJiying,2007
   QY = metricYang(A,B,F);% YangCui,2008
   QCB = metricChenBlum(A,B,F);% ChenYin,2009
   QFMI = using_FMI(A,B,F,'gradient');% Haghighat,2014
   mValues = table(QG,QP,QY,QCB,QFMI);
disp(['|QG=',num2str(QG,'%0.4f'), '|QP=',num2str(QP,'%0.4f')...
      '|QY=',num2str(QY,'%0.4f'),'|QCB=',num2str(QCB,'%0.4f'),'|QFMI=',num2str(QFMI,'%0.4f'),'|'])
end