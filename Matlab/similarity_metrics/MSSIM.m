function [mssim,ssim_map] = MSSIM(imageReference,imageUnderTest)


%///////////////////////////////// INITS  ////////////////////////////////
C1 = 6.5025;
C2 = 58.5225;
imageReference=double(imageReference);
imageUnderTest=double(imageUnderTest);
imageReference_2=imageReference.^2;
imageUnderTest_2=imageUnderTest.^2;
imageReference_imageUnderTest=imageReference.*imageUnderTest;
%///////////////////////////////// PRELIMINARY COMPUTING ////////////////////////////////
mu1=imgaussfilt(imageReference,1.5);
mu2=imgaussfilt(imageUnderTest,1.5);
mu1_2=mu1.^2;
mu2_2=mu2.^2;
mu1_mu2=mu1.*mu2;

sigma1_2=imgaussfilt(imageReference_2,1.5);
sigma1_2=sigma1_2-mu1_2;
sigma2_2=imgaussfilt(imageUnderTest_2,1.5);
sigma2_2=sigma2_2-mu2_2;
sigma12=imgaussfilt(imageReference_imageUnderTest,1.5);
sigma12=sigma12-mu1_mu2;


%///////////////////////////////// FORMULA ////////////////////////////////

t3 = ((2*mu1_mu2 + C1).*(2*sigma12 + C2));
t1 =((mu1_2 + mu2_2 + C1).*(sigma1_2 + sigma2_2 + C2));
ssim_map =  t3./t1;
mssim = mean2(ssim_map); mssim=mean(mssim(:));
