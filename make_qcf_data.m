d1 = 20;
d2 = 40;

target_path =  '/home/bruce/data/ATR/new_samplesets/unscaled_1to2/chips20x40/targets';
files = dir([target_path '/*.mat']);
nfiles = length(files)
all_targets = zeros(d1,d2,nfiles);
idx = 1;
for i = 1:nfiles;
   filename = files(i).name
   load([target_path '/' filename]);
   target_chip=target_chip - mean2(target_chip);
   all_targets(:,:,idx) = target_chip;
   idx = idx + 1;
end
% save qcf_target_data all_targets

% figure (1); imagesc(all_targets(:,:,10)); colormap gray; colorbar; axis('image');drawnow;

clutter_path =  '/home/bruce/data/ATR/new_samplesets/unscaled_1to2/chips20x40/clutter';
files = dir([clutter_path '/*.mat']);
nfiles = length(files)
all_clutter = zeros(d1,d2,nfiles);
idx = 1;
for i = 1:nfiles;
   filename = files(i).name
   load([clutter_path '/' filename]);
   clutter_chip = clutter_chip - mean2(clutter_chip);
   all_clutter(:,:,idx) = clutter_chip;
   idx = idx + 1;
end
% save qcf_clutter_data all_clutter
% figure (2); imagesc(all_clutter(:,:,10)); colormap gray; colorbar;axis('image');drawnow; 
%Estimate_Rx********************************************
target_acf=zeros(d1*d2);

% load qcf_target_data

Nfiles=size(all_targets,3)

for i=1:Nfiles;
    x=all_targets(:,:,i);
    target_acf=target_acf+x(:)*x(:)';

end
target_acf=target_acf/Nfiles;


% load qcf_clutter_data
R2=zeros(d1*d2);

Nfiles=size(all_clutter,3);

acf=zeros(2*d1-1,2*d2-1);

count=0;
for i=1:Nfiles;
    count=count+1;
    x=all_clutter(:,:,i);
    %figure(1); imagesc(x); colormap gray; drawnow
    x2=flipud(fliplr(x));
    tmp=conv2(x,x2,'full');
    if count > 1
        acf=(acf*(count-1)+tmp)/count;
    else
        acf=tmp;
    end
    i
end
mask=ones(d1,d2);
pmask=conv2(mask,mask,'full');
Ex2=acf./pmask;
cov_function=Ex2;%-E2x;
clutter_acf=acf2cm(cov_function);
save acfs target_acf clutter_acf
d1 = 20;
d2 = 40;

target_path =  '/home/bruce/data/ATR/new_samplesets/unscaled_1to2/chips20x40/targets';
files = dir([target_path '/*.mat']);
nfiles = length(files)
all_targets = zeros(d1,d2,nfiles);
idx = 1;
for i = 1:nfiles;
   filename = files(i).name
   load([target_path '/' filename]);
   target_chip=target_chip - mean2(target_chip);
   all_targets(:,:,idx) = target_chip;
   idx = idx + 1;
end
% save qcf_target_data all_targets

% figure (1); imagesc(all_targets(:,:,10)); colormap gray; colorbar; axis('image');drawnow;

clutter_path =  '/home/bruce/data/ATR/new_samplesets/unscaled_1to2/chips20x40/clutter';
files = dir([clutter_path '/*.mat']);
nfiles = length(files)
all_clutter = zeros(d1,d2,nfiles);
idx = 1;
for i = 1:nfiles;
   filename = files(i).name
   load([clutter_path '/' filename]);
   clutter_chip = clutter_chip - mean2(clutter_chip);
   all_clutter(:,:,idx) = clutter_chip;
   idx = idx + 1;
end
% save qcf_clutter_data all_clutter
% figure (2); imagesc(all_clutter(:,:,10)); colormap gray; colorbar;axis('image');drawnow; 
%Estimate_Rx********************************************
target_acf=zeros(d1*d2);

% load qcf_target_data

Nfiles=size(all_targets,3)

for i=1:Nfiles;
    x=all_targets(:,:,i);
    target_acf=target_acf+x(:)*x(:)';

end
target_acf=target_acf/Nfiles;


% load qcf_clutter_data
R2=zeros(d1*d2);

Nfiles=size(all_clutter,3);

acf=zeros(2*d1-1,2*d2-1);

count=0;
for i=1:Nfiles;
    count=count+1;
    x=all_clutter(:,:,i);
    %figure(1); imagesc(x); colormap gray; drawnow
    x2=flipud(fliplr(x));
    tmp=conv2(x,x2,'full');
    if count > 1
        acf=(acf*(count-1)+tmp)/count;
    else
        acf=tmp;
    end
    i
end
mask=ones(d1,d2);
pmask=conv2(mask,mask,'full');
Ex2=acf./pmask;
cov_function=Ex2;%-E2x;
clutter_acf=acf2cm(cov_function);
save acfs target_acf clutter_acf
function CM=acf2cm(acf);

%Construct the Covariance matrix from the acf
%Input is linear ACF.
%ACF must be divided (normalized) by total number of samples.

[m,n]=size(acf);

d1=(m+1)/2;
d2=(n+1)/2;
dim=d1*d2;
CM=zeros(dim);

row_index=kron([1:d1]',ones(1,d2));
row_index=row_index(:);
col_index=kron(ones(d1,1),[1:d2]);
col_index=col_index(:);
IV=[row_index col_index];

for i=1:dim
   for j=i:dim
      index=IV(j,:)-IV(i,:);
      row=d1+index(1);
      col=d2+index(2);
      CM(i,j)=acf(row,col);
      CM(j,i)=CM(i,j);
   end
end
end