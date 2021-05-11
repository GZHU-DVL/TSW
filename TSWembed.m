function s=TSWembed(alpha, U, m, x)
[Nv,Nc]=size(U);
if Nc==1
    error('Nc must be larger than 1');
end
Dx=var(x(:));
% TSW embedding function: s=x+U*(S-U'*x);
S=zeros(Nc,1); % S=U'*s; S is called the watermarked correlations
r0=alpha*sqrt(Nc);
t0=1/2+(1/2)*erf(U(:,Nc)'*x*(-1).^m(Nc)/(Dx*sqrt(2)));
g=@(v, N)(1-v.^2).^(N/2-3/2).*gamma(N/2)/(sqrt(pi)*gamma(N/2-1/2));
Fi=@(t, N)2*quadgk(@(v)g(v, N), 0, t);
% note that Fi is a monotone increasing function
Fii=fsolve(@(y)(Fi(y,Nc)-t0), 0); % fsolve obtains the roots of the function: f(x)=0
S(Nc)=(-1).^m(Nc)*r0*real(Fii); % note that S(Nc-i)=U(Nc-i)'s; i=0,1,2,...Nc-1
if Nc==2
    r1=sqrt(r0.^2-S(Nc).^2);
else % Nc>2
    for i=1:Nc-2
    rpf=0;
    for j=0:i-1
    rpf=rpf+S(Nc-j).^2;
    end
    r=sqrt(r0.^2-rpf);
    t=1/2+(1/2)*erf(U(:,Nc-i)'*x*(-1).^m(Nc-i)/(Dx*sqrt(2)));
    Fii=fsolve(@(y)(Fi(y,Nc-i)-t), 0);
    S(Nc-i)=(-1).^m(Nc-i)*r*real(Fii);
    end
    rpf=rpf+S(2).^2;
    r1=sqrt(r0.^2-rpf);
end
%----------- single computing S(1) begins ---------------------
% when Nc>2, above we obtain S(3),  let r1= r_{Nc-1}
% when i=Nc-1, i.e., the last recursive call, objective S(1) is only a two-point 
% distribution with probability 1/2, T theory is not applicable, we directly compute
% the last item S(1): U(:, 1)'x --->(-1).^m(1)*r_{Nc-1}.
S(1)=(-1).^m(1)*r1;
%----------- single computing S(1) ends -------------------------
s=x+U*(S-U'*x);
