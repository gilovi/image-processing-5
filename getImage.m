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
[out_r,out_c] = size(emptyHighResImage);
[a, b, c, d, e] = size(assignmentPositionsX);


ass_X = permute(assignmentPositionsX,[1 4 2 5 3]);
ass_X=reshape(ass_X,size(ass_X,1)*5,size(ass_X,3)*5,3);
ass_Y = permute(assignmentPositionsY,[1 4 2 5 3]);
ass_Y=reshape(ass_Y,size(ass_Y,1)*5,size(ass_Y,3)*5,3);
samp_X = permute(samplingPositionsX,[1 4 2 5 3]);
samp_X=reshape(samp_X,size(samp_X,1)*5,size(samp_X,3)*5,3);
samp_Y = permute(samplingPositionsY,[1 4 2 5 3]);
samp_Y = reshape(samp_Y,size(samp_Y,1)*5,size(samp_Y,3)*5,3);

x_shifts = (repmat(0:out_c: 4*out_c, b,1));
ass_X = bsxfun(@plus, ass_X , x_shifts(:)');
y_shifts = (repmat(0:out_r: 4*out_r, a,1));
ass_Y = bsxfun(@plus, ass_Y , y_shifts(:));

samp_im = interp2(renderedPyramid, samp_X, samp_Y );

%for loop 1:3!!
im = zeros(5*out_r,5*out_c);
im(sub2ind([5*out_r, 5*out_c],ass_Y,ass_X)) = samp_im;
m = cell2mat(reshape(mat2cell(im,ones(1,5)*out_r,ones(1,5)*out_c) ,1,1,25));

image= sum(m,3)/25;

%figure;imshow(uint8(im))
%I = repmat(emptyHighResImage,[1,1,75]);


% % [yp,xp,~] = ind2sub([5,5,3], 1:75);
% % fw = repmat(weights, [1,1,1,5,5]);
% % %fw(:) = 1;
% % w = zeros (size(emptyHighResImage));
% % 
% % 
% % 
% % for i = 1:25*3
% %   
% %         im = interp2(renderedPyramid,...
% %             samplingPositionsX( xp(i):3:end, yp(i):3:end, :, :, :),...
% %             samplingPositionsY( xp(i):3:end, yp(i):3:end, :, :, :), 'cubic');
% %         im(isnan(im)) = 0;
% %         ind = sub2ind(size(emptyHighResImage)...
% %             ,assignmentPositionsY( xp(i):3:end, yp(i):3:end, :, :, :), ...
% %             assignmentPositionsX( xp(i):3:end, yp(i):3:end, :, :, :) );
% %         wt = fw(xp(i):3:end, yp(i):3:end, :, :, :);
% %         emptyHighResImage(ind) = emptyHighResImage(ind) + (wt .* im) ;
% %         %figure;imshow(uint8(mat2gray(emptyHighResImage)*255))
% %         w(ind) = w(ind) + wt ;
% %                
% % end
% % image = emptyHighResImage./w;
% % i


