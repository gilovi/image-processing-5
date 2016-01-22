function [x,y,t] = threshold( im )
    [dx,dy] = translateImageHalfPixel(im);
    
    [x,y,p] = samplePatches( im , 0 );
    [~,~,px] = samplePatches( dx , 0 );
    [~,~,py] = samplePatches( dy , 0 );
    
    % change shape to 25 X (num of patches)
    p = reshape(permute(reshape(p, numel(x),5,5),[2,3,1]),25,numel(x));
    px = reshape(permute(reshape(px, numel(x),5,5),[2,3,1]),25,numel(x));
    py = reshape(permute(reshape(py, numel(y),5,5),[2,3,1]),25,numel(y));
    
    t = (sqrt(sum((p - px).^2)) + sqrt(sum((p - py).^2)))'/2;
    x = x(:);
    y = y(:);
end