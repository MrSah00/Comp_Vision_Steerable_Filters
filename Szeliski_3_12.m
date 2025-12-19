% Perform Freeman and Adelson steering filter algorithm

% Loading image
img = imread("yoga.jpg");

% Convert to grayscale and double format for processing
if size(img, 3) == 3
    img = rgb2gray(img);
end
img = im2double(img);

% Defining Basis Filters (Second Derivatives of Gaussian)
sigma = 2.0; % Standard sigma of Gaussian
sz = ceil(sigma * 6); % To cover 3 sigma on each side
if mod(sz, 2) == 0, sz = sz + 1; end % Ensure filter size is odd
[x, y] = meshgrid(-floor(sz/2):floor(sz/2), -floor(sz/2):floor(sz/2));

% Gaussian component
G = exp(-(x.^2 + y.^2) / (2 * sigma^2));

% Second partial derivatives
Gxx = (x.^2 / sigma^4 - 1 / sigma^2) .* G / (2*pi*sigma^2);
Gyy = (y.^2 / sigma^4 - 1 / sigma^2) .* G / (2*pi*sigma^2);
Gxy = (x .* y / sigma^4) .* G / (2*pi*sigma^2);

% Convolving Image with Basis Filters to first find their responses
Rxx = imfilter(img, Gxx, 'replicate', 'conv');
Ryy = imfilter(img, Gyy, 'replicate', 'conv');
Rxy = imfilter(img, Gxy, 'replicate', 'conv');

% Steering the Response to 0 and 90 Degrees
R0 = (cosd(0))^2*Rxx + (sind(0))^2*Ryy + 2*sind(0)*cosd(0)*Rxy;
R90 = (cosd(90))^2*Rxx + (sind(90))^2*Ryy + 2*sind(90)*cosd(90)*Rxy;

% Displaying the Results ---
figure;
subplot(2, 2, 1);
imshow(img);
title('Original Image');

subplot(2, 2, 2);
imshow(R0, []); % [] to scale the display range
title('Output G0_1 (Response at 0 degrees)');

subplot(2, 2, 3);
imshow(R90, []);
title('Output G90_1 (Response at 90 degrees)');

% Create a combined multi-band image
multi_band_output = cat(3, R0, R90);
% To visualize the third "band", another channel of zeros is added
multi_band_display = cat(3, mat2gray(R0), mat2gray(R90), zeros(size(R0)));
subplot(2, 2, 4);
imshow(multi_band_display);
title('Combined Output (R=G0, G=G90)');

% Save all the generated images to files
imwrite(im2uint8(mat2gray(R0)), 'Freeman_0_degrees.png');
imwrite(im2uint8(mat2gray(R90)), 'Freeman_90_degrees.png');
imwrite(im2uint8(multi_band_display), 'Freeman_multi_band_output.png');