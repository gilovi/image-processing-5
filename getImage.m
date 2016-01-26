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
[a, b,~,~,~] = size(assignmentPositionsX);

weights = repmat(weights,[1 1 1 5 5]);

%resaping the matrices so we sample every 5th patch
assignmentPositionsX = permute(assignmentPositionsX,[1 4 2 5 3]);
assignmentPositionsX=reshape(assignmentPositionsX,size(assignmentPositionsX,1)*5,...
    size(assignmentPositionsX,3)*5,3);
assignmentPositionsY = permute(assignmentPositionsY,[1 4 2 5 3]);
assignmentPositionsY=reshape(assignmentPositionsY,size(assignmentPositionsY,1)*5,...
    size(assignmentPositionsY,3)*5,3);
samplingPositionsX = permute(samplingPositionsX,[1 4 2 5 3]);
samplingPositionsX=reshape(samplingPositionsX,size(samplingPositionsX,1)*5,...
    size(samplingPositionsX,3)*5,3);
samplingPositionsY = permute(samplingPositionsY,[1 4 2 5 3]);
samplingPositionsY = reshape(samplingPositionsY,size(samplingPositionsY,1)*5,...
    size(samplingPositionsY,3)*5,3);
weights = permute(weights*100,[1 4 2 5 3]);
weights = reshape(weights,size(weights,1)*5,size(weights,3)*5,3);

% adding shifts to the assignment so we get sampled images in large image (sized 5*out_r x 5*out_c x 3) 
x_shifts = (repmat(0:out_c: 4*out_c, b,1));
assignmentPositionsX = bsxfun(@plus, assignmentPositionsX , x_shifts(:)');
y_shifts = (repmat(0:out_r: 4*out_r, a,1));
assignmentPositionsY = bsxfun(@plus, assignmentPositionsY , y_shifts(:));

samp_im = interp2(renderedPyramid, samplingPositionsX, samplingPositionsY );

% rendering 75 images 
ind = repmat(permute(1:3,[1,3,2]),size(assignmentPositionsY,1),size(assignmentPositionsY,2));
im = zeros(5*out_r,5*out_c,3);
im(sub2ind([5*out_r, 5*out_c,3],assignmentPositionsY,assignmentPositionsX, ind)) = samp_im;
im = reshape(im,size(im,1)/5,5,size(im,2)/5,5,3);
im = permute(reshape(permute(im,[2,4,5,1,3]), 75,out_r,out_c),[2 3 1]);

%rendering 75 weights
w = ones(5*out_r,5*out_c,3);
w(sub2ind([5*out_r, 5*out_c,3],assignmentPositionsY,assignmentPositionsX, ind)) = weights;
w = reshape(w,size(w,1)/5,5,size(w,2)/5,5,3);
w = permute(reshape(permute(w,[2,4,5,1,3]), 75,out_r,out_c),[2 3 1]);

image = sum(im.*w,3)./sum(w,3);
image (isnan(image)) = 0;
%image= sum(im,3)/75;

%figure;imshow(uint8(image))
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


