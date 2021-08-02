function test_cnn(sample_set_path,net,output_name);
disp(output_name)
imgdir = '/home/bruce/data/ATR/matlab/';
sample_set = jsondecode(fileread(sample_set_path));
num_samples = size(sample_set)

display_detections = 0;

Nframes=0;
index=0;
dets=[];
FAs=[];
Nframes=0;
Ntgt=0;

for sample_idx = 1:num_samples
    disp(sample_idx)
    
    sample = sample_set(sample_idx);
    file = [imgdir sample.name '_' sample.frame '.mat'];
    range = sample.range * 1000;
    abc = load(file); %loads image as 'image'
    image = abc.image;
    im_scale=range/2500; 
    im_scaled=gpuArray(imresize(image,im_scale,'bilinear'));
    if display_detections
    figure (1); imagesc(image); colormap gray;

    end

    
    response = cnn_detector(im_scaled,net);

    max_detects = 20;
    [confs,row_dets,col_dets] = get_detections(response,max_detects);
    
    row_dets=row_dets'/im_scale;
    col_dets=col_dets'/im_scale;
    
    targets = sample.targets;
    Nframes=Nframes+1; %count of total number of frames processed.
    Nt=length(sample.targets); %number of targets in frame
    Ntgt=Ntgt+Nt; % count of total number of targets 
    Ndets=length(confs); %number of detections in frame
    foundtgt=zeros(Ndets,1);
%     disp([imgdir sample.name '_' sample.frame]);
    hit_distance = 20; %max distance between target center and detection for a hit
    for k=1:Nt
%                     disp(targets(k).category)
                    r=targets(k).center(2); c=targets(k).center(1);
                    
                    tmpdets=[];
                    for lidx=1:Ndets
                        dist=sqrt((r-row_dets(lidx))^2+(c-col_dets(lidx))^2);
                        if dist <hit_distance
                            sample_set(sample_idx).targets(k).result = lidx;
                            foundtgt(lidx)=1;
                            tmpdets=[tmpdets confs(lidx)];
                        end
                        
                    end
                    if (sum(foundtgt) == 0)
                        sample_set(sample_idx).targets(k).result = lidx;
                    end
                    dets=[dets max(tmpdets)];
                    misses=find(foundtgt==0);
                    FAs=[FAs confs(misses)];

    end
    if display_detections
    for i=1:min(Ndets,max_detects)
        if (confs(i) >0)
        score = num2str(confs(i));
    text(gather(col_dets(i)),gather(row_dets(i)),score(1:4), 'color','g');
        end
    end
    text(c,r,'x','color','r');
    abcd = input('waiting')
    end
end
save (output_name, 'FAs', 'dets', 'Ntgt', 'Nframes', 'sample_set')

% save results_tcr1_day_decimated FAs dets Ntgt Nframes sample_set

end