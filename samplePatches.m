function [p_x,p_y, patches] = samplePatches( im , border )
% SAMPLEPATCHES Sample 5 ª 5 patches from the input image.
% Arguments:
% im - a grayscale image of size m ª n
% border - An integer that determines how much border we want to leave in the image.
% For example: if border=0 the center of the first patch will be at (3,3), 
% and the last one will be at (end?2,end?2), so the number of patches in this
% case is (m - 4) ª (n - 4). But if border=1 the center of the first patch will
% be at (4,4) and the last one will be at (end-3,end-3).
% So in general, the number of patches is (m ? 2 · (2 + border)) ª (n ? 2 · (2 + border)).
%
% outputs:
% p_x - (m - 2 · (2 + border)) ª (n - 2 · (2 + border)) matrix with the x indices of the centers of the patches
% p_y - (m - 2 · (2 + border)) ª (n - 2 · (2 + border)) matrix with the y indices of the centers of the patches
% patches - (m - 2 · (2 + border)) ª (n - 2 · (2 + border)) ª 5 ª 5 the patches

[r,c] = size(im); 
[p_x, p_y] = meshgrid(3+border : c - (2 + border), 3+border : r - (2 + border));

l_c = p_x(:);
l_r = p_y(:);

%  im=im2double(im);%a
%  fun = @(block_struct) (block_struct.data); %a
%  Y = blockproc(im,[1,1],fun,'BorderSize',[2,2], 'TrimBorder' ,false,'UseParallel',false); %a
%  m = mat2cell(Y,ones(1,r)*5,ones(1,c)*5); %a
%  m = m(3 + border : end - (2+border) , 3+border : end - (2+border)); %a
% 
% [mr,mc] = size(m); %a
% patches = reshape(permute((cell2mat(reshape(m,1,1,numel(m)))), [3 1 2]),mr,mc,5,5); %a

patches = zeros(5 , 5, length(l_r)); 

for i = 1 : length(l_r)  
      patches(:,:,i) = im(l_r(i)-2:l_r(i)+2 , l_c(i)-2:l_c(i)+2);
end

patches = permute(reshape(patches,5,5,r-2*(2 + border),c-2*(2 + border)),[3,4,1,2]); %o
