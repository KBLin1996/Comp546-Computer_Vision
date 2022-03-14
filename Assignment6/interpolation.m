function output_image = interpolation(depth_image, method)
    [x, y] = find(depth_image ~= Inf);
     v = depth_image(depth_image ~= Inf);

    [xq, yq] = find(depth_image == Inf);
    vq = griddata(x, y, v, xq, yq, method);

    output_image = depth_image;
    output_image(depth_image == Inf) = vq;
end