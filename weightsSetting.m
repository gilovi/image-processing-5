function [weights] = weightsSetting( imPatches, Dists, pyr ,dbPatchesStd )
% WEIGHTSSETTING Given 3 nearest neighbors for each patch of the input image
% Find a threshold (maximum distance) for each input patch.
% Next, give a weight for each candidate based on its distance from the input patch.
% denote m,n such that [m,n]=size(pyr{4})
% Arguments:
% imPatches ? (m ? 4) ª (n ? 4) ª 5 ª 5 matrix with the patches that were sampled
% from the input image (pyr{4})
% Dists ? ((m ? 4) ª (n ? 4)) ª 3 matrix with the distances returned from
% findNearestNeighbors.
% pyr ? 7 ª 1 cell created using createPyramid
% dbPatchesStd ? (m ? 4) ª (n ? 4) ª 3 matrix with the STDs of the neighbor
% patches returned from findNearestNeighbors.
%
% Outputs:
% weights ? (m ? 4) ª (n ? 4) ª 3 matrix with the weights for each DB candidates
%
    D = mat2gray(Dists);
    weights = exp(-(D.^2)./dbPatchesStd);%
    %weights(weights==0) = eps;
    
    weights(:,:,3) = weights(:,:,3) .* (Dists(:,:,3) < threshold( pyr{4},imPatches ));
    
    weights = mat2gray(weights)*10;
end


function [t] = threshold( im , patches)
    [dx,dy] = translateImageHalfPixel(im);
    
    %[x,y,patches] = samplePatches( im , 0 );
    [x,y,px] = samplePatches( dx , 0 );
    [~,~,py] = samplePatches( dy , 0 );
    
    % change shape to 25 X (num of patches)
    patches = reshape(permute(reshape(patches, numel(x),5,5),[2,3,1]),25,numel(x));
    px = reshape(permute(reshape(px, numel(x),5,5),[2,3,1]),25,numel(x));
    py = reshape(permute(reshape(py, numel(y),5,5),[2,3,1]),25,numel(y));
    
    t = reshape((sqrt(sum((patches - px).^2)) + sqrt(sum((patches - py).^2)))'/2,size(x));
end