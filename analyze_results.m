load results_day_dec1
cats = ["PICKUP", "SUV", "BTR70", "BRDM2", "BMP2", "T72", "2S3", "ZSU23","D20","MTLB"]
ranges = [2.5 3 3.5]
top = 5
results = zeros(length(cats),length(ranges),2);
missed = {}

for h = 1 : length(sample_set)
    for i = 1 : length(sample_set(h).targets)
        for j = 1 : length(cats)
            if sample_set(h).targets(i).category == cats(j)
            for k = 1 : length(ranges)
                if sample_set(h).range == ranges(k)
                    results(j,k,1) = results(j,k,1) + 1;
                    if (sample_set(h).targets(i).result <= top)
                    results(j,k,2) = results(j,k,2) + 1;
                    else
                         %didn't make cut
                        missed = [missed [sample_set(h).name '_' sample_set(h).frame ]];
                    end
                    
                    
                end
            end  
            end
        end
    end
end
results = round((results(:,:,2)./results(:,:,1)*100));
varnames = ["2500m","3000m","3500m"];
T = table(results(:,1),results(:,2),results(:,3),'RowNames',cats,'VariableNames',varnames);
uitable('Data',T{:,:},'ColumnName',T.Properties.VariableNames,...
    'RowName',T.Properties.RowNames,'Units', 'Normalized', 'Position',[0, 0, 1, 1]);

