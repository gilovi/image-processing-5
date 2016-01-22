function [p_x, p_y,levels, patches] = createDB( pyr )
    % CREATEDB Sample 5 ª 5 patches from levels 1,2,3 of the input pyramid.
    % N represents the number of patches that are found in the three images.
    % Arguments:
    % pyr - 7 ª 1 cell created using createPyramid
    %
    % Outputs:
    % p_x - N ª 1 vector with the x coordinates of the centers of the patches in the DB
    % p_y - N ª 1 vector with the y coordinates of the centers of the patches in the DB
    % levels - N ª 1 vector with the pyramid levels where each patch was sampled
    % patches - N ª 5 ª 5 the patches
    %
    global border;
    border = 0;
    
    [S] = [size(pyr{1});size(pyr{2});size(pyr{3})];
    N = patch_num(S(:,1),S(:,2));
    p_x = zeros(N,1);
    p_y = zeros(N,1);
    patches = zeros(N,5,5);
    levels = cat(1 , ones(patch_num(S(1,1),S(1,2)),1),...
                 2 * ones(patch_num(S(2,1),S(2,2)),1),...
                 3 * ones(patch_num(S(3,1),S(3,2)),1) );
    
    p = 1;
    for i = 1:3
        [c_x, c_y, c_patch] = samplePatches(pyr{i}, border);
        p_x(p : p + numel(c_x)-1) = c_x(:);
        p_y(p : p + numel(c_y)-1) = c_y(:);
        n_patches = patch_num(S(i,1),S(i,2));
        patches(p : p + n_patches - 1, :, :) = reshape(c_patch, [n_patches, 5 , 5] );
        p = p + n_patches;
    end

end

function [n] = patch_num( r , c )
global border
    n = (r - 2 * (2 + border))' * (c - 2 * (2 + border));
end
