
clc;
close all;

disp('Hi , This program helps you create or scan maze and solve it.');
fq=input('Solve(1) or Generate(2) ? ');
if fq==1
    if(~isdeployed)
	    cd(fileparts(which(mfilename)));
    end
	    
    % For convenience in browsing, set a starting folder from which to browse.
    startingFolder = 'desktop';

    continueWithAnother = true;
    promptMessage = sprintf('Please select your maze image (png / jpg / jpeg / common formats work better ...');
    button = questdlg(promptMessage, 'Maze Solver', 'OK', 'Cancel', 'OK');
    if strcmpi(button, 'Cancel')
	    continueWithAnother = false;
    end
    
    if continueWithAnother
	    % Get the name of the maze image file that the user wants to use.
	    defaultFileName = fullfile(startingFolder, '*.*');
	    [baseFileName, folder] = uigetfile(defaultFileName, 'Select maze image file');
	    if baseFileName == 0
		    % User hit cancel.  Bail out.
		    return;
	    end
	    fullFileName = fullfile(folder, baseFileName);
    end
    originalImage = imread(fullFileName);
    Maze =originalImage;
elseif fq==2
    S1=randi([2 8]);
    E1=randi([2 8]);
    map = mapMaze(5,2,'MapSize',[10 10],'MapResolution',10);
    show(map)
    hold on;
    S2=plot([S1 S1+1],[10 10],'w','LineWidth',20);
    E2=plot([E1 E1+1],[0 0],'w','LineWidth',20);
    axis off;
    title('');
    xlabel off;
    ylabel off;
    F = getframe(gcf);
    [X, Map] = frame2im(F);
    Maze=mat2gray(X);

end





	% Here are some hard coded file names for ease in developing and debugging,
	% so we don't have to use uigetfile() all the time.

	% Gotten from http://www.erclc.org/StaffPages/David/Mazes/Maze1.gif
	% This maze works fine.
	% fullFileName = fullfile(folder, 'Maze1.gif');

	% Gotten from http://www.mattneuman.com/maze.htm
	% This is a test maze that won't work because it is not a "non-perfect maze."
	% fullFileName = fullfile(folder, 'Maze of Sisyphus.gif');

	% Open the maze image file.
	




%% Read the image of maze
%Maze=imread("maze.jpg");
 % Read your image here.
%disp(size(Maze))
% figure,imshow(Maze);title('Original Maze image');
%% Convert to binary image
if size(Maze,3) ==3
    Maze = rgb2gray(Maze);
end

   
    Maze_Binary = imbinarize(Maze,graythresh(Maze)-0.1); % Make sure to have black walls and white path 
    % There should not be any broken walls, walls should be seperate rom boundary of images  
    disp(size(Maze_Binary))
    figure,imshow(Maze_Binary);title('Binary Maze');

    %% Start Solving 
    %Use Watershed transform to find catchment basins
    %Some other methods also can be used
    Maze_Watershed = watershed(Maze_Binary);
    C1 = (Maze_Watershed == 2);%Obtain First Part of Watershed
    Maze_watershed1 = C1.*Maze_Binary;
    figure,imshow(Maze_watershed1);title('One of the Part of catchment basins');
    C2 = watershed(Maze_watershed1);
    %Using watershed transform once again so the image obtained will be
    %shrinked along path of maze, imshow pir is used to observe this.
    figure,imshowpair(Maze_Watershed,C2);title('Shrinked Path')
    %So now we can easily Take difference of both images to get the path.
    P1 = Maze_Watershed == 2;
    P2 = C2 == 2;
    path = P1 - P2;
    Solved = imoverlay(Maze_Binary, path, [0.25 0.25 1]); 
    figure,imshow(Solved);title('Solved Maze') 
