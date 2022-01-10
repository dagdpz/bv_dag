% igor_simple_demo.m
x1 = rand(1,100);
x2 = rand(1,100);
x3 = x1 + x2; % dependent variable
x3 = x3+rand(1,100)/10; % add some noise
% x3 = rand(1,100);
x4 = rand(1,100); % completely independent variable
x5 = rand(1,100);
x6 = x5 + rand(1,100)/10;

info = colldiag([x1 ; x2 ; x3; x4; x5; x6]',{'x1' 'x2' 'x3' 'x4' 'x5' 'x6'} );
colldiag_tableplot(info,1);
