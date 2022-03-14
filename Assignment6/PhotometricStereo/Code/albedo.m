function albedo = albedo(images, mask_image, light, channel)

    [row, col, num_colors, num_images] = size(images);

    for i = 1: row
        for j = 1: col
            albedo(i,j) = 0.0;
        end
    end

    if channel == 0
        for n = 1: num_images
            gray_images(:,:,n) = rgb2gray(images(:,:,:,n));
        end
    end

    for i = 1:row
        for j = 1:col
            if(mask_image(i,j))

                for n = 1:num_images
                        channel_img(n,1) = im2double(images(i,j,channel, n));
                end

                inv_L = light';
                A = inv_L * light;
                b = inv_L * channel_img;
                g = inv(A) * b;
                
                alb_norm = norm(g);
                albedo(i,j) = alb_norm;
            end
        end
    end

    max_value = max(max(albedo));
    if(max_value > 0)
        albedo = albedo/max_value;
    end
end