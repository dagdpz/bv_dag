function [high_motion, FD_Power] = ne_FD_outlier_detection(MoCoSDM, FD_CUTOFF, radius)

    % detect motion outliers based on Framewise displacement (FD)
    % LIT: Power, Neuroimage,  2012 
    % 
    % Input fields:
    %   MoCoSDM: Brainvoyager SDM from motion correction (use raw data, i.e. first dicom series)
    %   FD_CUTOFF: FD higher than FD_CUTTOFF is considered to be an outlier
    %   radius: rotational motion [degree] is converted to mm on a sphere with r = radius, see below 
    %
    % Output fields:
    %   high_motion: vector containing all datapoints with FD > FD_CUTTOFF
    %   FD_Power: vector with framewise displacement values
    
    
    % usage
    % [highmotion, FD_Power] = ne_FD_outlier_detection('9013_S3_R1_NoScannerMoCo_SCSA_3DMC.sdm',0.5,50)
    % 
    
    if nargin < 2
        FD_CUTOFF = 0.5;
    end
    
    if nargin < 3
        radius = 50; % default for humans
    end
    
    
    % load sdm
    sdm = xff(MoCoSDM);
    % get motion parameters
    motion = sdm.SDMMatrix;
    % get framewise change
    d_motion = [0 0 0 0 0 0 ; diff(motion)];
    % absolute framewise change
    abs_d_motion = abs(d_motion);
    
    % Framewise displacement (Power, Neuroimage, 2012, p. 2144)
    % Differentiating head realignment parameters across frames yields
    % a six dimensional timeseries that represents instantaneous head motion.
    % To express instantaneous head motion as a scalar quantity we
    % used the empirical formula, FD = |dtx|+|dty|+|dtz|+|drx|+|dry|+|drz|
    % all roational displacements were converted from degrees to 
    % millimeters by calculating displacement
    % on the surface of a sphere of radius 50 mm, which is approximately
    % the mean distance from the cerebral cortex to the center of the head.
    
    % May need to be changed for monkeys (if rotational movements are a
    % problem at all!)
    % circumference(full circle) = 2* pi * radius
    % circumference(partial circle) = angle[degree]/360 * 2 * pi * radius
    %                               = angle[degree]/180 * pi * radius
    FD_Power =  sum(abs_d_motion(:,1:3),2) + (radius*pi/180)*(sum(abs_d_motion(:,4:6),2));
    high_motion = find(FD_Power>FD_CUTOFF);
    sdm.ClearObject();

    
end