clear;
clc;
clf;

%親のパス
parentfolderPath = uigetdir();
cd(parentfolderPath);

folderList = dir(parentfolderPath);
folderList = folderList([folderList.isdir]);
folderList = folderList(~ismember({folderList.name},{'.', '..', '.DS_Store'}));
num_folders = numel(folderList);

currentfolderIndex = 1;
currentfolderpath = fullfile(parentfolderPath, folderList(currentfolderIndex).name);
cd(currentfolderpath);

ls;

%----------------------------------------------------------
%以下はDicom情報が必要なとき
%filelist = dir(fullfile(currentfolderpath, '*.dcm'));
%numfiles = numel(filelist);

%dicominfocellarray = cell(numfiles, 1);

%cellにDICOM情報を埋めていく
%for i = 1:numfiles
    %dicomfilepath = fullfile(filelist(i).name);
    %dicomInfo = dicominfo(dicomfilepath,"UseDictionaryVR",true);

    %dicominfocellarray{i} = dicomInfo;
%end
%----------------------------------------------------------

%画像の読み込み
img4D = dicomreadVolume(currentfolderpath);
img3D = squeeze(img4D);
img3D = flip(img3D, 3);

num_imges = size(img3D, 3);

%初期画像表示
currentimg = 1;
hfig = figure(1);
himg = imagesc(img3D(:,:,currentimg));
colormap("gray");
axis image;
caxis([0, 500]);
colorbar;
title([folderList(currentfolderIndex).name, ' Image ', num2str(currentimg)]);

while ishandle(hfig)
    waitforbuttonpress;
    key = get(hfig, 'CurrentKey');

    switch key
        case 'uparrow' 
            currentimg = min(currentimg + 1, num_imges);

        case 'downarrow' 
            currentimg = max(currentimg - 1, 1);

        case 'rightarrow'
            currentfolderIndex = min(currentfolderIndex + 1, num_folders);
            currentfolderpath = fullfile(parentfolderPath, folderList(currentfolderIndex).name);
            img4D = dicomreadVolume(currentfolderpath);
            img3D = squeeze(img4D);

            num_imges = size(img3D, 3);

        case 'leftarrow'
            currentfolderIndex = max(currentfolderIndex - 1, 1);
            currentfolderpath = fullfile(parentfolderPath, folderList(currentfolderIndex).name);
            img4D = dicomreadVolume(currentfolderpath);
            img3D = squeeze(img4D);

            num_imges = size(img3D, 3);

        case 'q'
            close(hfig);
            break;    

        otherwise
            continue;
    end

     % 画像を更新して表示
    set(himg, 'CData', img3D(:,:,currentimg));
    title([folderList(currentfolderIndex).name, ' Image ', num2str(currentimg)]);
end