% % % % JPEG  from 10 to 100, step:10 
% % % % Amplitude Scaling form 0.5 to 1.5, step: 0.1 except factor 1
% % % % resize form 0.5 to 1.5, step: 0.1 except factor 1
% % % % Rotate: with and without crop, affine transformation
% % % % Add noise: Gaussian, Peppers & Salt
% % % % Filter: median, mean, Gaussian lowpass, highpass
% % % % Contrast 
% % % % Local attack:  Crop:
function om=attacks(im)
% %% JPEG 50, 40, 30
% imwrite(im,'temp.jpg','Quality',40);
% om=imread('temp.jpg');

% % %%%%%%%%%%%%%%%%%  Amplitude Scaling: 0.75, 1.25, 1.5
% om=1.5*im;

% % %%%%%%%%%%%%%%%%%  imresize/Scaling: 0.5, 1.5, 2.0
% om=imresize(imresize(im,1.5, 'bicubic'), 1/1.5, 'bicubic');
% % outname = strrep(infilename, '.bmp', '_resize05.bmp');
% % imwrite(imresize(I,0.5),outname);

% % % % %%%%%%%%%%%%%%%%%%  Rotate
% om=imrotate(im, 0.5, 'crop');

% Gaussian noise: 10, 20, 30 ~[0, 255]
% om=imnoise(im,'gaussian',0,0.01);
% n=30*randn(size(im))+0;
% om=im+uint8(n);

% salt & pepper noise, 0.01, 0.02, 0.03
om=imnoise(im,'salt & pepper', 0.03);

%%%%%%%%%%%%%%%%% % Filter: median, mean, lowpass
% h=fspecial('average',2);
% om=imfilter(double(im),h,'same');
% om=medfilt2(im,[3 3]);

%%%%lowpass hsize=[3 3]; [5  5]; [7 7]
% hsize=[3 3];   with standard deviation SIGMA (positive)
% h=fspecial('gaussian',hsize);  %  The default HSIZE is [3 3], the default SIGMA is 0.5.
% om=uint8(imfilter(double(im),h,'same'));
% outname = strrep(infilename, '.bmp', '_gaulow2.bmp');
% imwrite(uint8(I1),outname);

%%%%median filter:  hsize=[3 3]; [5  5]; [7 7]
% hsize=[3 3];
% om=uint8(medfilt2(double(im),hsize));
% outname = strrep(infilename, '.bmp', '_gaulow2.bmp');
% imwrite(uint8(I1),outname);

% % %%%%%%%%%%%%%%%%%  Contrast
% om=uint8(im-50);
% % outname = strrep(infilename, '.bmp', '_brighten01.bmp');
% % imwrite(uint8(I+26),outname);
% % 
% % outname = strrep(infilename, '.bmp', '_darken01.bmp');
% % imwrite(uint8(I-26),outname);
% % 
% % outname = strrep(infilename, '.bmp', '_histeq.bmp');
% % imwrite(histeq(I),outname);
% % 
% % outname = strrep(infilename, '.bmp', '_contrast.bmp');
% om= imadjust(im,[], [], 1.5);
% % imwrite(J,outname);
% 
% % % % % % %%%%%%%%%%%%%%%%%
% % % % % T = maketform('affine',[1 0 0; 0 1 0; 0 0 1]);
% % % % % I2 = imtransform(I,T);
% % % % % imshow(I2)
% % % % % figure;
% % % % % imshow(I);
% % % % close all;

% % % % %%%%%%%%%%%%%%%%% Local attack Crop:
% % % % m=150,n=150,aa=1,bb=1;
% % % % for i=aa:1:m
% % % %     for j=bb:1:n
% % % %         I(i,j)=255;
% % % %     end
% % % % end
% % % % % imshow(I);
% % % % imwrite(I,'images\lenacut3.bmp');
% % % % close all;
% count=count+1;
% end
% % for i=1:1:94
% %     for j=1:1:94
% %         if me(i)==me(j)&&i~=j
% %             i,j
% %         end
% %     end
% %     
% % end
% close all

