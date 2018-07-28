% Efficiency inverse system equations
%
% mikael.mieskolainen@cern.ch, 2018
clear;
close all;


%{
%Q = 0, M = 2
%-------------------

p1p0 = T2*e0*e0 * A + T4*e0*e0*(1-e0)*(1-e0) * C + T4*e0*e0*(1-e1)*(1-e1) * E
k1k0 = T2*e1*e1 * B + T4*e1*e1*(1-e1)*(1-e1) * D + T4*(1-e0)*(1-e0)*e1*e1 * E 
p1k0 = T2*e0*(1-e0)*(1-e1)*e1 * E
p0k1 = T4*(1-e0)*e0*e1*(1-e1) * E

%Q = 0, M = 4
%-------------------
p1p0p1p0 = T4*e0*e0*e0*e0 * C + T6*e0*e0*e0*e0*(1-e0)*(1-e0) * F
k1k0k1k0 = T4*e1*e1*e1*e1 * D + T6*e1*e1*e1*e1*(1-e1)*(1-e1) * G
p1p0k1k0 = T4*e0*e0*e1*e1 * E + T6*e0*e0*(1-e0)*(1-e0)*e1*e1 * H

%Q = 0, M = 6
%-------------------
p1p0p1p0p1p0 = T6*e0*e0*e0*e0*e0*e0 * F + ...
k1k0k1k0k1k0 = T6*e1*e1*e1*e1*e1*e1 * G + ...
p1p0p1p0k1k0 = T6*e0*e0*e0*e0*e1*e1 * H + ...
p1p0k1k0k1k0 = T6*e0*e0*e1*e1*e1*e1 * I + ...

%Q = +-1, M = 3
%-------------------

p1p0p1 = T4*e0*e0*e0*(1-e0) * C + T6*e0*e0*e0*(1-e0)*(1-e0)*(1-e0) * F + T6*e0*e0*e0*(1-e0)*(1-e1)*(1-e1) * H
p0p1p0 = T4*(1-e0)*e0*e0*e0 * C + T6*(1-e0)*e0*e0*e0*(1-e0)*(1-e0) * F + T6*(1-e0)*e0*e0*e0*(1-e1)*(1-e1) * H
k1k0k1 = T4*e1*e1*e1*(1-e1) * D + T6*e0*e0*e0*(1-e0)*(1-e0)*(1-e0) * G + T6*e0*e0*e0*(1-e0)*(1-e1)*(1-e1) * I
k0k1k0 = T4*(1-e1)*e1*e1*e1 * D + T6*(1-e0)*e0*e0*e0*(1-e0)*(1-e0) * G + T6*(1-e0)*e0*e0*e0*(1-e1)*(1-e1) * I

%Q = +-2, M = 2
%-------------------

p1p1 = T4*e0*(1-e0)*e0*(1-e0) * C
p0p0 = T4*(1-e0)*e0*(1-e0)*e0 * C
k1k1 = T4*e1*(1-e1)*e1*(1-e1) * D
k0k0 = T4*(1-e1)*e1*(1-e1)*e1 * D

%Q = +-3, M = 3
%-------------------

p1p1p1 = T6*e0*(1-e0)*e0*(1-e0)*e0*(1-e0) * F
p0p0p0 = T6*(1-e0)*e0*(1-e0)*e0*(1-e0)*e0 * F
k1k1k1 = T6*e1*(1-e1)*e1*(1-e1)*e1*(1-e1) * G
k0k0k0 = T6*(1-e1)*e1*(1-e1)*e1*(1-e1)*e1 * G 

%Unknown Q = 0
%-------------------

A = p1p0         (M = 2)
B = k1k0
C = p1p0p1p0     (M = 4)
D = k1k0k1k0
E = p1p0k1k0
F = p1p0p1p0p1p0 (M = 6)
G = k1k0k1k0k1k0
H = p1p0p1p0k1k0
I = p1p0k1k0k1k0
%}

%%
e0 = sym('e0');
e1 = sym('e1');
T1 = sym('T1');
T2 = sym('T2');
T3 = sym('T3');
T4 = sym('T4');
T5 = sym('T5');
T6 = sym('T6');

assume(e0,'real');
assume(e1,'real');
assume(T1,'real');
assume(T2,'real');
assume(T3,'real');
assume(T4,'real');
assume(T5,'real');
assume(T6,'real');

X = [T2*e0*e0, 0, T4*e0*e0*(1-e0)*(1-e0), 0, T4*e0*e0*(1-e1)*(1-e1), 0, 0, 0, 0
 0, T2*e1*e1, 0, T4*e1*e1*(1-e1)*(1-e1), T4*(1-e0)*(1-e0)*e1*e1, 0, 0, 0, 0
 0,0,0,0,T2*e0*(1-e0)*(1-e1)*e1,0,0,0,0
 0,0,0,0,T4*(1-e0)*e0*e1*(1-e1),0,0,0,0
 0,0,T4*e0*e0*e0*e0,0,0,T6*e0*e0*e0*e0*(1-e0)*(1-e0),0,0,0
 0,0,0,T4*e1*e1*e1*e1,0,0,T6*e1*e1*e1*e1*(1-e1)*(1-e1),0,0
 0,0,0,0,T4*e0*e0*e1*e1,0,0,T6*e0*e0*(1-e0)*(1-e0)*e1*e1,0
 0,0,0,0,0,T6*e0*e0*e0*e0*e0*e0,0,0,0
 0,0,0,0,0,0,T6*e1*e1*e1*e1*e1*e1,0,0
 0,0,0,0,0,0,0,T6*e0*e0*e0*e0*e1*e1,0
 0,0,0,0,0,0,0,0,T6*e0*e0*e1*e1*e1*e1
 0,0,T4*e0*e0*e0*(1-e0),0,0,T6*e0*e0*e0*(1-e0)*(1-e0)*(1-e0),0,T6*e0*e0*e0*(1-e0)*(1-e1)*(1-e1),0
 0,0,T4*(1-e0)*e0*e0*e0,0,0,T6*(1-e0)*e0*e0*e0*(1-e0)*(1-e0),0,T6*(1-e0)*e0*e0*e0*(1-e1)*(1-e1),0
 0,0,0,T4*e1*e1*e1*(1-e1),0,0,T6*e0*e0*e0*(1-e0)*(1-e0)*(1-e0),0,T6*e0*e0*e0*(1-e0)*(1-e1)*(1-e1)
 0,0,0,T4*(1-e1)*e1*e1*e1,0,0,T6*(1-e0)*e0*e0*e0*(1-e0)*(1-e0),0,T6*(1-e0)*e0*e0*e0*(1-e1)*(1-e1)
 0,0,T4*e0*(1-e0)*e0*(1-e0),0,0,0,0,0,0
 0,0,T4*(1-e0)*e0*(1-e0)*e0,0,0,0,0,0,0
 0,0,0,T4*e1*(1-e1)*e1*(1-e1),0,0,0,0,0
 0,0,0,T4*(1-e1)*e1*(1-e1)*e1,0,0,0,0,0
 0,0,0,0,0,T6*e0*(1-e0)*e0*(1-e0)*e0*(1-e0),0,0,0
 0,0,0,0,0,T6*(1-e0)*e0*(1-e0)*e0*(1-e0)*e0,0,0,0
 0,0,0,0,0,0,T6*e1*(1-e1)*e1*(1-e1)*e1*(1-e1),0,0
 0,0,0,0,0,0,T6*(1-e1)*e1*(1-e1)*e1*(1-e1)*e1,0,0];


Xpinv = simplify(pinv(X));

%% Compile latex
texstring = latex(Xpinv);

file = fopen('system.tex', 'w');
fprintf(file, '%s', texstring);
fclose(file);


%% Create the latex file and create pdf
mainID = fopen('inverse.tex','w');

fprintf(mainID,'\\documentclass[12pt]{article}\n');
%fprintf(mainID,'\\twocolumn \n');
fprintf(mainID,'\\usepackage[left=10px,right=10px,top=10px,bottom=10px,paperwidth=8in,paperheight=85in]{geometry}\n');
%fprintf(mainID,'\\usepackage{multicol}\n');
fprintf(mainID,'\\begin{document}\n');
fprintf(mainID,'\\huge{Feed-Down Pseudoinverse} \\\\ \n');
fprintf(mainID,'\\large{mikael.mieskolainen@cern.ch} \\\\ \n');
fprintf(mainID,'\\vspace{5em} \\\\ \n');
fprintf(mainID,'\\tiny \n');
fprintf(mainID,'$\n');
fprintf(mainID,'\\input{system.tex}\n');
fprintf(mainID,'$\n');
fprintf(mainID,'\\end{document}\n');

fclose(mainID);


%%
% Note the buffer increase
system('buf_size=1000000 pdflatex inverse.tex');


%%
system('rm inverse.aux inverse.log');

