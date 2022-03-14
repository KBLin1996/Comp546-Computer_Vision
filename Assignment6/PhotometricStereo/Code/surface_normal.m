function normal = surface_normal(images, mask_image, light)
    normal = [];

    [row, col, ~, num_images] = size(images);

    for i = 1 : row
        for j = 1 : col
            normal(i, j, 1) = 0.0;
            normal(i, j, 2) = 0.0;
            normal(i, j, 3) = 1.0;
        end
    end

    for n = 1: num_images
        gray_images(:, :, n) = rgb2gray(images(:, :, :, n));
    end

    for i = 1:row
        for j = 1:col
            if(mask_image(i, j))

                for n = 1:num_images
                    channel_img(n, 1) = im2double(gray_images(i, j, n));
                end

                inv_light = light';
                A = inv_light * light;
                b = inv_light * channel_img;
                g = inv(A) * b;

                alb_norm = norm(g);
                unit_normal = g / alb_norm;

                normal(i, j, 1) = unit_normal(1);
                normal(i, j, 2) = unit_normal(2);
                normal(i, j, 3) = unit_normal(3);
            end
        end
    end

    normal(mask_image == 0) = 0;
end