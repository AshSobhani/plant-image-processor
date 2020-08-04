%Load images into the script
img001 = imread('plant001_rgb.png');
img017 = imread('plant017_rgb.png');
%Resize image for consistency
img223 = imread('plant223_rgb.png');
img223 = imresize(img223, 0.25);

%Choose an image (img001, img017, img223)
chosenImg = img001;

%Enhance color with a decorrelation sketch*
decorrImg = decorrstretch(chosenImg);

%Extract the 3 colour spaces
red = decorrImg(:,:,1);
green = decorrImg(:,:,2);
blue = decorrImg(:,:,3);

%Manipulate image to keep more of the green
greenness = ((green*1.7)-((red+blue)/2)*1.2);

%Global image threshold using Otsu's method - Plant based threshold
level = graythresh(greenness);
%Binerize the image using the threshold - Turn into binary
binarizedImg = imbinarize(greenness, level);

%Seperate the object from the image - Isolates the plant
objectOnly = bwareafilt(binarizedImg, 1);

%Erode the image down - Thins stems and corrects thickness
se = strel('line', 2.58, 50);
erodedImg = imerode(objectOnly, se);

%Show the image
%imshow(keepObject);

%Show all images in a montage
montage({chosenImg, decorrImg, greenness, binarizedImg, objectOnly, erodedImg});

%--------------------------------------------------------------------------
%Techniques that were tested but unused in the final method***

%Increase contrast* - Worked well but decorrelation was more effective
%contrastImg = imadjust(greenness);

%Reduce noise from the image - Not too effective in the method
%guasImg = imnoise(binarizedImg,'gaussian',0,0.01);
%nReduction = wiener2(guasImg,[4 4]);

%Fill holes - Worked for the 3rd image very well but ruined images 1 and 2
%filled = imfill(keepObject, 'holes');

%Smoothen Image - Effective if value was raised but effected the thin stems
%se = strel('line', 2, 50);
%smoothImg = imopen(erodedImg,se);

%Open image - Ruined image one by breaking stems
%se = strel('disk', 2);
%openedImg = imopen(erodedImg, se);


