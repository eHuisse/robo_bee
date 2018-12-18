% function to perform the rectification and spline interpolation on all
% tracks in the folder (the dancer(s) and each follower)
% provide path to robodance data
naturalDancePath = 'C:\Users\Franzi\Downloads\Arbeitsergebnisse\tmp\natural_dances\';

% get all subfolders -- code from: https://stackoverflow.com/questions/8748976/list-the-subfolders-in-a-folder-matlab-only-subfolders-not-files
d = dir(naturalDancePath);
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds(ismember(nameFolds,{'.','..','_'})) = [];

for n = 1 : length(nameFolds)

    currentFolder = strcat(roboDancePath, nameFolds{n});
    currentTrackFolder = strcat(currentFolder, '\trajectories\');
    
    % find the raw data to be rectified and spline interpolated
    fileList = dir(fullfile(currentTrackFolder, '*.raw'));
    fileListNames = {fileList(:).name}';
    
    for file = 1 : length(fileListNames)
        currentFile = strcat(currentTrackFolder, fileListNames{file});
        [pathstr,name,ext] = fileparts(currentFile);
        
        % rectify the track
        rescaleNaturalDance(currentFolder, name); 
        
        % spline interpolate the track
        splineInterpolateTrack(currentFolder, name); 
        
    end 
end