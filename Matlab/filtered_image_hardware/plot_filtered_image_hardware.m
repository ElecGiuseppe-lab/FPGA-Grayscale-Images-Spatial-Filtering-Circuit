clc
clear all
close all


% Setup the Import Options
opts1 = delimitedTextImportOptions("NumVariables", 1);
opts2 = delimitedTextImportOptions("NumVariables", 1);

% Specify range and delimiter
opts2.DataLines = [2, inf];

% Specify column names and types
opts1.VariableNames = "col";
opts1.VariableTypes = "double";
opts1.ExtraColumnsRule = "ignore";
opts1.EmptyLineRule = "read";

opts2.VariableNames = "col";
opts2.VariableTypes = "double";
opts2.ExtraColumnsRule = "ignore";
opts2.EmptyLineRule = "read";

% Importazione immagine originale in forma vettoriale
[FileName1, path1] = uigetfile({'*.txt';'*.coe';}, 'Selezionare immagine originale');
original_image_vector = readmatrix(FileName1,opts1);
dim = sqrt(size(original_image_vector));
original_image = uint8(reshape(original_image_vector, [dim(1) dim(1)]))';         % si passa dalla forma vettoriale a quella matriciale

% Importazione immagine/i filtrata/e in forma vettoriale
[FileName2,path2]=uigetfile({'*.txt';'*.coe';}, 'Selezionare immagine/i filtrata/e', 'MultiSelect','on');
file = cellstr(FileName2);

if (numel(file) > 1)
    for i=1:numel(file)            
        filtered_image_vector(:,i) = readmatrix(file{i}, opts2);
        filtered_image_hard(1,i) = {double(reshape(filtered_image_vector(:,i), [dim(1) dim(1)]))'};  %utilizzare 'uint8' al posto di 'double' per saturazione
%         imwrite(filtered_image_hard{i}, [file{i},'.tif']);
    end

    figure(1)
    subplot(2,3,1)
    imshow(original_image);
    title (['{\color{black}Original image}']); 
    subplot(2,3,2)
    imshow(filtered_image_hard{1});
    title (['{\color{black}Laplaciano-Gaussiano1 VHDL}']); 
    subplot(2,3,3)
    imshow(filtered_image_hard{2});
    title (['{\color{black}Laplaciano-Gaussiano2 VHDL}']);     
    subplot(2,3,4)
    imshow(filtered_image_hard{3});
    title (['{\color{black}Laplaciano1 VHDL}']); 
    subplot(2,3,5)
    imshow(filtered_image_hard{4});
    title (['{\color{black}Laplaciano2 VHDL}']); 
    subplot(2,3,6)
    imshow(filtered_image_hard{5});
    title (['{\color{black}Laplaciano3 VHDL}']); 

else
    
    figure(1)
    imshow(original_image);

    filtered_image_vector = readmatrix(FileName2, opts2);
    filtered_image_hard = {double(reshape(filtered_image_vector, [dim(1) dim(1)]))'};
    figure(1)
    imshow(original_image);
    figure(2)
    imshow(filtered_image_hard{1});
    title (['{\color{black}Laplaciano1 VHDL}']);
%     imwrite(filtered_image_hard{1}, [file{1},'.tif']);
end
  