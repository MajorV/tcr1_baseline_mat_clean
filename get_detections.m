function [confs,row_dets,col_dets]=get_detections(Y,Nfind);
%Nfind max number of detections
[row_dets,col_dets,confs]=fastPdet2(Y,Nfind);

%extreme distribution function
confs=confs';
Aah=std(confs)*sqrt(6)/pi;
cent=mean(confs)-Aah*0.577216649;
confs=(confs-cent)/Aah;


% figure(2); imagesc(im_copy); axis('image');colormap gray


% for i=1:min(N,10)
%     text(col_dets(i),row_dets(i),num2str(i), 'color','w');
% end

function [R,C,psr1]=fastPdet2(g1, Ndet);

[M,N]=size(g1);
R=[]; C=[]; psr1=[];
ming=min(g1(:));% find minimum response value

%for the requested # of detections find the max
%value in the array and its row and column
%then replace this value and the surrounding 
%20x40 box with the minimum previously found,
%effectively doing non-max suppression
for i=1:Ndet
   [p,col]=max(max(g1));
   [p,row]=max(g1(:,col));
   R=[R;row]; C=[C;col];
%    r1=max(row-10,1); r2=min(r1+19,M); r1=r2-19;
   r1=max(row-20,1); r2=min(r1+39,M); r1=r2-39;

   c1=max(col-20,1); c2=min(c1+39,N); c1=c2-39;
   psr1=[psr1;p];
   g1(r1:r2,c1:c2)=ones(r2-r1+1,c2-c1+1)*ming;
end