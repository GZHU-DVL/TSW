% test on the natural image signal for comparison 
clear all; close all; clc;
alpha=150; level=5; Nc=16; Nv=2048; No=1000; Nt=3840; %Nt=16128;  %Nt=768;
% Nm=1500;  lamda=1;  % for CW-ISS and HCW-ISS
% Dx=15585;  %Dx=EstimateVariance(file); %file='C:\BOWS2OrigEp3\'; % for TNW
X=double(imread('92.pgm'));  %[l, h]=size(X);
%NW=X;  TNW=X; CW=X; HCW=X; TSW=X;
% generate carrier U and message
seed=20071011;
M=rand(Nc, No)>0.5;
Mtsw=M; %Mnw=M; Mtnw=M; Mcw=M; Mhcw=M; 
rand('state', seed);
B=randn(Nv,Nv);  % [Q, R]=grams(B);
Q=orth(B); U=Q(:, 1:Nc);
% PN=hadamard(Nv); %pn=PN(:, 3:Nc+2); %pn=pn/var(pn(:));
% generate projection carriers to obtain the Gaussian-distributed host signal
b=2*sqrt(3/Nc)*(rand(Nt,Nv)-0.5); a=b/norm(b);
Y=waveletcdf97(X, level);
% [1-3] subbands, Nt=768
% X1=Y(1:16,17:32); % 256
% X2=Y(17:32,1:32); % 512
% X3=[X1(:); X2(:)];  

% [1-4] subbands, Nt=1792
% X1=Y(1:16,17:64); % 768
% X2=Y(17:32,1:64); % 1024
% X3=[X1(:); X2(:)]; 

% [1-6] subbands, Nt=3840
X1=Y(1:16,17:64); % 768
X2=Y(17:64,1:64); % 3072
X3=[X1(:); X2(:)];  

% [1-9] subbands, Nt=16128
% X1=Y(1:16,17:128); %  1792
% X2=Y(17:128,1:128); % 14336
% X3=[X1(:); X2(:)];

% [4-6] subbands, Nt=3072
% X1=Y(1:32,33:64); %  1024
% X2=Y(33:64,1:64); % 2048
% X3=[X1(:); X2(:)];

x=a'*X3;  % for projection 
PSNR=0;
% [Mstar, Zx, Zy]=MinCostPerfMatching(Dx, U, Nm, alpha); % for HCW-ISS
for i=1:No
%     y=NWembed(U, M(:,i), x);
%     y=TNWembed(U, M(:,i), x, Dx);
%     y=CWISSembed(alpha, lamda, x, U, M(:,i));
%     y=HSWembed(U, Nm, x, M(:,i), Mstar, Zx, Zy);
    y=TSWembed(alpha, U, M(:,i), x);
% obtain the watermark signal
    w=a*(y-x); 
% psychovisual masking by Piva-ICIP97 and then multiplicative embedding
    s=X3+abs(X3).*w/(mean(abs(X3)));
    
    % for subbands [1-3]
%     Y(1:16,17:32)=reshape(s(1:256), [16 16]);
%     Y(17:32,1:32)=reshape(s(257:end), [16 32]);

    % for subbands [1-4]
%     Y(1:16,17:64)=reshape(s(1:768), [16 48]);
%     Y(17:32,1:64)=reshape(s(769:end), [16 64]);

    % for subbands [1-6]
    Y(1:16,17:64)=reshape(s(1:768), [16 48]);
    Y(17:64,1:64)=reshape(s(769:end), [48 64]);
    
%   for subbands [1-9]
%     Y(1:16,17:128)=reshape(s(1:1792), [16 112]);
%     Y(17:128,1:128)=reshape(s(1793:end), [112 128]);

%   for subbands [4-6]
%     Y(1:32,33:64)=reshape(s(1:1024), [32 32]);
%     Y(33:64,1:64)=reshape(s(1024:end), [32 64]);

 % reconstructing the watermarked image Z
    Z=waveletcdf97(Y, -level);
    snr=psnr(uint8(X),uint8(Z));
    PSNR=PSNR+snr;
%     imwrite(uint8(Z), '16.bmp');
%     imshow(uint8(Z));

% begin attacks
% im=imread('16ed.bmp');
AZ=attacks(uint8(Z));
% AZ=attacks(im);
Z=double(AZ);

% begin decoding
YY=waveletcdf97(Z, level);
% for [1-3] subbands, Nt=768
% X11=YY(1:16,17:32); % 256
% X22=YY(17:32,1:32); % 512
% X33=[X11(:); X22(:)];  % 

% for [1-4] subbands, Nt=1792
% X11=YY(1:16,17:64); % 768
% X22=YY(17:32,1:64); % 1024
% X33=[X11(:); X22(:)];  % 

% for [1-6] subbands, Nt=3840
X11=YY(1:16,17:64); % 768
X22=YY(17:64,1:64); % 3072
X33=[X11(:); X22(:)];  % 

% for [1-9] subbands, Nt=16128
% X11=YY(1:16,17:128); %
% X22=YY(17:128,1:128); % 
% X33=[X11(:); X22(:)];  %

% for [4-6] subbands, Nt=3072
% X11=YY(1:32,33:64); %
% X22=YY(33:64,1:64); %
% X33=[X11(:); X22(:)];  %

v=a'*X33;  % Nv
%     Mnw(:,i)=logical(1-sign(U'*v));
%     Mtnw(:,i)=logical(1-sign(U'*v));
%     Mcw(:,i)=logical(1-sign(U'*v));
%     Mhcw(:,i)=logical(1-sign(U'*v));
    Mtsw(:,i)=logical(1-sign(U'*v));
end
% BERnw=sum(M(:)~=Mnw(:))/(Nc*No)
% BERtnw=sum(M(:)~=Mtnw(:))/(Nc*No)
% BERcw=sum(M(:)~=Mcw(:))/(Nc*No);
% BERhcw=sum(M(:)~=Mhcw(:))/(Nc*No)
BERtsw=sum(M(:)~=Mtsw(:))/(Nc*No)
PSNR/No

