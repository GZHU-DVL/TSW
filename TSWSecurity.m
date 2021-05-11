% Evaluate security (or distribution of watermarked correlations) of TSW 
% under various embedding strengths only visualization available with Nc=2 and 3
clear all; close all; clc
format long
Nv=512; % length of host vector
alpha=1; % determine the radius of the circle, in general, larger than 0 is ok
Nc=3;   % only visualization available with Nc=2 and 3
R=alpha*sqrt(Nc);   % real radius of the sphere of the watermarked correlations
No=1000; % number of observations
r=zeros(1, No); % for testing the spherical distribution of TSW embedding
Dx=1.0;   % the variance of host signals
X=sqrt(Dx)*randn(Nv, No);  % the host signals
S=X;  % the watermarked signals
M=rand(Nc, No)>0.5; % the messages
% generate carrier U
seed=20071011;
rand('state', seed);
B=randn(Nv,Nv);
Q=orth(B);
U=Q(:, 1:Nc);
for i=1: No
    S(:,i)=TSWembed(alpha, U, M(:,i), X(:,i));
    % for testing the character of spherical distribution of TSW embedding
    r(i)=norm(U'*S(:,i)); 
end
ZX=U'*X;
ZS=U'*S;
% plot 2-dimensional 
% plot(ZX(1, :), ZX(2, :),'b.'); hold on
% plot(ZS(1, :), ZS(2, :),'r.'); 
% legend('(x^{T}u1, x^{T}u2)','(s^{T}u1, s^{T}u2)', 'Interpreter','LaTex', 'FontSize',18,'FontName','Times New Roman');
% legend('Host correlations','Watermarked correlations', 'FontSize',18,'FontName','Times New Roman');
% xlabel('u1','FontSize',18,'FontName','Times New Roman');
% ylabel('u2','FontSize',18,'FontName','Times New Roman');
% set(gca,'FontSize',18,'FontName','Times New Roman');
% axis([-4, 4, -4, 4]);  

% plot 3-dimensional
plot3(ZX(1, :), ZX(2, :), ZX(3, :), 'b.'); hold on
plot3(ZS(1, :), ZS(2, :), ZS(3, :), 'r.');
% legend('Host correlations','Watermarked correlations', 'FontSize',18,'FontName','Times New Roman');
xlabel('u1','FontSize',18,'FontName','Times New Roman');
ylabel('u2','FontSize',18,'FontName','Times New Roman');
zlabel('u3','FontSize',18,'FontName','Times New Roman');
axis([-4, 4, -4, 4, -4, 4]);  
set(gca,'FontSize',18,'FontName','Times New Roman');
hold off

