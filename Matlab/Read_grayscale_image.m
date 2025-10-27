clc
clear all
close all

% Importazione immagine
[FileName, folder] = uigetfile({'*.tif';'*.png';'*.jpg';'*.bmp'}); 
image = imread(FileName); % Matrice di piexl (valore decimale)
% image_dec = imresize(image_dec,[64 64]);
[rows, columns, numberOfColorChannels] = size(image);

% conversione immagine rgb2gray
if numberOfColorChannels > 1
    image = rgb2gray(image);
end

figure
imshow(image);
title('Immagine originale');

figure
imagesc(image);
hold on
for row = 0.5:1:(rows+1)
        line([0, columns+1], [row, row], 'Color', 'k');
end
for col = 0.5:1:(columns+1)
        line([col, col], [0, rows+1], 'Color', 'k');
end
colormap("hot");
colorbar();
axis off;
title('Intensità dei pixels',FontSize=20);