A = [ -0.7  0    0.3  0   -0.5 -0.1
      -0.6  0.2 -0.4 -0.3  0    0
      -0.5  0.7 -0.1  0    0   -0.8
      -0.7  0    0   -0.5 -1.0  0
       0    0.3  0.6 -0.9  0.1 -0.4
       0.5 -0.8  0    0    0.2 -0.9 ];

B = [ -1   -2   -2    1    0
       1    0    1   -2    1
      -3   -4    0    2   -2
       1   -2    1    0   -1
       0    1   -2    0    3
       1    0    3   -1   -2 ];

C = [  1   -1    2   -2    0   -3
      -3    0    1   -1    1    0
       0    2    0   -4    0   -2
       1   -3    0    0    3    1
       0    1   -2    1    0   -2 ];

D = [  1   -1   -2    0    0
       0    1    0    1    0
       2   -1   -3    0    1
       0    1    0    1   -1
       0    0    1    2    1 ];
     
% direct discrete
G = ss (A, B, C, D, 1);
[Kd, Nd, GAMd] = hinfsyn (G, 2, 2, "gmax", 300, "tolgam", 1e-12);
GAMd

% using c2d
Gc = d2c (G, 'tustin');
[Kc, Nc, GAMc] = hinfsyn (Gc, 2, 2, "gmax", 300, "tolgam", 1e-12);
GAMc
Kc = c2d (Kc, 1, 'tustin');
Nc = lft (G, Kc);
GAMc = norm(Nc)

