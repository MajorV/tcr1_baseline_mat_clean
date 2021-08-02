
function [S,N1,N2]=make_basis(A,AC,B,BC,sth);

%Make the best separation basis function

%B=2*B;
[d,d,L]=size(A);
S=zeros(d,100,L);
D=zeros(100,L);
J=[];
wts=zeros(d,L);
Nvec=[];
for i=1:L
    S=AC(:,:,i)+BC(:,:,i);
        [phi,del]=eig(S);
        [tmp,I]=sort(diag(del));
        tmp2=cumsum(tmp)/sum(tmp);
        index=sum(tmp2<sth); %.04 for first pass, 0.02 for second
        tmp=tmp(index:d);
        phi=phi(:,I);
        phi=phi(:,index:length(I));
        Sinv=phi*inv(diag(tmp))*phi';

    
    T=Sinv*(A-B);
    
    [phi,del]=eig(T);
    [tmp,I]=sort(diag(real(del)));
    phi=phi(:,I);

    S1=phi(:,find(tmp>0.01));
    S2=phi(:,find(tmp<-0.01));
    [d,N1]=size(S1); [d,N2]=size(S2);
    S=[S2 S1];
    figure(1); clf;plot(tmp);
    ylabel('Eigen Value'); xlabel('Eigen Vector Number');
    title ('Eigenvalues for clutter and target class')
     
end
end

