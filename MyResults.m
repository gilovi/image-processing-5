butt = rgb2ntsc(imread('butterfly.png'));
big_butt = imresize(butt,2);
big_butt(:,:,1) = superResolution(butt(:,:,1));

big_butt = ntsc2rgb(big_butt);