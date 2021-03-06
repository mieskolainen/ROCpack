% Efficiency, Purity, ROC curves, frequentist/Bayesian concepts
% demonstrated with two Gaussian densities, for learning purposes.
% ------------------------------------------------------------------------
%
% mode = 1 : Uses single sided cut on the x-axis of likelihoods.
% mode = 2 : Uses cut on the likelihood Ratio, which is the most powerful
%            (lowest beta / type II error) frequentist test by
%            Neyman-Pearson lemma
%            at given fixed significance level alpha (type I error).
% mode = 3 : Uses Bayesian posteriori probabilities (priors fixed)
%
% mode = 4 ... Add more decision rules, Bayesian integrals etc.,
%              mixture density estimation (e.g. Max Likelihood fitting)
%
%            Multivariate (neural nets etc.) methods are often used
%            to approximate likelihoods in high dimensional problems. Here,
%            we have the full solution known (due to Gaussian likelihoods).
%
% Frequentist magic-4 (or magic-2, actually), all between [0,1]:
%
% Think about the null hypothesis H_0 = "background only, no signal"
% Rejecting the null hypothesis indicates signal in data.
%
% 1. Type I  error rate (alpha) == "Significance level"
%    False positive rate
%                 - e.g. The probability of incorrectly rejecting the
%                 null hypothesis.
%                 - "Background rejection inefficiency"
% 
% 2. Type II error rate (beta)
%    False negative rate
%                 - e.g. The probability of
%                 missing to reject the null hypothesis when
%                 the null hypothesis is incorrect.
%                 - "Signal selection inefficiency"
% 
% 3. True Positive rate (1-beta) == "Statistical power"
%                 When the null hypothesis is wrong, reject it.
%                 - "Signal selection efficiency" 
% 
% 4. True Negative rate (1-alpha)
%                 When the null hypothesis is right, accept it.
%                 - "Background selection efficiency"
% 
% 
% Purity = \int l(signal)f(signal) / 
%          (\int l(signal)f(signal) + \int l(background) f(background)),
% is inherently a Bayesian quantity with fractions f.
%
%
% Bayes optimal criteria is, e.g., maximum a Bayes odds
% decision.
%
% mikael.mieskolainen@cern.ch, 27/07/2018
clear; close all;

%mode = 1; % Single point cut on the x-axis
%mode = 2; % Likelihood ratio cut
%mode = 3; % Bayesian posteriori probability cut

% Gaussian pdf
gl = @(x,mu,sigma) 1/sqrt(2*pi*sigma^2) * exp(-(x-mu).^2/(2*sigma^2));


for mode = 1:3

%% SETUP

% x-axis range
xval = linspace(-8,8, 1e3);

% Class likelihood parameters
mu1 = -0.4;
mu2 = 1.5;
sigma1 = 1;
sigma2 = 1.25;

% Class fractions (affecting purity)
f1 = 0.2;
f2 = 1 - f1;

% Discretize and normalize the sum to one (in order to be able to integrate
% simply)
l1 = gl(xval,mu1,sigma1); l1 = l1 / sum(l1);
l2 = gl(xval,mu2,sigma2); l2 = l2 / sum(l2);

% Delta (for plotting proper likelihood values)
delta = xval(2) - xval(1);

f = figure;
rcolor = [0.8 0.05 0.05];
bcolor = [0.05 0.05 0.8];

plot(xval, l1 / delta, 'color', rcolor); hold on;
plot(xval, l2 / delta, 'color', bcolor);
plot(xval, f1 * l1 / delta, ':', 'color', rcolor); hold on;
plot(xval, f2 * l2 / delta, ':', 'color', bcolor);

xlabel('$x$','interpreter','latex');
%set(gca,'yscale','log');

% Fixed cut (as an example)
cfixed = 0.35;

plot(ones(2,1)*cfixed, linspace(0,1,2)*0.5, 'k-');
%cfixed = -3.8;
%plot(ones(2,1)*cfixed, linspace(0,1,2)*0.5, 'k-');

text(-0.9, 0.3,  '$\epsilon_1^<$','interpreter','latex','fontsize',12,'color',rcolor);
text(-0.7, 0.03, '$\epsilon_2^<$','interpreter','latex','fontsize',12,'color',bcolor);
text(0.6, 0.03,  '$\epsilon_1^>$','interpreter','latex','fontsize',12,'color',rcolor);
text(1.5, 0.15,  '$\epsilon_2^>$','interpreter','latex','fontsize',12,'color',bcolor);

text(-6, 0.44,  '$\pi_i^< \equiv \epsilon_i^< f_i / \sum_j \epsilon_j^< f_j$','interpreter','latex','fontsize',12);
text(-6, 0.4,   '$\epsilon_i^< \equiv \int_{-\infty}^{c_x} \ell_i(x)\, dx $','interpreter','latex','fontsize',12);
text(-6, 0.36,  '$\epsilon_i^> \equiv 1 - \epsilon_i^< $','interpreter','latex','fontsize',12);

% Frequentist likelihood ratio
if (mode == 1 || mode == 2)
    FBLR = l1./l2;
end
% Bayes posterior probability
if (mode == 3)
    FBLR = (l1*f1)./(l1*f1 + l2*f2);
end

if     (mode == 1)
    cval = xval(1):0.01:xval(end);
elseif (mode == 2)
    cval = linspace(1e-4, max(FBLR(:)), 1e5);
elseif (mode == 3)
    cval = linspace(1e-3, 0.99, 1e5);
end
axis square;
axis([-6.5 6.5 0 inf]);
set(gca,'XTick', round(-6:1.0:6, 1));
%ylabel('$\ell(x)$','interpreter','latex');
title(sprintf('$f_1 = %0.2f, \\; f_2 = 1 - f_1 = %0.2f$', f1, f2), 'interpreter','latex');

l = legend('$\ell_1(x) $','$\ell_2(x) $', '$\ell_1(x) \times f_1$','$\ell_2(x) \times f_2$', ...
                '$c_x$ (cut example)'); set(l,'interpreter','latex');

filename = sprintf('a_model_definition'); 
print(f, sprintf('./figs/%s.pdf', filename), '-dpdf');
cmd = sprintf('pdfcrop --margins 10 ./figs/%s.pdf ./figs/%s.pdf', filename, filename); system(cmd);


%% Log scale distributions

%{
f = figure;
plot(xval, l1 / delta, 'color', rcolor); hold on;
plot(xval, l2 / delta, 'color', bcolor);
xlabel('$x$','interpreter','latex');
ylabel('$\ell(x)$','interpreter','latex');
set(gca,'yscale','log');
axis square;
axis([-6.5 6.5 1e-11 2]);
title('Class likelihoods', 'interpreter', 'latex');

l = legend('Class 1','Class 2','$c_x$ (cut on $x$)'); set(l,'interpreter','latex');

filename = sprintf('likelihoods_logy');
print(f, sprintf('./figs/%s.pdf', filename), '-dpdf');
cmd = sprintf('pdfcrop --margins 10 ./figs/%s.pdf ./figs/%s.pdf', filename, filename); system(cmd);
%}

%% Implement the 1D running CUT

% Run the cut and integrate
for i = 1:length(cval)
    
    % Cut on x
    if (mode == 1)
        ind_in  = xval < cval(i);    % Left side
        ind_out = xval >= cval(i);   % Right side
        
    % Cut on likelihood ratio or Bayes odds ratio
    elseif (mode == 2 || mode == 3)
        ind_in  = FBLR > cval(i);    % Upper
        ind_out = FBLR <= cval(i);   % Lower
    end
    
    % Integrate from in
    in_sum1 = sum(l1(ind_in));
    in_sum2 = sum(l2(ind_in));
    
    % Integrate from out
    out_sum1 = sum(l1(ind_out));
    out_sum2 = sum(l2(ind_out));
    
    
    % Efficiencies (by construction, NOT affected by the other process)
    eff1_in(i)  = in_sum1;
    eff2_in(i)  = in_sum2;    
    eff1_out(i) = out_sum1;
    eff2_out(i) = out_sum2;
    
    % Purities     (by construction, ARE affected by the other process)
    pur1_in(i)  = f1*in_sum1  / (f1*in_sum1  + f2*in_sum2);
    pur2_in(i)  = f2*in_sum2  / (f1*in_sum1  + f2*in_sum2);
    pur1_out(i) = f1*out_sum1 / (f1*out_sum1 + f2*out_sum2);
    pur2_out(i) = f1*out_sum2 / (f1*out_sum1 + f2*out_sum2);
    
    % Bayes error
    pxC1 = l1*f1; % p(x,C1) = p(x|C1) p(C1)
    pxC2 = l2*f2; % p(x,C2) = p(x|C2) p(C2)
    
    intP1 = sum( pxC1(ind_out) );  % out integral (miss of signal)
    intP2 = sum( pxC2(ind_in) ) ;  % in  integral (leakage of background)
    
    bayeserror(i) = intP1 + intP2;
end


%% Choose symbols

if (mode == 1)
    in  = '<';
    out = '>';
end
if (mode == 2 || mode == 3)
    in  = '\wedge';
    out = '\vee';    
end


%% Bayes error

f = figure;

plot(cval, bayeserror, 'k-'); hold on;

[minval,mind] = min(bayeserror);
plot(ones(2,1)*cval(mind), [0 1], 'k:');
plot([cval(1) cval(end)], ones(2,1)*minval, 'k:');

ylabel('Bayes error (overall misclassification rate)','interpreter','latex');
xlabel('$c_x$ (cut on $x$)','interpreter','latex');
axis([min(cval) max(cval) 0 1]);

if (mode == 2)
    xlabel('$c_{\ell R}$ (cut on likelihood ratio)','interpreter','latex');
    set(gca,'xscale','log');
    %set(gca,'yscale','log');
    axis([0 max(cval) 0 1.0]);
end
if (mode == 3)
    xlabel('$c_{B R}$ (cut on Bayes posterior)','interpreter','latex');
    %set(gca,'xscale','log');
    axis([0 1 0 1.0]);
    set(gca, 'Xtick', 0:0.1:1.0);
end
axis square;
title('$\int_{\Omega_2} P(x|C_1)p(C_1)dx + \int_{\Omega_1} P(x|C_2)p(C_2)dx$', ...
    'interpreter','latex');

filename = sprintf('bayeserror_mode_%d', mode);
print(f, sprintf('./figs/%s.pdf', filename), '-dpdf');
cmd = sprintf('pdfcrop --margins 10 ./figs/%s.pdf ./figs/%s.pdf', filename, filename); system(cmd);



%% Likelihood (or Bayes odds) ratios visualized

if (mode == 2 || mode == 3)
    
f = figure;

% Example cut on likelihood ratio
if (mode == 2)
cutval = 4;
end
if (mode == 3)
cutval = 0.7;
end
lRcut  = cutval * ones(size(xval));

h1 = plot(xval, FBLR); hold on;
if (mode == 2)
h2 = plot(xval, 1./FBLR); hold on;
end
if (mode == 3)
h2 = plot(xval, 1-FBLR); hold on;
end
%h3 = plot(xval, ones(size(xval)), 'k:');
h4 = plot(xval, lRcut, 'k-');

if (mode == 2)
plotmin = 1e-6;
plotmax = 1e6;    
end
if (mode == 3)
plotmin = 1e-2;
plotmax = 1e1;
end

% Find the selection window and visualize
stop = false;
for i = 1:length(FBLR)
   if (FBLR(i) > cutval && stop == false)
       plot(xval(i)*[1 1], [plotmin plotmax], 'k:'); hold on;
       stop = true;
   end
  if (FBLR(i) < cutval && stop == true)
       plot(xval(i)*[1 1], [plotmin plotmax], 'k:'); hold on;
       stop = false;
   end
end

set(gca,'yscale','log'); axis square;
xlabel('$x$','interpreter','latex');

if (mode == 2)
l = legend([h1 h2 h4], '$\ell_1(x) / \ell_2(x)$', '$\ell_2(x) / \ell_1(x)$', ...
    '$c_{\ell R}$ (example cut on likelihood ratio)');
end
if (mode == 3)
l = legend([h1 h2 h4], '$P_1 = \ell_1(x) f_1 / \sum_j \ell_j(x) f_j$', '$P_2 = 1 - P_1$', ...
    '$c_{BR}$ (example cut on Bayes posterior)');
end

set(l,'interpreter','latex','location','northwest');
axis([min(xval) max(xval) plotmin plotmax]);

if (mode == 1 || mode == 2)
    filename = sprintf('likelihoodratio');
    title('Likelihood ratios','interpreter','latex');
end
if (mode == 3)
    filename = sprintf('posterioriratio');
    title('Bayes posterior probabilities','interpreter','latex');
end

print(f, sprintf('./figs/%s.pdf', filename), '-dpdf');
cmd = sprintf('pdfcrop --margins 10 ./figs/%s.pdf ./figs/%s.pdf', filename, filename); system(cmd);

end


%% Efficiency ratios

f = figure;
plot(cval, eff1_in  ./ eff2_in); hold on;
plot(cval, eff1_out ./ eff2_out);
plot(cval, eff1_in  ./ eff2_out);
plot(cval, eff1_out ./ eff2_in);

plotmin = 1e-6;
plotmax = 1e6;

set(gca,'yscale','log');
l = legend(sprintf('$\\epsilon_1^%s / \\epsilon_2^%s$', in, in), ...
           sprintf('$\\epsilon_1^%s / \\epsilon_2^%s$', out, out), ...
           sprintf('$\\epsilon_1^%s / \\epsilon_2^%s$', in, out), ...
           sprintf('$\\epsilon_1^%s / \\epsilon_2^%s$', out, in));
set(l,'AutoUpdate','off'); % Do not add more entries

set(l, 'interpreter','latex','location','southeast');
axis([cval(1) cval(end) plotmin plotmax]);
axis tight; axis square;

xlabel('$c_x$ (cut on $x$)','interpreter','latex');
if (mode == 2)
    plot(ones(2,1), [plotmin plotmax], 'k:'); % Vertical line
    xlabel('$c_{\ell R}$ (cut on likelihood ratio)','interpreter','latex');
    set(gca,'xscale','log');
end
if (mode == 3)
    plot(ones(2,1), [plotmin plotmax], 'k:'); % Vertical line
    xlabel('$c_{B R}$ (cut on Bayes posterior)','interpreter','latex');
    set(gca,'xscale','log');
end
title('Efficiency ratios','interpreter','latex');

filename = sprintf('efficiencyratio_mode_%d', mode);
print(f, sprintf('./figs/%s.pdf', filename), '-dpdf');
cmd = sprintf('pdfcrop --margins 10 ./figs/%s.pdf ./figs/%s.pdf', filename, filename); system(cmd);


%% Efficiencies

f = figure;
plot(cval, eff1_in); hold on;
plot(cval, eff2_in);
plot(cval, eff1_out); hold on;
plot(cval, eff2_out);

%set(gca,'yscale','log');
l = legend(sprintf('$\\epsilon_1^%s$', in), ...
           sprintf('$\\epsilon_2^%s$', in), ...
           sprintf('$\\epsilon_1^%s$', out), ...
           sprintf('$\\epsilon_2^%s$', out), ...
           'location','northwest'); set(l,'interpreter','latex');
set(l,'AutoUpdate','off'); % Do not add more entries

axis([min(xval) max(xval) 0 1]); axis tight; axis square;

xlabel('$c_x$ (cut on $x$)','interpreter','latex');
if (mode == 2)
    plot(ones(2,1), [0 1], 'k:'); % Vertical line
    xlabel('$c_{\ell R}$ (cut on likelihood ratio)','interpreter','latex');
    set(gca,'xscale','log');
end
if (mode == 3)
    plot(ones(2,1), [0 1], 'k:'); % Vertical line
    xlabel('$c_{B R}$ (cut on Bayes posterior)','interpreter','latex');
    set(gca,'xscale','log');
end
title('Efficiencies','interpreter','latex');

filename = sprintf('efficiency_mode_%d', mode);
print(f, sprintf('./figs/%s.pdf', filename), '-dpdf');
cmd = sprintf('pdfcrop --margins 10 ./figs/%s.pdf ./figs/%s.pdf', filename, filename); system(cmd);


%% Purities

f = figure;
plot(cval, pur1_in); hold on;
plot(cval, pur2_in);
plot(cval, pur1_out);
plot(cval, pur2_out);

l = legend(sprintf('$\\pi_1^%s$', in), ...
           sprintf('$\\pi_2^%s$', in), ...
           sprintf('$\\pi_1^%s$', out), ...
           sprintf('$\\pi_2^%s$', out), ...
           'location','northwest'); set(l,'interpreter','latex');
set(l,'AutoUpdate','off'); % Do not add more entries

xlabel('$c_x$ (cut on $x$)','interpreter','latex');
axis tight; axis square;
axis([min(cval) max(cval) 0 1]);
title(sprintf('Purities'),'interpreter','latex');

if (mode == 2)
    plot(ones(2,1), [0 1], 'k:'); % Vertical line
    xlabel('$c_{\ell R}$ (cut on likelihood ratio)','interpreter','latex');
    set(gca,'xscale','log');
end
if (mode == 3)
    plot(ones(2,1), [0 1], 'k:'); % Vertical line
    xlabel('$c_{B R}$ (cut on Bayes posterior)','interpreter','latex');
    set(gca,'xscale','log');
end

filename = sprintf('purity_mode_%d', mode);
print(f, sprintf('./figs/%s.pdf', filename), '-dpdf');
cmd = sprintf('pdfcrop --margins 10 ./figs/%s.pdf ./figs/%s.pdf', filename, filename); system(cmd);


%% ROC ("Receiver Operating Characteristic")
% True positive versus false positive
close all;

f = figure;

hs = cell(2,1);
auc = [0,0];

for variation = 1:2

if (variation == 1)
    input1 = eff1_in;
    input2 = eff2_in;
end
if (variation == 2)
    input1 = eff1_in;
    input2 = pur1_in;
end

input1(isnan(input1)) = 0;
input2(isnan(input2)) = 0;

% Integrate AUC (area under curve)
auc(variation) = trapz(input1, input2);

if (auc(variation) > 1)
    auc(variation) = 2-auc(variation);
end
if (auc(variation) < 0)
    auc(variation) = abs(auc(variation));
end

% Create red ticks (hand tuned visual style)
if (mode == 1)
    ticks = round(length(cval)/2.5):50:length(cval)-round(length(cval)/3);
elseif (mode == 2)
    ticks = round(logspace(2, round(log10(length(cval))), 9)); 
    ticks = fliplr(ticks); % flip order to normal small ... large
elseif (mode == 3)
    ticks = round((0.01:0.15:1.0)*length(cval));
    ticks = fliplr(ticks); % flip order to normal small ... large
end

%if (variation == 1)
%   imagesc(input1, 0.5*ones(1,length(input1)), cval); 
%   hold on; set(gca,'YDir','normal'); colorbar; colormap('bone');
%end


% Plot continuous curve
if (variation == 1)
linevar = '-'; 
end
if (variation == 2)
linevar = ':';
end
hs{variation} = plot(input1, input2, sprintf('k%s', linevar)); hold on;

% Create ticks
x = input1(ticks);
y = input2(ticks);

if (variation == 1)
    auc(1) = 1 - auc(1); % Change to other convention
end

for i = 1:length(x)
    htick = plot(x(i), y(i), 'r.', 'markersize', 10); hold on;
    text(x(i)-0.04, y(i)+0.025, sprintf('%0.2f', cval(ticks(i))),'interpreter','latex','fontsize',6);
end

if (variation == 1)
    if (mode == 1)
    title('ROC curve, red = $c_{x}$ (cut on $x$)','interpreter','latex');
    end
    if (mode == 2)
    title('ROC curve, red = $c_{\ell R}$ (cut on likelihood ratio)','interpreter','latex');
    end
    if (mode == 3)
    title('ROC curve, red = $c_{B R}$ (cut on Bayes posterior)','interpreter','latex');
    end
    xlabel(sprintf('$\\epsilon_1^%s$ (signal rate = true positive $[1-\\beta]$)', in), 'interpreter','latex');
end
if (variation == 2)
    l = legend([hs{1}, hs{2}], ...
        {sprintf('$\\epsilon_2^%s$ (background rate = false positive $[\\alpha]$), 1-AUC = %0.2f', in, auc(1)), ...
         sprintf('$\\pi_1^%s$ (signal purity), AUC$_{P}$ = %0.2f', in, auc(2))});
    set(l,'AutoUpdate','off'); % Do not add more entries
    set(l,'interpreter','latex','fontsize',8);
end

% Draw diagonal
%plot(linspace(0,1,10), linspace(0,1,10), 'k--');

axis square; axis([0 1 0 1]);
set(gca,'xtick',round(linspace(0,1,9),2));
set(gca,'ytick',round(linspace(0,1,9),2));
end

filename = sprintf('ROC_mode_%d', mode);
print(f, sprintf('./figs/%s.pdf', filename), '-dpdf');
cmd = sprintf('pdfcrop --margins 10 ./figs/%s.pdf ./figs/%s.pdf', filename, filename); system(cmd);


%% Efficiency x Purities

f = figure;

plot(cval, eff1_in  .* pur1_in, '-'); hold on;
plot(cval, eff1_out .* pur1_out, '-');
plot(cval, eff2_in  .* pur2_in, '-');
plot(cval, eff2_out .* pur2_out, '-');
plot(cval, eff1_in  .* eff2_in, '-');
plot(cval, eff1_out .* eff2_out, '-');
plot(cval, pur1_in  .* pur2_in, '-');
plot(cval, pur1_out .* pur2_out, '-', 'color', [0.1 0.1 0.1]);

xlabel('$c_x$ (cut on $x$)','interpreter','latex');

l = legend(sprintf('$\\epsilon_1^%s \\pi_1^%s$', in, in), ...
           sprintf('$\\epsilon_1^%s \\pi_1^%s$', out, out), ...
           sprintf('$\\epsilon_2^%s \\pi_2^%s$', in, in), ...
           sprintf('$\\epsilon_2^%s \\pi_2^%s$', out, out), ...
           sprintf('$\\epsilon_1^%s \\epsilon_2^%s$', in, in), ...
           sprintf('$\\epsilon_1^%s \\epsilon_2^%s$', out, out), ...
           sprintf('$\\pi_1^%s \\pi_2^%s$', in, in), ...
           sprintf('$\\pi_1^%s \\pi_2^%s$', out, out));
set(l,'AutoUpdate','off'); % Do not add more entries
set(l,'interpreter','latex','location','northwest');
%set(gca,'yscale','log');
axis tight; axis square;
axis([min(cval) max(cval) 0 1]);

if (mode == 2)
    plot(ones(2,1), [0 1], 'k:'); % Vertical line
    xlabel('$c_{\ell R}$ (cut on likelihood ratio)','interpreter','latex');
    set(gca,'xscale','log');
end
if (mode == 3)
    plot(ones(2,1), [0 1], 'k:'); % Vertical line
    xlabel('$c_{B R}$ (cut on Bayes posterior)','interpreter','latex');
    set(gca,'xscale','log');
end

title('Efficiency $\times$ Purity combinations','interpreter','latex');

filename = sprintf('efficiencypurity_A_mode_%d', mode);
print(f, sprintf('./figs/%s.pdf', filename), '-dpdf');
cmd = sprintf('pdfcrop --margins 10 ./figs/%s.pdf ./figs/%s.pdf', filename, filename); system(cmd);


%% Crossed Efficiency x Purities

f = figure;

plot(cval, eff1_in  .* pur1_out, '-'); hold on;
plot(cval, eff1_out .* pur1_in, '-');
plot(cval, eff2_in  .* pur2_out, '-');
plot(cval, eff2_out .* pur2_in, '-');
plot(cval, eff1_in  .* eff2_out, '-');
plot(cval, eff1_out .* eff2_in, '-');
plot(cval, pur1_in  .* pur2_out, '-');
plot(cval, pur1_out .* pur2_in, '-', 'color', [0.1 0.1 0.1]);

l = legend(sprintf('$\\epsilon_1^%s \\pi_1^%s$', in, out), ...
           sprintf('$\\epsilon_1^%s \\pi_1^%s$', out, in), ...
           sprintf('$\\epsilon_2^%s \\pi_2^%s$', in, out), ...
           sprintf('$\\epsilon_2^%s \\pi_2^%s$', out, in), ...
           sprintf('$\\epsilon_1^%s \\epsilon_2^%s$', in, out), ...
           sprintf('$\\epsilon_1^%s \\epsilon_2^%s$', out, in), ...
           sprintf('$\\pi_1^%s \\pi_2^%s$', in, out), ...
           sprintf('$\\pi_1^%s \\pi_2^%s$', out, in));
set(l,'AutoUpdate','off'); % Do not add more entries
set(l,'interpreter','latex','location','northwest');
%set(gca,'yscale','log');
axis tight; axis square;
axis([min(cval) max(cval) 0 1]);

xlabel('$c_x$ (cut on $x$)','interpreter','latex');
if (mode == 2)
    plot(ones(2,1), [0 1], 'k:'); % Vertical line
    xlabel('$c_{\ell R}$ (cut on likelihood ratio)','interpreter','latex');
    set(gca,'xscale','log');
end
if (mode == 3)
    plot(ones(2,1), [0 1], 'k:'); % Vertical line
    xlabel('$c_{B R}$ (cut on Bayes posterior)','interpreter','latex');
    set(gca,'xscale','log');
end

title('Efficiency $\times$ Purity combinations','interpreter','latex');

filename = sprintf('efficiencypurity_B_mode_%d', mode);
print(f, sprintf('./figs/%s.pdf', filename), '-dpdf');
cmd = sprintf('pdfcrop --margins 10 ./figs/%s.pdf ./figs/%s.pdf', filename, filename); system(cmd);

end
