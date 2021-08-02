target_path = '/home/bruce/data/ATR/new_samplesets/unscaled_1to2/chips40x80/targets';
files = dir(target_path);
nfiles = length(files) - 2;

d1 = 40;
d2 = 80;
all_targets = zeros(d1,d2,nfiles);

idx = 1;
for i = 3:nfiles;
   filename = files(i).name;
   load([target_path '/' filename]);
   target_chip=target_chip - mean2(target_chip);
   all_targets(:,:,idx) = target_chip;
   idx = idx + 1;
end
% figure (1); imagesc(all_targets(:,:,10)); colormap gray; colorbar; axis('image');drawnow;
save tcr1_training_targets all_targets

clutter_path =  '/home/bruce/data/ATR/new_samplesets/unscaled_1to2/chips40x80/clutter';
files = dir(clutter_path);
nfiles = length(files) - 2;
all_clutter = zeros(d1,d2,nfiles);

idx = 1;
for i = 3:nfiles;
   filename = files(i).name;
   load([clutter_path '/' filename]);
   clutter_chip=clutter_chip - mean2(clutter_chip);
   all_clutter(:,:,idx) = clutter_chip;
   idx = idx + 1;
end
% figure (2); imagesc(all_clutter(:,:,10)); colormap gray; colorbar; axis('image');drawnow;
save tcr1_training_clutter all_clutter