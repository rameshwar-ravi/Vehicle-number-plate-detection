clc;
clear;
close all;
%input = imread('first.jpg');
input = imread('second.jpg');
%input = imread('third.jpeg');
 %input = imread('new2.jpg');
%input = imread('fifth.jpg');
%input = imread('new1.jpg');


imshow(input,[]);

ingray=rgb2gray(input);
input=ingray;
ingray=medfilt2(ingray,[3 3]);
%imshow(ingray);


ingray=edge(ingray,'sobel');
%figure;imshow(ingray);
ingray = bwareaopen(ingray, 200);
param = strel('disk',1);
ingray = imdilate(ingray,param);

%figure;imshow(ingray);
ingray=imfill(ingray,'holes');
%figure;imshow(ingray);
newparam=strel('disk',5);
ingray=imerode(ingray,newparam);
%figure;imshow(ingray);
numberplate=uint8(ingray).*input;
%figure;imshow(numberplate);
ysum=sum(numberplate,1);
xsum=sum(numberplate,2);
[iterator1,~]=size(xsum);
[~,iterator2]=size(ysum);
firsty=0;lasty=0;
firstx=0;lastx=0;
firsty1=find(ysum,1,'first');
lasty1=find(ysum,1,'last');
for i=1:1:iterator1
    if(firsty==0 && xsum(i)>0)
        firsty=i;
    end
    if(firsty~=0 && xsum(i)>0)
        lasty=i;
    end
end
for i=1:1:iterator2
    if(firstx==0 && ysum(i)>0)
        firstx=i;
    end
    if(firstx~=0 && ysum(i)>0)
        lastx=i;
    end
end
firsty=(max(firsty-1,1));
lasty=(min(lasty+1,iterator1));
firstx=(max(firstx-1,1));
lastx=(min(lastx+1,iterator2));
finalplate=numberplate(firsty:lasty+1,firstx:lastx);
figure; imshow(finalplate);
binary = ~imbinarize(finalplate);
figure;
imshow(binary);

indexToAlphabet={'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};
for i=1:36
    if(i<27)
        alphabets{i}=~imread([indexToAlphabet{i},'.bmp']);
    else
        digits{i-26}=~imread([num2str(i-27),'.bmp']);
    end
end

% alphabets{1} store A
% digits{1} stores zero and so on

imgSegment = regionprops(binary,'BoundingBox','Image');
detected_num='';
imgSegmentSize=size(imgSegment);
ch_loc=1;
for i = 1 : imgSegmentSize
    segment_boundingBox = imgSegment(i).BoundingBox;
    img_width=segment_boundingBox(3);
    img_height=segment_boundingBox(4);
    if((img_width>=16 && img_width<=85) && (img_height>=32 && img_height<=163))
        % segment_boundingBox = [left, top, width, height] 
    rectangle('position',segment_boundingBox,'Linewidth',1,'EdgeColor','y','Linestyle','--');
        % used to highlight segmented box
    segment_imgTest=imresize(imgSegment(i).Image,[40,20]);
        % because we have to compare it with compare image which have
        % dimensions 40*20
    
    min_Difference=801; 
   % as imgTest is a binary image of 40*20, so its maximum sum is 800
    if ~(ch_loc==1 || ch_loc==2 || ch_loc==5 || ch_loc==6)
        
        diff_seg_test = abs(segment_imgTest-digits{1});
        if(min_Difference-sum(diff_seg_test(:))>0)
            fin_char='0';
            min_Difference= sum(diff_seg_test(:));            
        end
        
        diff_seg_test = abs(segment_imgTest-digits{2});
        if(min_Difference-sum(diff_seg_test(:))>0)
            fin_char='1';
            min_Difference= sum(diff_seg_test(:));            
        end
        
        diff_seg_test = abs(segment_imgTest-digits{3});
        if(min_Difference-sum(diff_seg_test(:))>0)
            fin_char='2';
            min_Difference= sum(diff_seg_test(:));       
        end
        
        diff_seg_test = abs(segment_imgTest-digits{4});
        if(min_Difference-sum(diff_seg_test(:))>0)
            fin_char='3';
            min_Difference= sum(diff_seg_test(:));    
        end
        
        diff_seg_test = abs(segment_imgTest-digits{5});
        if(min_Difference-sum(diff_seg_test(:))>0)
            fin_char='4';
            min_Difference= sum(diff_seg_test(:));            
        end
        
        diff_seg_test = abs(segment_imgTest-digits{6});
        if(min_Difference-sum(diff_seg_test(:))>0)
            fin_char='5';
            min_Difference= sum(diff_seg_test(:));            
        end
        
        diff_seg_test = abs(segment_imgTest-digits{7});
        if(min_Difference-sum(diff_seg_test(:))>0)
            min_Difference= sum(diff_seg_test(:));
            fin_char='6';
        end
        
        diff_seg_test = abs(segment_imgTest-digits{8});
        if(min_Difference-sum(diff_seg_test(:))>0)
            fin_char='7';
            min_Difference= sum(diff_seg_test(:));     
        end
        
        diff_seg_test = abs(segment_imgTest-digits{9});
        if(min_Difference-sum(diff_seg_test(:))>0)
            fin_char='8';
            min_Difference= sum(diff_seg_test(:)); 
        end
        
        diff_seg_test = abs(segment_imgTest-digits{10});
        if(min_Difference-sum(diff_seg_test(:))>0)
            fin_char='9';
            min_Difference= sum(diff_seg_test(:));  
        end 
        
    else
        diff_seg_test = abs(segment_imgTest-alphabets{1});
        if(min_Difference-sum(diff_seg_test(:))>0)
            fin_char='A';
            min_Difference = sum(diff_seg_test(:));   
        end
        
        diff_seg_test = abs(segment_imgTest-alphabets{2});
        if(min_Difference-sum(diff_seg_test(:))>0)
            fin_char='B';
            min_Difference= sum(diff_seg_test(:));  
        end
        
       diff_seg_test = abs(segment_imgTest-alphabets{3});
        if(min_Difference-sum(diff_seg_test(:))>0)
            fin_char='C';
            min_Difference= sum(diff_seg_test(:));     
        end
        
        diff_seg_test = abs(segment_imgTest-alphabets{4});
        if(min_Difference-sum(diff_seg_test(:))>0)
            fin_char='D';
            min_Difference= sum(diff_seg_test(:));   
        end
        
        diff_seg_test = abs(segment_imgTest-alphabets{5});
        if(min_Difference-sum(diff_seg_test(:))>0)
            fin_char='E';
            min_Difference= sum(diff_seg_test(:));
        end
        
        diff_seg_test = abs(segment_imgTest-alphabets{6});
        if(min_Difference-sum(diff_seg_test(:))>0)
            fin_char='F';
            min_Difference= sum(diff_seg_test(:));
        end
        
        diff_seg_test = abs(segment_imgTest-alphabets{7});
        if(min_Difference-sum(diff_seg_test(:))>0)
            fin_char='G';
            min_Difference= sum(diff_seg_test(:));
        end
        
        diff_seg_test = abs(segment_imgTest-alphabets{8});
        if(min_Difference-sum(diff_seg_test(:))>0)
            fin_char='H';
            min_Difference= sum(diff_seg_test(:));  
        end
        
        diff_seg_test = abs(segment_imgTest-alphabets{9});
        if(min_Difference-sum(diff_seg_test(:))>0)
            fin_char='I';
            min_Difference= sum(diff_seg_test(:));    
        end
        
        diff_seg_test = abs(segment_imgTest-alphabets{10});
        if(min_Difference-sum(diff_seg_test(:))>0)
            fin_char='J';
            min_Difference= sum(diff_seg_test(:));    
        end
        
        diff_seg_test = abs(segment_imgTest-alphabets{11});
        if(min_Difference-sum(diff_seg_test(:))>0)
            fin_char='K';
            min_Difference= sum(diff_seg_test(:));
        end
        
        diff_seg_test = abs(segment_imgTest-alphabets{12});
        if(min_Difference-sum(diff_seg_test(:))>0)
            fin_char='L';
            min_Difference= sum(diff_seg_test(:));  
        end
        
        diff_seg_test = abs(segment_imgTest-alphabets{13});
        if(min_Difference-sum(diff_seg_test(:))>0)
            fin_char='M';
            min_Difference= sum(diff_seg_test(:));
        end
        
        diff_seg_test = abs(segment_imgTest-alphabets{14});
        if(min_Difference-sum(diff_seg_test(:))>0)
            fin_char='N';
            min_Difference= sum(diff_seg_test(:));  
        end
        
        diff_seg_test = abs(segment_imgTest-alphabets{15});
        if(min_Difference-sum(diff_seg_test(:))>0)
            fin_char='O';
            min_Difference= sum(diff_seg_test(:)); 
        end
        
        diff_seg_test = abs(segment_imgTest-alphabets{16});
        if(min_Difference-sum(diff_seg_test(:))>0)
            fin_char='P';
            min_Difference= sum(diff_seg_test(:));  
        end
        
        diff_seg_test = abs(segment_imgTest-alphabets{17});
        if(min_Difference-sum(diff_seg_test(:))>0)
            fin_char='Q';
            min_Difference= sum(diff_seg_test(:));  
        end
        
        diff_seg_test = abs(segment_imgTest-alphabets{18});
        if(min_Difference-sum(diff_seg_test(:))>0)
            h='R';
            min_Difference= sum(diff_seg_test(:));
        end
        
        diff_seg_test = abs(segment_imgTest-alphabets{19});
        if(min_Difference-sum(diff_seg_test(:))>0)
            fin_char='S';
            min_Difference= sum(diff_seg_test(:));  
        end
        
        diff_seg_test = abs(segment_imgTest-alphabets{20});
        if(min_Difference-sum(diff_seg_test(:))>0)
            fin_char='T';
            min_Difference= sum(diff_seg_test(:));   
        end
        
        diff_seg_test = abs(segment_imgTest-alphabets{21});
        if(min_Difference-sum(diff_seg_test(:))>0)
            fin_char='U';
            min_Difference= sum(diff_seg_test(:));   
        end
        
        diff_seg_test = abs(segment_imgTest-alphabets{22});
        if(min_Difference-sum(diff_seg_test(:))>0)
            fin_char='V';
            min_Difference= sum(diff_seg_test(:)); 
        end
        
        diff_seg_test = abs(segment_imgTest-alphabets{23});
        if(min_Difference-sum(diff_seg_test(:))>0)
            fin_char='W';
            min_Difference= sum(diff_seg_test(:));
        end
        
        diff_seg_test = abs(segment_imgTest-alphabets{24});
        if(min_Difference-sum(diff_seg_test(:))>0)
            fin_char='X';
            min_Difference= sum(diff_seg_test(:));
        end
        
        diff_seg_test = abs(segment_imgTest-alphabets{25});
        if(min_Difference-sum(diff_seg_test(:))>0)
            fin_char='Y';
            min_Difference= sum(diff_seg_test(:));  
        end
        
        diff_seg_test = abs(segment_imgTest-alphabets{26});
        if(min_Difference-sum(diff_seg_test(:))>0)
            fin_char='Z';
            min_Difference= sum(diff_seg_test(:)); 
        end  
        
    end
    ch_loc=ch_loc+1;
    detected_num=strcat(detected_num,fin_char);
     
   end
end

finOut=strcat('Detected Vehicle Number is :  " ',detected_num,'"');
disp(finOut)