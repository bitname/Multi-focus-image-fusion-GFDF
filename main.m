clear
close all

%------read images---------
%[imagename1, imagepath1]=uigetfile('./images/*.jpg;*.bmp;*.png;*.tif;*.tiff;*.pgm;*.gif','Please choose the first input image');
%A=imread(strcat(imagepath1,imagename1));    
%[imagename2, imagepath2]=uigetfile('./images/*.jpg;*.bmp;*.png;*.tif;*.tiff;*.pgm;*.gif','Please choose the second input image');
%B=imread(strcat(imagepath2,imagename2));  



A = imread('lytro-03-A.jpg');
B = imread('lytro-03-B.jpg');

A = double(A)/255;
B = double(B)/255;

if size(A)~=size(B)
    error('two images are not the same size.');
end

if size(A,3)>1
    A_gray=rgb2gray(A);
    B_gray=rgb2gray(B);
else
    A_gray=A;
    B_gray=B;
end
%figure; imshow(A,[]);
%figure; imshow(B,[]);

%figure; imshow(A_gray,[]);
%figure; imshow(B_gray,[]);


[high, with] = size(A_gray);
tic;
% Parameters for Guided Filter 
r =5; eps = 0.3;
w =7;

h = fspecial('average', [w w]);
averA = imfilter(A_gray,h,'replicate');
averB = imfilter(B_gray,h,'replicate');
%figure; imshow(averA,[]);
%figure; imshow(averB,[]);


smA = abs(A_gray - averA);
smB = abs(B_gray - averB);
figure; imshow(smA,[]);
figure; imshow(smB,[]);


gsmA = guidedfilter_LKH(A_gray,smA, r, eps);
gsmB = guidedfilter_LKH(B_gray,smB, r, eps);
figure; imshow(gsmA,[]);
figure; imshow(gsmB,[]);


wmap = double(gsmA > gsmB);
figure; imshow(wmap,[]);

ratio=0.01;
area=ceil(ratio*high*with);
tempMap1=bwareaopen(wmap,area);
tempMap2=1-tempMap1;
tempMap3=bwareaopen(tempMap2,area);
wmap=1-tempMap3;

mmap = wmap.*A_gray + (1-wmap).*B_gray;
figure; imshow(wmap,[]);
%figure; imshow(mmap,[]);

gmap = guidedfilter_LKH(mmap,wmap, r, eps);
figure; imshow(gmap,[]);

% fuse image
if size(A,3)>1
    wmap=repmat(wmap,[1 1 3]);
    gmap=repmat(gmap,[1 1 3]);
end
IF = A.*wmap + B.*(1-wmap);% Initial fused image
figure; imshow(IF,[]);
F_GF2 = A.*gmap + B.*(1-gmap);
F_GF2 = uint8(F_GF2*255);
t1=toc;

A = uint8(A*255);
B = uint8(B*255);


figure; imshow(F_GF2);

if size(A,3)>1
    F_GF2=rgb2gray(F_GF2);
end
A_gray = uint8(A_gray*255);
B_gray = uint8(B_gray*255);
Eval(1,:)=EvalFusion(A_gray,B_gray,F_GF2);
