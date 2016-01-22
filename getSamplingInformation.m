function [assignmentPositionsX,assignmentPositionsY,samplingPositionsX,samplingPositionsY] = getSamplingInformation...
    (sampleCentersX,sampleCentersY,pyr,inputPatchesCentersX,inputPatchesCentersY,levelsUp)
% GETSAMPLINGINFORMATION
% Get the information for sampling a high resolution image.
% Pairs of: assignment positions in the high resolution image,
% and sampling positions from the rendered pyramid image
% Arguments:
% sampleCentersX ? (m ? 4) � (n ? 4) � 3 matrix with the x coordinates of the
% center of the high resolution patches in the rendered image.
% This variable should be returned from getSamplingCenter function. (green x locations)
% sampleCentersY ? (m ? 4) � (n ? 4) � 3 matrix with the y coordinates of the
% center of the high resolution patches in the rendered image.
% This variable should be returned from getSamplingCenters function. (green y locations).
% pyr ? 7 � 1 cell created using createPyramid
% inputPatchesCentersX ? (m ? 4) � (n ? 4) input patches center x coordinates
% inputPatchesCentersY ? (m ? 4) � (n ? 4) input patches center y coordinates
% levelsUp ? integer which tells how much levels up we need to sample the window,
% from the found patch. In the figure the case is levelsUp=1
%
% Outputs:
% assignmentPositionsX ? (m ? 4) � (n ? 4) � 3 � 5 � 5 x assignment coordinates
% in the high resolution image (see figure)
% assignmentPositionsY ? (m ? 4) � (n ? 4) � 3 � 5 � 5 y assignment coordinates
% in the high resolution image (see figure)
% samplingPositionsX ? (m ? 4) � (n ? 4) � 3 � 5 � 5 x sampling coordinates
% in the rendered pyramid image (see figure)
% samplingPositionsY ? (m ? 4) � (n ? 4) � 3 � 5 � 5 y sampling coordinates
% in the rendered pyramid image (see figure)
%

%getting assignment centers
levels = ones(size(inputPatchesCentersX))*4;
[x_target,y_target] = transformPointsLevelsUp(inputPatchesCentersX, inputPatchesCentersY,levels, pyr, levelsUp );
x_target = repmat(3, x_target, x_target, x_target);
y_target = repmat(3, y_target, y_target, y_target);
assignmentCentersX = round(x_target);
assignmentCentersY = round(y_target);

%shifting sample centers
x_shift = assignmentCentersX - x_target;
y_shift = assignmentCentersY - y_target;
sampleCentersX = sampleCentersX + x_shift ;
sampleCentersY = sampleCentersY + y_shift ;

%transforming centers to patches
[kx,ky] = meshgrid(-2:2,-2:2);
kx = permute(kx,[4 5 3 4 1 2]);
ky = permute(ky,[4 5 3 4 1 2]);
assignmentPositionsX = bsxfun(@plus,assignmentCentersX,kx);
assignmentPositionsY = bsxfun(@plus,assignmentCentersY,ky);
samplingPositionsX = bsxfun(@plus,sampleCentersX,kx);
samplingPositionsY = bsxfun(@plus,sampleCentersY,ky);
