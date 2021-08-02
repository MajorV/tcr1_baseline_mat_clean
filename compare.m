load results_avg 
FAR_all = FAR_all;
PD_all = PD_all;
a = plot(FAR_all,PD_all,'LineWidth',2);M1 = "tcr1 avg";
figure(1);
hold on
legend([a], [M1],'Location','southeast');

load ../tcr1_baseline_results/results_tcr1_day_decimated.mat
maxv=max(max(FAs), max(dets));
minv=min(min(FAs),min(dets));
step=(maxv-minv)/1000;
PD=[];
FAR=[];
for t=minv:step:maxv
    Pd=sum(dets>t)/Ntgt;
    PD=[PD Pd];
    far=sum(FAs>t)/(Nframes*3.4*2.6);
    FAR=[FAR far];
end
b = plot(FAR,PD,'LineWidth',2);M2 = "tcr1 published";
legend([a, b], [M1, M2],'Location','southeast');