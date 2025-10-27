clc
clear all
close all

% Setup the Import Options
opts1 = delimitedTextImportOptions("NumVariables", 1);

% Specify column names and types
opts1.VariableNames = "col";
opts1.VariableTypes = "double";
opts1.ExtraColumnsRule = "ignore";
opts1.EmptyLineRule = "read";

% Importazione immagini filtrate hardware e software
[FileName1, path1] = uigetfile({'*.txt';'*.coe';}, 'Selezionare immagine originale e filtrate','MultiSelect','on');
file = cellstr(FileName1);
original_image_vector = readmatrix(file{1},opts1);
dim = sqrt(size(original_image_vector));
original_image = uint8(reshape(original_image_vector, [dim(1) dim(1)])');

filtered_image_soft = readmatrix(file{3},opts1);
filtered_image_soft = uint8(reshape(filtered_image_soft,[dim(1) dim(1)])');

filtered_image_hard = readmatrix(file{2},opts1);
filtered_image_hard = filtered_image_hard(2:end);
filtered_image_hard = uint8(reshape(filtered_image_hard,[dim(1) dim(1)])');

% peak_snr = psnr(filtered_image_soft,filtered_image_hard);
peak_snr = PSNR(filtered_image_soft,filtered_image_hard);

[mssim,map_ssim] = MSSIM(filtered_image_soft, filtered_image_hard);

mdssim = (1-mssim)/2;           % global DSSIM
map_dssim = (1-map_ssim)/2;     %local DSSIM

[gmsd,map_gmsd] = GMSD(filtered_image_soft,filtered_image_hard);

% fsim = FeatureSIM(filtered_image_soft, filtered_image_hard);

figure(1)
subplot(1,3,1)
imshow(original_image);
title (['{\color{black}Original image}']); 
subplot(1,3,2)
imshow(filtered_image_soft);
title (['{\color{black}Laplaciano-Gaussiano1 MATLAB}']);
subplot(1,3,3)
imshow(filtered_image_hard);
title (['{\color{black}Laplaciano-Gaussiano1 VHDL}']);

figure(2)
subplot(1,4,1)
imshow(original_image);
title (['{\color{black}Original image}']); 
subplot(1,4,2)
imshow(map_ssim);
title (['{\color{black}Map SSIM}']);
subplot(1,4,3)
imshow(map_dssim);
title (['{\color{black}Map DSSIM}']);
subplot(1,4,4)
imshow(map_gmsd);
title (['{\color{black}Map GMSD}']);

message = sprintf('  PSNR = %.3f\n  MSSIM = %.3f\n  MDSSIM = %.3f\n  GMSD = %.3f', peak_snr, mssim, mdssim, gmsd);
msgbox(message);
