% this skript gets the name of a folder 
% e.g. 'C:\Users\Franzi\Downloads\AnalysisOfDanceFollowing\trajectories\Folgeläufe am Roboter\capture (2011-09-10 at 14-04-09)_NG71follows_part1_'
% this folder contains all information about the trajectory 
% robot: bool -- want to track the robot (TRUE) or the follower (FALSE)
% write: bool -- want to write the result to the folder
function rectTrack = rectifyTrack(trackFolder, robot, write)

    % load H homography
    hPath = strcat(trackFolder, '\video\H.mat');
    H = importdata(hPath);

    % get the track
    % get the rectified track for the given trackFolder
    if robot
        trackPath = strcat(trackFolder, '\trajectories\robot.raw'); 
    else
        trackPath = strcat(trackFolder, '\trajectories\followers.raw');
    end
    T = loadTrack(trackPath);

    % functionality to rectify trajectory
    idx = T(:,1);
    % make homogeneous coordinates
    P   = [T(:,2:3) repmat(1,length(idx), 1)];
    % get the orientation vector
    V   = [cos(T(:,6)) sin(T(:,6))];
    % each position plus the vector (homogeneous)
    Q   = P + [V repmat(0,length(idx), 1)];
    % apply homography
    HP  = H*P';
    % back to cartesian coordinates
    HP  = HP(1:2,:) ./ [HP(3,:); HP(3,:)];
    % same with the orienation vectors added to the positions
    HQ  = H*Q';
    HQ  = HQ(1:2,:) ./ [HQ(3,:); HQ(3,:)];
    % rectified orientation vectors
    V2  = HQ - HP;
    % eigenvectors of H for scaling the box dimensions
    e = eig(H);
    % make the old format and store to Trect
    rectTrack = [idx HP' T(:,4:5).*max(e)/2 atan2(V2(2,:), V2(1,:))'];

    if write
        if robot
            writePath = strcat(trackFolder, '\trajectories\robot.rect');
        else
            writePath = strcat(trackFolder, '\trajectories\followers.rect');
        end
        fileID = fopen(writePath,'w');
        fprintf(fileID,'%d %5f %5f %5f %5f %5f\r\n',rectTrack.');
        fclose(fileID);
    end
end