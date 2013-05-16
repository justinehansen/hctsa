function out = CO_ami_benhist(y,tau,meth,nbins)
% Look at automutual information using histograms -- vary over number of
% bins to really get a good estimate; return max AMI over bin number range,
% or minimum or median, or....
% Uses hist2 by Nedialko Krouchev (from MATLAB Central)
% [[hist2 for the people by Nedialko Krouchev
%   20 Sep 2006 (Updated 21 Sep 2006)]]
% y should be zscored
% some methods require extra parameter nbins
% Ben Fulcher September 2009

if strcmp(tau,'tau'), tau = CO_fzcac(y); end

% 1) Form the temporally-delayed vectors y1 and y2
y1 = y(1:end-tau);
y2 = y(1+tau:end);

% Number of options:
% remove outliers first?, number of bins, range of bins, bin sizes

%% Bins by standard deviation (=1)

% same for both -- assume same distribution (true for stationary processes,
% or small lags)
switch meth
    case 'std1' % std bins up to 1
        b = linspace(-1,1,nbins+1);
        if min(y)<-1; b=[min(y)-0.1 b]; end
        if max(y)>1; b = [b max(y)+0.1]; end
    case 'std2'
        b = linspace(-2,2,nbins+1);
        if min(y)<-2; b=[min(y)-0.1 b]; end
        if max(y)>2; b = [b max(y)+0.1]; end
    case 'even'
        b = linspace(min(y)-0.1,max(y)+0.1,nbins+1); % +0.1 to make sure all points included
    case 'quantiles' % use quantiles with ~equal number in each bin
        b = quantile(y,linspace(0,1,nbins+1));
        b(1) = b(1) - 0.1; b(end) = b(end) + 0.1;
end
nb = length(b)-1; % number of bins (-1 since b defines edges)


% (1) Joint distribution of y1 and y2
pij = hist2(y1,y2,b,b); pij = pij(1:nb,1:nb); pij = pij/sum(sum(pij)); % JOINT
pi = sum(pij,1); % marginal
pj = sum(pij,2); % other marginal
% Old-fashioned method (should give same result):
% pi = histc(y1,b); pi = pi(1:nb); pi = pi/sum(pi); % marginal
% pj = histc(y2,b); pj= pj(1:nb); pj = pj/sum(pj); % other marginal

% keyboard;
pii = ones(nb,1)*pi;
pjj = pj*ones(1,nb);

r = find(pij>0); % makes log(0)=0
ami = pij(r).*log(pij(r)./pii(r)./pjj(r));
out = sum(ami);

% probably a nicer matrix way of doing this:
% ami=zeros(nb);
% for i=1:nb
%     for j=1:nb
%         ami(i,j) = pij(i,j)*
%     end
% end
% ami =  ;



end