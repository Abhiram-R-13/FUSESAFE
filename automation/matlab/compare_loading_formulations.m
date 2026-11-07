% FUSESAFE Loading Formulation Comparison
format long g;

%% GEOMETRY
Ri = 1999;              % Inner pressure radius (mm)
Rm = 2000;              % Midsurface radius (mm)
L = 1600;               % Axial length (mm)
S = 1600;               % Midsurface arc length (mm)
p = 0.055;              % Pressure (N/mm^2)

alpha = S/(2*Rm);
thetaA = -alpha;
thetaB = alpha;

O = [0;0;0];

%% TWO FORMULATIONS
Ntheta = [p*Rm, p*Ri];
Nx = [p*Rm/2, p*Ri^2/(2*Rm)];

names = {'Conventional','Geometrically consistent'};

%% INTEGRATION SETTINGS
nX = 400;
nT = 400;

dx = L/nX;
dt = (thetaB-thetaA)/nT;

xv = ((1:nX)-0.5)*dx;
tv = thetaA + ((1:nT)-0.5)*dt;

for k = 1:2

    %% INITIALISE
    Fp = zeros(3,1); Mp = zeros(3,1);
    FhA = zeros(3,1); MhA = zeros(3,1);
    FhB = zeros(3,1); MhB = zeros(3,1);
    Fx0 = zeros(3,1); Mx0 = zeros(3,1);
    FxL = zeros(3,1); MxL = zeros(3,1);

    %% PRESSURE ON INNER SURFACE
    for x = xv
        for t = tv

            r = [x; Ri*cos(t); Ri*sin(t)];
            n = [0; cos(t); sin(t)];

            dA = Ri*dx*dt;
            dF = p*n*dA;

            Fp = Fp+dF;
            Mp = Mp+cross(r-O,dF);

        end
    end

    %% LOWER AND UPPER HOOP EDGES
    for x = xv

        % Lower edge
        t = thetaA;
        r = [x; Rm*cos(t); Rm*sin(t)];
        et = [0; -sin(t); cos(t)];

        dF = -Ntheta(k)*et*dx;

        FhA = FhA+dF;
        MhA = MhA+cross(r-O,dF);

        % Upper edge
        t = thetaB;
        r = [x; Rm*cos(t); Rm*sin(t)];
        et = [0; -sin(t); cos(t)];

        dF = Ntheta(k)*et*dx;

        FhB = FhB+dF;
        MhB = MhB+cross(r-O,dF);

    end

    %% AXIAL END EDGES
    for t = tv

        ds = Rm*dt;

        % X = 0
        r = [0; Rm*cos(t); Rm*sin(t)];
        dF = [-Nx(k);0;0]*ds;

        Fx0 = Fx0+dF;
        Mx0 = Mx0+cross(r-O,dF);

        % X = L
        r = [L; Rm*cos(t); Rm*sin(t)];
        dF = [Nx(k);0;0]*ds;

        FxL = FxL+dF;
        MxL = MxL+cross(r-O,dF);

    end

    %% SUM CONTRIBUTIONS
    Fh = FhA+FhB;
    Mh = MhA+MhB;

    Fa = Fx0+FxL;
    Ma = Mx0+MxL;

    Ftotal = Fp+Fh+Fa;
    Mtotal = Mp+Mh+Ma;

    %% DISPLAY
    fprintf('\n====================================\n');
    fprintf('%s FORMULATION\n',names{k});
    fprintf('====================================\n');

    fprintf('Hoop resultant = %.8f N/mm\n',Ntheta(k));
    fprintf('Axial resultant = %.8f N/mm\n',Nx(k));

    disp('Pressure force:'); disp(Fp);
    disp('Pressure moment:'); disp(Mp);

    disp('Lower hoop force:'); disp(FhA);
    disp('Lower hoop moment:'); disp(MhA);

    disp('Upper hoop force:'); disp(FhB);
    disp('Upper hoop moment:'); disp(MhB);

    disp('Axial X=0 force:'); disp(Fx0);
    disp('Axial X=0 moment:'); disp(Mx0);

    disp('Axial X=L force:'); disp(FxL);
    disp('Axial X=L moment:'); disp(MxL);

    disp('Combined force:'); disp(Ftotal);
    disp('Combined moment:'); disp(Mtotal);

    %% RESIDUALS
    forceScale = norm(Fp)+norm(Fh)+norm(Fa);
    momentScale = norm(Mp)+norm(Mh)+norm(Ma);

    fprintf('Force residual = %.12e\n', ...
        norm(Ftotal)/forceScale);

    fprintf('Moment residual = %.12e\n', ...
        norm(Mtotal)/momentScale);

end