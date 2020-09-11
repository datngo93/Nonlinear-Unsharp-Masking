%%=========================================================================
% Copyright © 2019, SoC Design Lab., Dong-A University. All Right Reserved.
%==========================================================================
% - Date       : 2019/05/21
% - Author     : Dat Ngo
% - Affiliation: SoC Design Lab. - Dong-A University
% - Design     : Generalized unsharp masking
%                Input image must be an integer RGB [0,255]
%==========================================================================

function [oimgf] = NUM(img,sv,sigma,iterNum,ceEn,gammaMin,gammaMax,n)

%% Default parameters
switch nargin
    case 1
        sv = 5;
        sigma = 1e-4;
        iterNum = 20;
        ceEn = false;
        gammaMin = 1;
        gammaMax = 5;
        n = 0.5;
    case 2
        sigma = 1e-4;
        iterNum = 20;
        ceEn = false;
        gammaMin = 1;
        gammaMax = 5;
        n = 0.5;
    case 3
        iterNum = 20;
        ceEn = false;
        gammaMin = 1;
        gammaMax = 5;
        n = 0.5;
    case 4
        ceEn = false;
        gammaMin = 1;
        gammaMax = 5;
        n = 0.5;
    case 5
        gammaMin = 1;
        gammaMax = 5;
        n = 0.5;
    case 6
        gammaMax = 5;
        n = 0.5;
    case 7
        n = 0.5;
    otherwise
        % all parameters are provided
end

%=========== Avoid under-shooting ===========
img(img==0) = 1;
img(img==255) = 254;
%============================================
imgf = double(img)/255;

%% Unsharp masking
hsv = rgb2hsv(imgf);
x = hsv(:,:,3);

% root signal
yk = x;
H = [];
while iterNum>0
    iterNum = iterNum-1;
    yk1 = hmfm_v33(yk,sv);
    Hnew = mean2(abs(yk1.^2-yk.^2));
    H = cat(1,H,Hnew);
    if Hnew<sigma
        disp('Terminate while loop.');
        disp(iterNum);
        break;
    else
        yk = yk1;
    end
end
y = yk1; % root signal

% detail signal
d = funcRev(func(x)+func(-y));

% contrast enhancement
if ceEn
    y = adapthisteq(y,'ClipLimit',0.02);
else
    % do nothing
end

% adaptive unsharp masking
beta = (gammaMax-gammaMin)/(1-exp(-1));
alpha = gammaMax-beta;
adaptGamma = alpha+beta*exp(-abs(d).^n);
adaptDw = funcRev(adaptGamma.*func(d));
z2 = funcRev(func(y)+func(adaptDw));
z2 = (1+z2)/2;

% result
oimgf = hsv2rgb(cat(3,hsv(:,:,1),hsv(:,:,2),z2));

end

%% Sub-functions
function y = func(x)
    y = log((1+x)./(1-x+eps));
end

function x = funcRev(y)
    x = (exp(y)-1)./(exp(y)+1);
end
