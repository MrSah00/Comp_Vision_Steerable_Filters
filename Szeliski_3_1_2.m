% Determining color balance ratios of an image
img = imread('yoga.jpg');
colorBalance = sum(img, [1, 2]) ./ numel(img(:,:,1));
% Display the color balance ratios
disp('Color Balance Ratios:');
disp(colorBalance);