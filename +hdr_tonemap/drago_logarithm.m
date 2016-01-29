function ldr = drago_logarithm( hdr_img, p, Ldmax )

if nargin < 3
    % cd/m2
    Ldmax = 100;
end

if nargin < 2
    % 0.7~0.9 is appropriate, and 0.85 default value is from the book
    p = 0.85;
end

L = hdr_img;
Lwmax = max(max(max(hdr_img)));

A = Ldmax./100;
B = log10(1+Lwmax);
C = log10(1+L);
D = log10( 2 + 8.*((L./Lwmax).^(log10(p)./log10(.5))) );
ldr = A ./ B .* C ./ D;

end