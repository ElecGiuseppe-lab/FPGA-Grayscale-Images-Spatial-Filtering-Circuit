clc
clear all
close all

tic

% Setup the Import Options
opts1 = delimitedTextImportOptions("NumVariables", 1);

% Specify column names and types
opts1.VariableNames = "col";
opts1.VariableTypes = "double";
opts1.ExtraColumnsRule = "ignore";
opts1.EmptyLineRule = "read";

% Importazione immagine originale da filtrare in forma vettoriale
[FileName1, path1] = uigetfile({'*.txt';'*.coe';}, 'Selezionare immagine originale');
original_image_vector = readmatrix(FileName1,opts1);
dim = sqrt(size(original_image_vector));
original_image = uint8(reshape(original_image_vector, [dim(1) dim(1)]))';         % si passa dalla forma vettoriale a quella matriciale

array_sx = original_image(1:end-1,end-1:end)';
array_sx = horzcat([0;0],array_sx)';
array_dx = original_image(2:end,1:2)';
array_dx = horzcat(array_dx,[0;0])';
toroidal_pad_image = horzcat(array_sx,original_image,array_dx);     % estensione toroidale ai bordi laterali
ZeroPadding_original_image = padarray(toroidal_pad_image, [2,0]);   % estensione con zeri ai bordi superiore e inferiore

% Laplacian1_kernel = [0 0 0 0 0;
%                      0 -1 -1 -1 0;
%                      0 -1 8 -1 0;
%                      0 -1 -1 -1 0;
%                      0 0 0 0 0];


Laplacian2_kernel = [-1 -1 1 -1 -1;
                     -1 -1 1 -1 -1;
                      1  1 8  1  1;
                     -1 -1 1 -1 -1;
                     -1 -1 1 -1 -1];

% Laplacian3_kernel = [-1 -1 -1 -1 -1;
%                      -1 -1 -1 -1 -1;
%                      -1 -1 24 -1 -1;
%                      -1 -1 -1 -1 -1;
%                      -1 -1 -1 -1 -1];

% LaplacianGaussian1_kernel = [ 0  0 -1  0  0;
%                               0 -1 -2 -1  0;
%                              -1 -2 16 -2 -1;
%                               0 -1 -2 -1  0;
%                               0  0 -1  0  0];

% LaplacianGaussian2_kernel = [ 0  0  1  0  0;
%                               0  1  2  1  0;
%                               1  2 -16 2  1;
%                               0  1  2  1  0;
%                               0  0  1  0  0];

% Per l'operazione di convoluzione converto l'immagine da uint8 a double per evitare che i pixel
% siano saturati in un range di valori compreso tra 0 e 255
filtered_image_soft = conv2(ZeroPadding_original_image,Laplacian2_kernel,"valid");  
filtered_image_soft_vec = reshape(filtered_image_soft',[],1);

nome=fopen('filtered_books64_grayscale_laplaciano2_soft.txt','wt');
    for j=1:numel(filtered_image_soft_vec)
        fprintf(nome,'%d\n',filtered_image_soft_vec(j));
    end
fclose(nome);

toc

figure(1)
imshow(original_image);
figure(2)
imshow(filtered_image_soft);


  