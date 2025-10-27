% Script per convertire immagini grayscale in un file di testo.
% Immagini e script matlab devo essere nella stessa cartella.

clc
clear all
close all

% Importazione immagine
[FileName, folder] = uigetfile({'*.jpg';'*.tif';'*.png';'*.bmp'});
image = imread(FileName); % Matrice di piexl (valore decimale)
[rows, columns, numberOfColorChannels] = size(image);

% conversione immagine rgb2gray
if numberOfColorChannels > 1
    image = rgb2gray(image);
end
imwrite(image,'bird.tif')

VectorImage = reshape(image',[],1); % Trasformazione matrice di pixel in un vettore di pixel

file = fopen('C:\Users\Giuseppe Pirilli\Desktop\Progetto_circuito_filtraggio_spaziale\Matlab\convert_image2txt\bird64_grayscale.txt','wt');
    for j=1:numel(VectorImage)
        fprintf(file,'%d\n',VectorImage(j));
    end
fclose(file);