function [image] = getImage(assignmentPositionsX,assignmentPositionsY,samplingPositionsX,...
    samplingPositionsY,weights,emptyHighResImage,renderedPyramid)
% GETIMAGE given an image of the rendered pyrmamid, sampling indices from the rendered
% pyrmamid, and assignment indices in the highres image return a high resolution image
%
% Arguments:
% assignmentPositionsX ? (m ? 4) ª (n ? 4) ª 3 ª 5 ª 5 x assignment coordinates in the high resolution image (
% getSamplingInformation output)
% assignmentPositionsY ? (m ? 4) ª (n ? 4) ª 3 ª 5 ª 5 y assignment coordinates in the high resolution image (
% getSamplingInformation output)
% samplingPositionsX ? (m ? 4) ª (n ? 4) ª 3 ª 5 ª 5 x sampling coordinates in the rendered pyramid image (
% getSamplingInformation output)
% samplingPositionsY ? (m ? 4) ª (n ? 4) ª 3 ª 5 ª 5 y sampling coordinates in the rendered pyramid image (
% getSamplingInformation output)
% weights ? (m ? 4) ª (n ? 4) ª 3 matrix with the weights for each DB candidate
% emptyHighResImage ? M ª N zeros image, where M and N are the dimensions of a level in the pyramid that should
% be reconstructed in this function
% renderedPyramid ? a single image containing all levels of the pyramid
%
% Outputs:
% image ? M ª N high resolution image
%
I = repmat(emptyHighResImage,[1,1,3,25]);
for i = 1:25
    [xp,yp]=ind2sub(i);
    I(:,:,:,i) = interp2(samplingPositionsX(xp:5:end), samplingPositionsY(yp:5:end),...
        renderedPyramid, assignmentPositionsX, assignmentPositionsY);
end