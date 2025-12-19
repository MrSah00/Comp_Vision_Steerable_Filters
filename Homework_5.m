%%
close all; clear; clc;
% Step 1
% Reading image into 2 separate variables
I1 = imread("L01 Migrant Mother.png");
I2 = imread("L01 greatvalley.jpg");

% Step 2
% Setting Filter Parameters
sigma = 2; % Standard deviation of the Gaussian
sz = 45; % Filter size (higher numbers needed more computation time)
[x, y] = meshgrid(-floor(sz/2):floor(sz/2), -floor(sz/2):floor(sz/2));

% Step 3
% Creating Basis Filters (Derivatives of 2D Gaussian Function)

% Gx: Derivative with respect to x
Gx = -(x / (2 * pi * sigma^4)) .* exp(-(x.^2 + y.^2) / (2 * sigma^2));

% Gy: Derivative with respect to y
Gy = -(y / (2 * pi * sigma^4)) .* exp(-(x.^2 + y.^2) / (2 * sigma^2));

% Step 4
% Formatting images as grayscale double for processing
if size(I1, 3) == 3
    I1_gray = rgb2gray(I1); % Convert to grayscale if it's not
else
    I1_gray = I1;
end

if size(I2, 3) == 3
    I2_gray = rgb2gray(I2); % Convert to grayscale if it's not
else
    I2_gray = I2;
end

I1_gray = im2double(I1_gray); % Convert to double for convolution
I2_gray = im2double(I2_gray);

% Step 5
% Steering the Filter to 45 Degree Angle
theta = deg2rad(45); % Angle to steer (45 degrees)

% Interpolation functions
k_x = cos(theta);
k_y = sin(theta);

% Linear combination to create the steered filter
G_theta = k_x * Gx + k_y * Gy;

% Step 6
% Applying the steered filter using convolution to both images
filtered_I1 = conv2(I1_gray, G_theta, 'same'); % Keep output img size same
filtered_I2 = conv2(I2_gray, G_theta, 'same'); % Keep output img size same

% Step 7
% Displaying Results
figure;
subplot(2, 2, 1);
imshow(I1);
title('Original Image 1');

subplot(2, 2, 2);
imshow(filtered_I1, []); % [] to scale display range
title(['Image 1 Filtered at ' num2str(rad2deg(theta)) ' Degrees']);

subplot(2, 2, 3);
imshow(I2);
title('Original Image 2');

subplot(2, 2, 4);
imshow(filtered_I2, []); % [] to scale display range
title(['Image 2 Filtered at ' num2str(rad2deg(theta)) ' Degrees']);

% Step 8
% Save the filtered images
imwrite(mat2gray(filtered_I1), 'filtered_image1.png');
imwrite(mat2gray(filtered_I2), 'filtered_image2.png');
