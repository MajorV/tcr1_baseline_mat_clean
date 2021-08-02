% ntrials = 3
% base_name = 'results_day_dec'
function avg_roc(base_name,ntrials);
FAR_all = zeros(1,1001);
PD_all = zeros(1,1001);

 figure(1)
hold on
for n = 1:ntrials
file = [base_name num2str(n) '.mat']
load (file)

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
FAR_all = FAR_all + FAR;
PD_all = PD_all + PD;
plot(FAR,PD,'LineWidth',1);
end
FAR_all = FAR_all/ntrials;
PD_all = PD_all/ntrials;
a = plot(FAR_all,PD_all,'LineWidth',2);M1 = "average";
legend([a], [M1],'Location','southeast');
save results_avg FAR_all PD_all Ntgt Nframes
end




