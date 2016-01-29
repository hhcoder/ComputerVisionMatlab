% Quality factors
x = [95 90 85 80 75];

% bpp on H2V2 image
y_mean = [2.8497 1.8614 1.4192 1.1724 1.0007];
y_std = [0.6324 0.4555 0.3700 0.3223 0.2886];

%% R-D Curve
figure,
plot(y_mean(end:-1:1), 100./x(end:-1:1));
title('R-D curve');
xlabel('Rate - bpp');
ylabel('Distortion - (100/Q)');

%% R-Q Curve
figure,
plot(y_mean(end:-1:1), x(end:-1:1));
title('R-Q curve');
xlabel('Rate - bpp');
ylabel('Quality');

%% BPP vs Q factor
figure,
errorbar(x(end:-1:1), y_mean(end:-1:1), -y_std(end:-1:1), y_std(end:-1:1));
title('JPEG quality vs file size');
xlabel('Quality');
ylabel('Rate - bpp');

%% File size vs Q factor
figure,
bpp2size = @(bpp)(5.*1024.*bpp./8);
errorbar(x, bpp2size(y_mean), -bpp2size(y_std), bpp2size(y_std));
title('JPEG quality vs file size');
xlabel('Q factor');
ylabel('5MP file size (in KB)');
