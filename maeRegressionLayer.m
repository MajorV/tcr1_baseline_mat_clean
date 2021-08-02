classdef maeRegressionLayer < nnet.layer.RegressionLayer
    % Example custom regression layer with mean-absolute-error loss.
    
    methods
        function layer = maeRegressionLayer(name)
            % layer = maeRegressionLayer(name) creates a
            % mean-absolute-error regression layer and specifies the layer
            % name.
            
            % Set layer name.
            layer.Name = name;
            
            % Set layer description.
            layer.Description = 'Minimum Average Energy';
        end
        
        function loss = forwardLoss(layer, Y, T)
            % loss = forwardLoss(layer, Y, T) returns the MAE loss between
            % the predictions Y and the training targets T.
            %T is non-zero for true class
            
            % Calculate MAE.
            R = size(Y,3); %number of channels.
            
            T_copy=T; 
            T=squeeze(sum(sum(T,1),2));
            I=find(T~=0); J=find(T==0); %Find the true and false class outputs
            
            tmp=T_copy(:,:,1,I(1)); %find desired peak location
            [v,col]=max(max(tmp));
            [v,row]=max(tmp(:,col));
            
            Y1=Y(:,:,:,I); %true class
            Y2=Y(:,:,:,J); %false class
            Y1=Y1.^2;
            Y2=Y2.^2;
            E1=squeeze(Y1(row,col,:,:)); %true class energy at peak
            E2=squeeze(sum(sum(Y2,1),2)); %false class energy
            
            N1=length(E1); N2=length(E2);
            
            loss1=0;
            if N1~=0
                loss1=(sum(E1)/N1);
            end

            loss2=0;
            if N2~=0
                loss2=(sum(E2)/N2);
            end
            
            loss=loss2/loss1;
            
        end
        
        function dLdY = backwardLoss(layer, Y, T)
            % Returns the derivatives of the MAE loss with respect to the predictions Y
            % T is non-zero for the true class.
            
            R = size(Y,3);
            N = size(Y,4);
            
            T_copy=T;
            T=squeeze(sum(sum(T,1),2));
            T=(T~=0); %T is now 1 for true class, 0 for false class
            I=find(T~=0); J=find(T==0); %find the true and class outputs
            
            tmp=T_copy(:,:,1,I(1));
            [d1,d2]=size(tmp);
            [v,col]=max(max(tmp));
            [v,row]=max(tmp(:,col));
            
            U=zeros(size(tmp)); %Support region for peak
            Ub=U;
            U(row,col)=1; %Peak support
            Ub=U;
            Nd=d1*d2;
            Np=sum(U(:));
            %Ub(row-2:row+2,col-2:col+2)=ones(5); %dont care region around peak

            
            
            Y1=Y(:,:,:,I);
            E1=[];
            E1b=[];
            M1=[];
            for i=1:length(I)
                tmp=U.*Y1(:,:,1,i);
                M1=[M1 tmp(row,col)];
                E1=[E1 tmp(:)'*tmp(:)]; %Peak energy for true class
                tmp_b=(1-Ub).*Y1(:,:,1,i);
                E1b=[E1b tmp_b(:)'*tmp_b(:)];
            end
%             E1=E1/(U(:)'*U(:));
%             E1b=E1b/(d1*d2-U(:)'*U(:));
            M1=mean(M1);
            N1=length(E1);
            
            Y2=Y(:,:,:,J);
            Y2=Y2.^2;
            E2=squeeze(sum(sum(Y2,1),2)); %total energy for false class
            N2=length(E2);
%             E2=E2/(d1*d2);
            %T=1-2*T; %Now T has -1 for true class, and 1 for false class
%             dLdY=zeros(size(Y));
            
            ratio_avg=N1*(sum(E2)+sum(E1b))/(sum(E1)*N2);
            index1=0;
            index2=0;
            for i=1:N
                tmp=Y(:,:,1,i);
                if T(i)==0 %1
                    index2=index2+1;
                    %ratio=E2(index2)/(1e-5)/N2;
                    dLdY(:,:,1,i) = Y(:,:,1,i)/E2(index2); %gradient for false class
%                     dLdY(:,:,1,i) = Y(:,:,1,i)/(d1*d2);
                else
                    
                    index1=index1+1;
                    tmp=Y(:,:,1,i);
                    UY=U.*tmp;
%                     figure(1); colormap gray; imagesc(tmp);drawnow
                    BY=(1-Ub).*tmp;
                    %ratio=E1b(index1)/(E1(index1)+1e-5);
                    dLdY(:,:,1,i) = BY/E1b(index1)-UY/(E1(index1) + 1e-5); %gradient for true class
%                     dLdY(:,:,1,i)=tmp-T_copy(:,:,1,i);
%                    dLdY(:,:,1,i) = BY/(d1*d2)-UY/E1(index1); %gradient for true class

                end
            end
            dLdY=single(dLdY);
        end
    end
end