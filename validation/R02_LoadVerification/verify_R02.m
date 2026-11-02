% Run from this file's folder. Coordinates m; pressure Pa; line traction N/m.
% Uses exported Mechanical Quad8 order, confirmed by SHELL281 input deck.
folder = fileparts(mfilename('fullpath'));
N = readtable(fullfile(folder,'nodes_native.csv'));
E = readtable(fullfile(folder,'elements.csv'));
B = readtable(fullfile(folder,'boundary_edges.csv'));
S = readtable(fullfile(folder,'boundary_summary.csv'));
xyz = zeros(max(N.node_id),3); xyz(N.node_id,:) = [N.x N.y N.z];
g = [-sqrt(3/5),0,sqrt(3/5)]; w = [5/9,8/9,5/9];
p = 55000; Fp=zeros(1,3); Mp=Fp; area=0;
for k=1:height(E)
    ids=E{k,4:11}; X=xyz(ids,:);
    for i=1:3
        for j=1:3
            [n,dx,dy]=quad8(g(i),g(j));
            r=n*X; a=cross(dx*X,dy*X);
            assert(dot(a,[0,r(2),r(3)])>0,'Inward/invalid element');
            dA=w(i)*w(j); Fp=Fp+p*a*dA;
            Mp=Mp+p*cross(r,a)*dA; area=area+norm(a)*dA;
        end
    end
end
Ft=zeros(1,3); Mt=Ft;
for k=1:height(B)
    X=xyz([B.end1_node(k),B.end2_node(k),B.midside_node(k)],:);
    row=S(S.geometry_edge_id==B.geometry_edge_id(k),:);
    t=[row.benchmark_tx_N_per_m,row.benchmark_ty_N_per_m,row.benchmark_tz_N_per_m];
    for i=1:3
        q=g(i); n=[q*(q-1)/2,q*(q+1)/2,1-q*q];
        dn=[q-.5,q+.5,-2*q]; r=n*X; ds=norm(dn*X)*w(i);
        Ft=Ft+t*ds; Mt=Mt+cross(r,t)*ds;
    end
end
fprintf('Area = %.16g m^2\n',area);
disp('Pressure force N / moment Nm about global origin:'); disp(Fp); disp(Mp);
disp('Boundary force N / moment Nm:'); disp(Ft); disp(Mt);
disp('Combined residual force N / moment Nm:'); disp(Fp+Ft); disp(Mp+Mt);
% This is external-load integration, not a structural solve or restraint test.

function [n,dx,dy]=quad8(x,y)
s=[-1,1,1,-1]; t=[-1,-1,1,1];
n=zeros(1,8); dx=n; dy=n;
for a=1:4
 n(a)=.25*(1+s(a)*x)*(1+t(a)*y)*(s(a)*x+t(a)*y-1);
 dx(a)=.25*s(a)*(1+t(a)*y)*(2*s(a)*x+t(a)*y);
 dy(a)=.25*t(a)*(1+s(a)*x)*(s(a)*x+2*t(a)*y);
end
n(5:8)=[.5*(1-x*x)*(1-y),.5*(1+x)*(1-y*y),.5*(1-x*x)*(1+y),.5*(1-x)*(1-y*y)];
dx(5:8)=[-x*(1-y),.5*(1-y*y),-x*(1+y),-.5*(1-y*y)];
dy(5:8)=[-.5*(1-x*x),-(1+x)*y,.5*(1-x*x),-(1-x)*y];
end
