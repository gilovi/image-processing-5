function [n] = patch_num( r , c ,border)
    border = 2;
    n = (r - 2 * (2 + border))' * (c - 2 * (2 + border));
end