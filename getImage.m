function [image] = getImage(assignmentPositionsX,assignmentPositionsY,samplingPositionsX,...
    samplingPositionsY,weights,emptyHighResImage,renderedPyramid)
% GETIMAGE given an image of the rendered pyrmamid, sampling indices from the rendered
% pyrmamid, and assignment indices in the highres image return a high resolution image
%
% Arguments:
% assignmentPositionsX - (m - 4)  x (n - 4)  x 3  x 5  x 5 assignment coordinates in the high resolution image (
% getSamplingInformation output)
% assignmentPositionsY - (m - 4)  x (n - 4)  x 3  x 5  x 5 y assignment coordinates in the high resolution image (
% getSamplingInformation output)
% samplingPositionsX - (m - 4)  x (n - 4)  x 3  x 5  x 5 sampling coordinates in the rendered pyramid image (
% getSamplingInformation output)
% samplingPositionsY - (m - 4)  x (n - 4)  x 3  x 5  x 5 y sampling coordinates in the rendered pyramid image (
% getSamplingInformation output)
% weights - (m - 4)  x (n - 4)  x 3 matrix with the weights for each DB candidate
% emptyHighResImage - M  x N zeros image, where M and N are the dimensions of a level in the pyramid that should
% be reconstructed in this function
% renderedPyramid - a single image containing all levels of the pyramid
%
% Outputs:
% image - M x N high resolution image
%


%I = repmat(emptyHighResImage,[1,1,75]);
[yp,xp,~] = ind2sub([5,5,3], 1:75);
fw = repmat(weights, [1,1,1,5,5]);
fw(:) = 1;
w = zeros (size(emptyHighResImage));
for i = 1:25*3
  
        im = interp2(renderedPyramid,...
            samplingPositionsX( xp(i):4:end, yp(i):4:end, :, :, :),...
            samplingPositionsY( xp(i):4:end, yp(i):4:end, :, :, :), 'cubic');
        im(isnan(im)) = 0;
        ind = sub2ind(size(emptyHighResImage)...
            ,assignmentPositionsY( xp(i):4:end, yp(i):4:end, :, :, :), ...
            assignmentPositionsX( xp(i):4:end, yp(i):4:end, :, :, :) );
        wt = fw(xp(i):4:end, yp(i):4:end, :, :, :);
        emptyHighResImage(ind) = emptyHighResImage(ind) + (wt .* im) ;
        w(ind) = w(ind) + wt ;
end

image = emptyHighResImage./75;



