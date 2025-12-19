%%
% Loading the sample peppers image
img = imread("peppers.png");
img_double = im2double(img); % Converting to double for multiplications

% Color balancing by multiplying values to individual channels
% Original image seems warm
% So, correcting for a yellowish tint by boosting blue and reducing red.
r_mult = 0.85;  % Reduce the red channel
g_mult = 1.0;  % Keep green the same
b_mult = 1.15;  % Boost the blue channel

% Applying color balance
balanced_img = img_double; % Create a copy to modify

% Apply the multiplication to each channel
balanced_img(:, :, 1) = balanced_img(:, :, 1) * r_mult; % Red channel
balanced_img(:, :, 2) = balanced_img(:, :, 2) * g_mult; % Green channel
balanced_img(:, :, 3) = balanced_img(:, :, 3) * b_mult; % Blue channel

% Clip the values so they stay within the valid [0, 1] range
balanced_img = clip(balanced_img, 0, 1);

% Save the color balanced image
% Ensure the output image is in the correct format for saving
balanced_img = im2uint8(balanced_img);
imwrite(img, 'peppers.png');
imwrite(balanced_img, 'color_balanced_peppers.png');

% Perform gamma correction and then color balancing
% Apply gamma correction with a gamma value of 1.5
gamma = 2.0;
gamma_corrected_img = imadjust(img_double, [], [], gamma);

% Apply color balancing on the gamma corrected image
gamma_col_bal_img = gamma_corrected_img;
% Apply the multiplication to each channel of the gamma corrected image
gamma_col_bal_img(:, :, 1) = gamma_col_bal_img(:, :, 1) * r_mult; % Red channel
gamma_col_bal_img(:, :, 2) = gamma_col_bal_img(:, :, 2) * g_mult; % Green channel
gamma_col_bal_img(:, :, 3) = gamma_col_bal_img(:, :, 3) * b_mult; % Blue channel

% Save the gamma color balanced image
gamma_col_bal_img = im2uint8(gamma_col_bal_img);
imwrite(gamma_col_bal_img, 'gamma_color_balanced_peppers.png');

% Perform color balancing and then gamma correction
% Apply gamma correction on the color balanced image
col_bal_gamm_corr_img = imadjust(balanced_img, [], [], gamma);

% Save the color balanced gamma corrected image
col_bal_gamm_corr_img = im2uint8(col_bal_gamm_corr_img);
imwrite(col_bal_gamm_corr_img, 'gamma_corrected_balanced_peppers.png');


% Displaying the Results
figure;
subplot(2, 2, 1);
imshow(img);
title('Original Image');

subplot(2, 2, 2);
imshow(balanced_img);
title('Color Balanced Image');

subplot(2, 2, 3);
imshow(gamma_col_bal_img);
title('Gamma Corrected Color Balanced Image');

subplot(2, 2, 4);
imshow(col_bal_gamm_corr_img);
title('Color Balanced Gamma Corrected Image');
