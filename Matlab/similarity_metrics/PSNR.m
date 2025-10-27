function [peak,MSE] = PSNR(img1, img2)

img1 = double(img1);
img2 = double(img2);
[M, N] = size(img1);
squared_error=0;

for i=1:N
    for j=1:M
        squared_error=squared_error+(img1(i,j)-img2(i,j))^2;
    end
end

MSE=squared_error/(M*N);
peak=10*log10(255^2/MSE);

return