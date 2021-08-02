%%
make_qcf_data
make_cnn_training_data
%%
load acfs
[S,N1,N2]=make_basis(.5*target_acf,.5*target_acf,clutter_acf,clutter_acf,.001);
save basis_set S N1 N2
make_tcr1_model
%%
ntrials = 5
test_set = '/mnt/newdrive/projects/tcr_lab/data/nvesd1/datasets/far_day_decimated.json';
for n = 1:ntrials
    trained_net = train_cnn()
    save (['tcr1net_trained_' num2str(n) '.mat'],'trained_net')
    
    base_name = 'results_day_dec'
    results_file = [base_name num2str(n)]
    test_cnn(test_set,trained_net,results_file)
end

avg_roc(base_name,ntrials)

