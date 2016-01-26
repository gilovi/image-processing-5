butt = rgb2ntsc(imread('butterfly.png'));
big_butt = imresize(butt,2);
big_butt(:,:,1) = imtranslate(superResolution(butt(:,:,1)),[-3 -2]);

big_butt = ntsc2rgb(big_butt);
butt = ntsc2rgb(butt);

figure;imshow(butt);title('Original');
figure;imshow(big_butt);title('Super Resolution');
figure;imshow(imresize(butt,2)); title('Resized');
%%

monument = rgb2ntsc(imread('monument.jpg'));
big_monument = imresize(monument,2);
big_monument(:,:,1) = superResolution(monument(:,:,1));

big_monument = ntsc2rgb(big_monument);
monument = ntsc2rgb(monument);

figure;imshow(monument);title('Original');
figure;imshow(big_monument);title('Super Resolution');
figure;imshow(imresize(monument,2)); title('Resized');
%%

minion = rgb2ntsc(imread('small_minion.jpg'));
big_minion = imresize(minion,2);
S = superResolution(minion(:,:,1));
big_minion(:,:,1) = imresize(S,numel(big_minion(:,:,1))/numel(S));

big_minion = ntsc2rgb(big_minion);
minion = ntsc2rgb(minion);

figure;imshow(minion);title('Original');
figure;imshow(big_minion);title('Super Resolution');
figure;imshow(imresize(minion,2)); title('Resized');
