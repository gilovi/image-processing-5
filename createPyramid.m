function pyr = createPyramid( im )
% CREATEPYRAMID Create a pyramid from the input image, where pyr{1} is the smallest level,
% pyr{4} is the input image, and pyr{5},pyr{6},pyr{7} are zeros.
% The ratio between two adjacent levels in the pyramid is 2(1/3).
% Arguments:
% im ? a grayscale image
%
% outputs:
% pyr - A 7 ª 1 cell of matrices.

pyr = cell(1,7);
pyr{4} = im;

for i=3:-1:1
  pyr{i} = imresize(pyr{i+1} ,1/(2^(1/3))); 
end

for i=5:7
    pyr{i} = zeros(round(size(pyr{i-1})*(2^(1/3))));
end
pyr = pyr';