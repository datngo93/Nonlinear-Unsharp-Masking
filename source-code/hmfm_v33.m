%%=========================================================================
% Copyright © 2018, SoC Design Lab., Dong-A University. All Right Reserved.
%==========================================================================
% • Date       : 2018/04/05
% • Author     : Dat Ngo
% • Affiliation: SoC Design Lab. - Dong-A University
% • Design     : Hybrid median filter implementation (ver. 3)
%==========================================================================
function hm = hmfm_v33(input,sv)

% Default parameters
switch nargin
    case 2
        % All arguments were provided, do nothing
    case 1
        sv = 3; % default 3x3
    otherwise
        warning('Please check input arguments!');
        return;
end

% Boundary extension
input_pad = sympad(input,sv);

% Square mask
square = true(sv,sv);

% Cross mask
cross = false(sv,sv);
cross((sv+1)/2,:) = true;
cross(:,(sv+1)/2) = true;

% Diagonal mask
diag = false(sv,sv);
diag((1:sv)+sv*(0:sv-1)) = true;
diag((1:sv)+sv*((sv-1):-1:0)) = true;

% Filtering
hmtemp = hybridMedfilt(input_pad);

% Return orginal size
hm = hmtemp((sv+1)/2:end-(sv-1)/2,(sv+1)/2:end-(sv-1)/2);

    % Hybrid median filter
    function hm = hybridMedfilt(inImg)
        
        % Filtering
        hm1 = ordfilt2(inImg,(sv*sv+1)/2,square);
        hm2 = ordfilt2(inImg,sv,cross);
        hm3 = ordfilt2(inImg,sv,diag);
        hm4 = cat(3,hm1,hm2,hm3);
        hm4 = sort(hm4,3);
        hm = hm4(:,:,2);

    end
end

% Symmetric padding (local function)
function inpad = sympad(in,sv)

[y,x] = size(in);
ypad = y+(sv-1);
xpad = x+(sv-1);
inpad = zeros(ypad,xpad);
inpad((sv+1)/2:end-(sv-1)/2,(sv+1)/2:end-(sv-1)/2) = in;

upmask = false(ypad,xpad);
upmask((sv+1)/2+1:sv,:) = true;
uppad = reshape(inpad(upmask),[(sv-1)/2,xpad]);
uppad = uppad(end:-1:1,:);

lowmask = false(ypad,xpad);
lowmask(end-(sv-1):end-(sv-1)/2-1,:) = true;
lowpad = reshape(inpad(lowmask),[(sv-1)/2,xpad]);
lowpad = lowpad(end:-1:1,:);

inpad(1:(sv+1)/2-1,:) = uppad;
inpad(end-(sv-1)/2+1:end,:) = lowpad;

leftmask = false(ypad,xpad);
leftmask(:,(sv+1)/2+1:sv) = true;
leftpad = reshape(inpad(leftmask),[ypad,(sv-1)/2]);
leftpad = leftpad(:,end:-1:1);

rightmask = false(ypad,xpad);
rightmask(:,end-(sv-1):end-(sv-1)/2-1) = true;
rightpad = reshape(inpad(rightmask),[ypad,(sv-1)/2]);
rightpad = rightpad(:,end:-1:1);

inpad(:,1:(sv+1)/2-1) = leftpad;
inpad(:,end-(sv-1)/2+1:end) = rightpad;

end
