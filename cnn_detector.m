% function [confs,row_dets,col_dets,im_scale]=cnn_detector(im,range);
function [Y]=cnn_detector(im,net);

% im=gpuArray(imresize(im,im_scale,'bilinear'));
% im=gpuArray(im);
[d1,d2]=size(im);

imrow=d1; imcol=d2;


% load tcr1net_trained


nL=2;
L1wts=net.Layers(nL).Weights; B1=net.Layers(nL).Bias;
B1tm=net.Layers(nL+1).TrainedMean;B1tv=net.Layers(nL+1).TrainedVariance;B1off=net.Layers(nL+1).Offset;B1s=net.Layers(nL+1).Scale;
nL=5;
L2wts=net.Layers(nL).Weights; B2=net.Layers(nL).Bias;
B2tm=net.Layers(nL+1).TrainedMean;B2tv=net.Layers(nL+1).TrainedVariance;B2off=net.Layers(nL+1).Offset;B2s=net.Layers(nL+1).Scale;
nL=8;
L3wts=net.Layers(nL).Weights; B3=net.Layers(nL).Bias;
B3tm=net.Layers(nL+1).TrainedMean;B3tv=net.Layers(nL+1).TrainedVariance;B3off=net.Layers(nL+1).Offset;B3s=net.Layers(nL+1).Scale;
nL=11;
L4wts=net.Layers(nL).Weights; B4=net.Layers(nL).Bias;

% tic


% Layer 1
Y=convlayer(im,L1wts,B1);
Y=batchnorm(Y,B1tm,B1tv,B1off,B1s);
mask=Y>0;
Lout=mask.*Y+0.1*(1-mask).*Y;

% Layer 2
Y=convlayer(Lout,L2wts,B2);
Y=batchnorm(Y,B2tm,B2tv,B2off,B2s);
mask=Y>0;
Lout=mask.*Y+0.1*(1-mask).*Y;

% Layer 3
Y=convlayer(Lout,L3wts,B3);
Y=batchnorm(Y,B3tm,B3tv,B3off,B3s);
mask=Y>0;
Lout=mask.*Y+0.01*(1-mask).*Y;

% Layer 4
Y=convlayer(Lout,L4wts,B4);
% mask=Y>0;
% Lout=mask.*Y+0.01*(1-mask).*Y;

% Layer 5
% Y=convlayer(Lout,L5wts,B5);
% toc

Y=Y.^2;
% figure (3); imagesc(Y); colormap gray; colorbar; 
Y=padgpu(Y,imrow,imcol);



function Y=batchnorm(X,Btm,Btv,Boff,Bs);

N=size(Btm,3);
Y=X;
for i=1:N
    x=Y(:,:,i);
    x=(x-Btm(i))/sqrt(1e-5+Btv(i));
    Y(:,:,i)=x*Bs(i)+Boff(i);
end

function Y=convlayer(im,L1wts,B1)

d1=size(im,1); d2=size(im,2);
f1=size(L1wts,1); f2=size(L1wts,2);
Nfilts=size(L1wts,4);
Nstack=size(L1wts,3);


% Y=single(zeros(d1-f1+1, d2-f2+1,Nfilts));
Y=gpuArray(single(zeros(d1-f1+1, d2-f2+1,Nfilts)));


% parfor i=1:Nfilts
for i=1:Nfilts

%     tmp=single(zeros(d1-f1+1,d2-f2+1));
        tmp=gpuArray(single(zeros(d1-f1+1,d2-f2+1)));


   for j=1:Nstack
        h=L1wts(:,:,j,i);
        tmp=tmp+filter2(h,im(:,:,j),'valid');
    end
    Y(:,:,i)=tmp+B1(1,1,i);
end

function y=padgpu(x,d1,d2);

y=gpuArray(zeros(d1,d2));
% y=zeros(d1,d2);


[m,n]=size(x);

o1=d1/2+1;
o2=d2/2+1;

r1=round(o1-m/2);
r2=round(r1+m-1);

c1= round(o2-n/2);
c2=round(c1+n-1);

y(r1:r2,c1:c2)=x;




