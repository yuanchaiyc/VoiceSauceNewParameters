function mdata = func_buildMData(matfile, smoothwin)
% mdata = func_buildMData(matfile, smoothwin)
% Input:  mat filename
%         smoothing window size (0 denotes no smoothing)
% Output: mat data structure
% Notes:  Function tries to construct as many parameters as possible based
% on the parameters currently in the mat file. Some parameters will have a
% different variable name to what is originally stored in the mat file:
% e.g. H1 is actually the uncorrected harmonic (H1u), it is stored this way
% for compatability reasons.
%
% Author: Yen-Liang Shue, Speech Processing and Auditory Perception Laboratory, UCLA
% Copyright UCLA SPAPL 2009-2015

mdata = load(matfile);

% these are for compatibility with VS0 matfiles
if (~isfield(mdata, 'HF0algorithm'))
    mdata.HF0algorithm = 'F0 (Straight)';
end

if (~isfield(mdata, 'AFMTalgorithm'))
    mdata.AFMTalgorithm = 'Formants (Snack)';
end

if (~isfield(mdata, 'Fs'))
    mdata.Fs = 16000;
end

% make sure output to text has something to print if these fields don't
% exist
if (~isfield(mdata, 'H1KFMTalgorithm'))
    mdata.H1KFMTalgorithm = '';
end

if (~isfield(mdata, 'H2KFMTalgorithm'))
    mdata.H2KFMTalgorithm = '';
end

if (~isfield(mdata, 'H3KFMTalgorithm'))
    mdata.H3KFMTalgorithm = '';
end

if (~isfield(mdata, 'H4KFMTalgorithm'))
    mdata.H4KFMTalgorithm = '';
end

if (~isfield(mdata, 'BandwidthMethod'))
    mdata.BandwidthMethod = '';
end

if (~isfield(mdata, 'frameshift'))
    mdata.frameshift = 0;
end

if (~isfield(mdata, 'preemphasis'))
    mdata.preemphasis = 0;
end

if (~isfield(mdata, 'windowsize'))
    mdata.windowsize = 0;
end

% get the right F0
F0 = func_parseF0(mdata, mdata.HF0algorithm);
[F1, F2, F3, F4, F5] = func_parseFMT(mdata, mdata.AFMTalgorithm);

% can't do much without F0 or FMTs
if (isempty(F0) || isempty(F1))
    return;
end

% get bandwidth mapping using formula estimate
mdata.fB1 = func_getBWfromFMT(F1, F0, 'hm');
mdata.fB2 = func_getBWfromFMT(F2, F0, 'hm');
mdata.fB3 = func_getBWfromFMT(F3, F0, 'hm');
mdata.fB4 = func_getBWfromFMT(F4, F0, 'hm');
mdata.fB5 = func_getBWfromFMT(F5, F0, 'hm');
%B5 = func_getBWfromFMT(F5, F0, 'hm');

% Hx
if (isfield(mdata, 'H1'))
    mdata.H1u = mdata.H1;  % H1 is actually the uncorrected harmonic
    mdata.H1F1c = func_correct_iseli_z(F0, F1, mdata.fB1, mdata.Fs); % the corrected for F1 value for H1
    mdata.H1F2c = func_correct_iseli_z(F0, F2, mdata.fB2, mdata.Fs);
    mdata.H1F3c = func_correct_iseli_z(F0, F3, mdata.fB3, mdata.Fs);
   
    mdata.H1F1cpos = mdata.H1F1c;
    mdata.H1F2cpos = mdata.H1F2c;
    mdata.H1F3cpos = mdata.H1F3c;

    mdata.H1F1cpos(mdata.H1F1cpos < 0) = 0;
    mdata.H1F2cpos(mdata.H1F2cpos < 0) = 0;
    mdata.H1F3cpos(mdata.H1F3cpos < 0) = 0;

    mdata.H1c = mdata.H1u - mdata.H1F1cpos - mdata.H1F2cpos - mdata.H1F3cpos;
    if (smoothwin~=0)
        mdata.H1u = filter(ones(smoothwin,1)/smoothwin, 1, mdata.H1u);
        mdata.H1c = filter(ones(smoothwin,1)/smoothwin, 1, mdata.H1c);
    end    
    %mdata = rmfield(mdata, 'H1');  % remove H1 to remove confusion
end

if (isfield(mdata, 'H2'))
    mdata.H2u = mdata.H2;  % H2 is actually the uncorrected harmonic
    a = func_correct_iseli_z(2*F0, F1, mdata.fB1, mdata.Fs); % the corrected for F1 value for H1
    b = func_correct_iseli_z(2*F0, F2, mdata.fB2, mdata.Fs);
    c = func_correct_iseli_z(2*F0, F3, mdata.fB3, mdata.Fs);

    mdata.H2F1c = func_correct_iseli_z(2*F0, F1, mdata.fB1, mdata.Fs); % the corrected for F1 value for H1
    mdata.H2F2c = func_correct_iseli_z(2*F0, F2, mdata.fB2, mdata.Fs);
    mdata.H2F3c = func_correct_iseli_z(2*F0, F3, mdata.fB3, mdata.Fs);

    a(a<0) = 0;
    b(b<0) = 0;
    c(c<0) = 0;
    mdata.H2c = mdata.H2u - a - b - c;
    if (smoothwin~=0)
        mdata.H2u = filter(ones(smoothwin,1)/smoothwin, 1, mdata.H2u);
        mdata.H2c = filter(ones(smoothwin,1)/smoothwin, 1, mdata.H2c);
    end
    %mdata = rmfield(mdata, 'H2');
end

if (isfield(mdata, 'H3'))
    mdata.H3u = mdata.H3;  % H3 is actually the uncorrected harmonic
    mdata.H3F1c = func_correct_iseli_z(3*F0, F1, mdata.fB1, mdata.Fs); % the corrected for F1 value for H1
    mdata.H3F2c = func_correct_iseli_z(3*F0, F2, mdata.fB2, mdata.Fs);
    mdata.H3F3c = func_correct_iseli_z(3*F0, F3, mdata.fB3, mdata.Fs);
    mdata.H3F4c = func_correct_iseli_z(3*F0, F4, mdata.fB4, mdata.Fs);
    
    mdata.H3F1cpos = mdata.H3F1c;
    mdata.H3F2cpos = mdata.H3F2c;
    mdata.H3F3cpos = mdata.H3F3c;
    mdata.H3F4cpos = mdata.H3F4c;

    mdata.H3F1cpos(mdata.H3F1cpos < 0) = 0;
    mdata.H3F2cpos(mdata.H3F2cpos < 0) = 0;
    mdata.H3F3cpos(mdata.H3F3cpos < 0) = 0;
    mdata.H3F4cpos(mdata.H3F4cpos < 0) = 0;

    %assign negative numbers as zero

    mdata.H3c = mdata.H3u - mdata.H3F1cpos - mdata.H3F2cpos - mdata.H3F3cpos - mdata.H3F4cpos;

    if (smoothwin~=0)
        mdata.H3u = filter(ones(smoothwin,1)/smoothwin, 1, mdata.H3u);
        mdata.H3c = filter(ones(smoothwin,1)/smoothwin, 1, mdata.H3c);
    end
    %mdata = rmfield(mdata, 'H3');
end

if (isfield(mdata, 'H4'))
    mdata.H4u = mdata.H4;  % H4 is actually the uncorrected harmonic
    mdata.H4F1c = func_correct_iseli_z(4*F0, F1, mdata.fB1, mdata.Fs); % the corrected for F1 value for H1
    mdata.H4F2c = func_correct_iseli_z(4*F0, F2, mdata.fB2, mdata.Fs);    
    mdata.H4F3c = func_correct_iseli_z(4*F0, F3, mdata.fB3, mdata.Fs);    
    mdata.H4F4c = func_correct_iseli_z(4*F0, F4, mdata.fB4, mdata.Fs);    
    
    mdata.H4F1cpos = mdata.H4F1c;
    mdata.H4F2cpos = mdata.H4F2c;
    mdata.H4F3cpos = mdata.H4F3c;
    mdata.H4F4cpos = mdata.H4F4c;

    mdata.H4F1cpos(mdata.H4F1cpos < 0) = 0;
    mdata.H4F2cpos(mdata.H4F2cpos < 0) = 0;
    mdata.H4F3cpos(mdata.H4F3cpos < 0) = 0;
    mdata.H4F4cpos(mdata.H4F4cpos < 0) = 0;

    mdata.H4c = mdata.H4u - mdata.H4F1cpos - mdata.H4F2cpos - mdata.H4F3cpos - mdata.H4F4cpos;

    if (smoothwin~=0)
        mdata.H4u = filter(ones(smoothwin,1)/smoothwin, 1, mdata.H4u);
        mdata.H4c = filter(ones(smoothwin,1)/smoothwin, 1, mdata.H4c);
    end
    %mdata = rmfield(mdata, 'H4');
end
    
% Ax
if (isfield(mdata, 'A1'))
    mdata.A1u = mdata.A1; % A1 is actually the uncorrected amplitude
    mdata.A1F1c = func_correct_iseli_z(F1, F1, mdata.fB1, mdata.Fs); % the corrected for F1 value for H1
    mdata.A1F2c = func_correct_iseli_z(F1, F2, mdata.fB2, mdata.Fs);
    mdata.A1F1cpos = mdata.A1F1c;
    mdata.A1F2cpos = mdata.A1F2c;
    mdata.A1F1cpos(mdata.A1F1cpos < 0) = 0;
    mdata.A1F2cpos(mdata.A1F2cpos < 0) = 0;

    mdata.A1c = mdata.A1u - mdata.A1F1cpos - mdata.A1F2cpos;


    if (smoothwin~=0)
        mdata.A1u = filter(ones(smoothwin,1)/smoothwin, 1, mdata.A1u);
        mdata.A1c = filter(ones(smoothwin,1)/smoothwin, 1, mdata.A1c);
    end    
    %mdata = rmfield(mdata, 'A1');
end

if (isfield(mdata, 'A2'))
    mdata.A2u = mdata.A2; % A2 is acutally the uncorrected amplitude
    mdata.A2F1c = func_correct_iseli_z(F2, F1, mdata.fB1, mdata.Fs); % the corrected for F1 value for H1
    mdata.A2F2c = func_correct_iseli_z(F2, F2, mdata.fB2, mdata.Fs);
    mdata.A2F3c = func_correct_iseli_z(F2, F3, mdata.fB3, mdata.Fs);

    mdata.A2F1cpos = mdata.A2F1c;
    mdata.A2F2cpos = mdata.A2F2c;
    mdata.A2F3cpos = mdata.A2F3c;

    mdata.A2F1cpos(mdata.A2F1cpos < 0) = 0;
    mdata.A2F2cpos(mdata.A2F2cpos < 0) = 0;
    mdata.A2F3cpos(mdata.A2F3cpos < 0) = 0;


    mdata.A2c = mdata.A2u - mdata.A2F1cpos - mdata.A2F2cpos - mdata.A2F3cpos;
    if (smoothwin~=0)
        mdata.A2u = filter(ones(smoothwin,1)/smoothwin, 1, mdata.A2u);
        mdata.A2c = filter(ones(smoothwin,1)/smoothwin, 1, mdata.A2c);
    end
    %mdata = rmfield(mdata, 'A2');
end

if (isfield(mdata, 'A3'))
    mdata.A3u = mdata.A3; % A3 is actually the uncorrected amplitude
    mdata.A3F1c = func_correct_iseli_z(F3, F1, mdata.fB1, mdata.Fs);
    mdata.A3F2c = func_correct_iseli_z(F3, F2, mdata.fB2, mdata.Fs);
    mdata.A3F3c = func_correct_iseli_z(F3, F3, mdata.fB3, mdata.Fs);
    mdata.A3F4c = func_correct_iseli_z(F3, F4, mdata.fB4, mdata.Fs);
    
    mdata.A3F1cpos = mdata.A3F1c;
    mdata.A3F2cpos = mdata.A3F2c;
    mdata.A3F3cpos = mdata.A3F3c;
    mdata.A3F4cpos = mdata.A3F4c;

    mdata.A3F1cpos(mdata.A3F1cpos < 0) = 0;
    mdata.A3F2cpos(mdata.A3F2cpos < 0) = 0;
    mdata.A3F3cpos(mdata.A3F3cpos < 0) = 0;
    mdata.A3F4cpos(mdata.A3F4cpos < 0) = 0;

    mdata.A3c = mdata.A3u - mdata.A3F1cpos - mdata.A3F2cpos - mdata.A3F3cpos - mdata.A3F4cpos;
    if (smoothwin~=0)
        mdata.A3u = filter(ones(smoothwin,1)/smoothwin, 1, mdata.A3u);
        mdata.A3c = filter(ones(smoothwin,1)/smoothwin, 1, mdata.A3c);
    end
    %mdata = rmfield(mdata, 'A3');
end

% 1K
if (isfield(mdata, 'H1K') && isfield(mdata, 'F1K'))
    mdata.H1Ku = mdata.H1K;
    mdata.H1KF1c = func_correct_iseli_z(mdata.F1K, F1, mdata.fB1, mdata.Fs);
    mdata.H1KF2c = func_correct_iseli_z(mdata.F1K, F2, mdata.fB2, mdata.Fs);  
    mdata.H1KF3c = func_correct_iseli_z(mdata.F1K, F3, mdata.fB3, mdata.Fs);  
    mdata.H1KF1cpos = mdata.H1KF1c;
    mdata.H1KF2cpos = mdata.H1KF2c;
    mdata.H1KF3cpos = mdata.H1KF3c;

    mdata.H1KF1cpos(mdata.H1KF1cpos < 0) = 0;
    mdata.H1KF2cpos(mdata.H1KF2cpos < 0) = 0;
    mdata.H1KF3cpos(mdata.H1KF3cpos < 0) = 0;
    mdata.H1Kc = mdata.H1Ku - mdata.H1KF1cpos - mdata.H1KF2cpos - mdata.H1KF3cpos;

    if (smoothwin~=0)
        mdata.H1Ku = filter(ones(smoothwin,1)/smoothwin, 1, mdata.H1Ku);
        mdata.H1Kc = filter(ones(smoothwin,1)/smoothwin, 1, mdata.H1Kc);
    end    
end

if (isfield(mdata, 'H1K5') && isfield(mdata, 'F1K5'))
    mdata.H1K5u = mdata.H1K5;
    mdata.H1K5F1c = func_correct_iseli_z(mdata.F1K5, F1, mdata.fB1, mdata.Fs);
    mdata.H1K5F2c = func_correct_iseli_z(mdata.F1K5, F2, mdata.fB2, mdata.Fs);  
    mdata.H1K5F3c = func_correct_iseli_z(mdata.F1K5, F3, mdata.fB3, mdata.Fs);  
    mdata.H1K5F1cpos = mdata.H1K5F1c;
    mdata.H1K5F2cpos = mdata.H1K5F2c;
    mdata.H1K5F3cpos = mdata.H1K5F3c;

    mdata.H1K5F1cpos(mdata.H1K5F1cpos < 0) = 0;
    mdata.H1K5F2cpos(mdata.H1K5F2cpos < 0) = 0;
    mdata.H1K5F3cpos(mdata.H1K5F3cpos < 0) = 0;
    mdata.H1K5c = mdata.H1K5u - mdata.H1K5F1cpos - mdata.H1K5F2cpos - mdata.H1K5F3cpos;

    if (smoothwin~=0)
        mdata.H1K5u = filter(ones(smoothwin,1)/smoothwin, 1, mdata.H1K5u);
        mdata.H1K5c = filter(ones(smoothwin,1)/smoothwin, 1, mdata.H1K5c);
    end    
end



% 2K
if (isfield(mdata, 'H2K') && isfield(mdata, 'F2K'))
    mdata.H2Ku = mdata.H2K;
    mdata.H2KF1c = func_correct_iseli_z(mdata.F2K, F1, mdata.fB1, mdata.Fs);
    mdata.H2KF2c = func_correct_iseli_z(mdata.F2K, F2, mdata.fB2, mdata.Fs);  
    mdata.H2KF3c = func_correct_iseli_z(mdata.F2K, F3, mdata.fB3, mdata.Fs); 
    mdata.H2KF1cpos = mdata.H2KF1c;
    mdata.H2KF2cpos = mdata.H2KF2c;
    mdata.H2KF3cpos = mdata.H2KF3c;

    mdata.H2KF1cpos(mdata.H2KF1cpos < 0) = 0;
    mdata.H2KF2cpos(mdata.H2KF2cpos < 0) = 0;
    mdata.H2KF3cpos(mdata.H2KF3cpos < 0) = 0;
    mdata.H2Kc = mdata.H2Ku - mdata.H2KF1cpos - mdata.H2KF2cpos - mdata.H2KF3cpos;

    if (smoothwin~=0)
        mdata.H2Ku = filter(ones(smoothwin,1)/smoothwin, 1, mdata.H2Ku);
        mdata.H2Kc = filter(ones(smoothwin,1)/smoothwin, 1, mdata.H2Kc);
    end    
end

% 3K
if (isfield(mdata, 'H3K') && isfield(mdata, 'F3K'))
    mdata.H3Ku = mdata.H3K;
    %mdata.H3Kc = mdata.H3Ku - func_correct_iseli_z(mdata.F3K, F1, mdata.fB1, mdata.Fs);
    mdata.H3KF2c = func_correct_iseli_z(mdata.F3K, F2, mdata.fB2, mdata.Fs);  
    mdata.H3KF3c = func_correct_iseli_z(mdata.F3K, F3, mdata.fB3, mdata.Fs);  
    mdata.H3KF4c = func_correct_iseli_z(mdata.F3K, F4, mdata.fB4, mdata.Fs);  
    mdata.H3KF2cpos = mdata.H3KF2c;
    mdata.H3KF3cpos = mdata.H3KF3c;
    mdata.H3KF4cpos = mdata.H3KF4c;

    mdata.H3KF2cpos(mdata.H3KF2cpos < 0) = 0;
    mdata.H3KF3cpos(mdata.H3KF3cpos < 0) = 0;
    mdata.H3KF4cpos(mdata.H3KF4cpos < 0) = 0;


    mdata.H3Kc = mdata.H3Ku - mdata.H3KF2cpos - mdata.H3KF3cpos - mdata.H3KF4cpos;
    %mdata.H3Kc = mdata.H3Kc - func_correct_iseli_z(mdata.F3K, F5, mdata.fB5, mdata.Fs);
    if (smoothwin~=0)
        mdata.H3Ku = filter(ones(smoothwin,1)/smoothwin, 1, mdata.H3Ku);
        mdata.H3Kc = filter(ones(smoothwin,1)/smoothwin, 1, mdata.H3Kc);
    end    
end

% 4K
if (isfield(mdata, 'H4K') && isfield(mdata, 'F4K'))
    mdata.H4Ku = mdata.H4K;
    %mdata.H4Kc = mdata.H4Ku - func_correct_iseli_z(mdata.F4K, F1, mdata.fB1, mdata.Fs);
    %mdata.H4Kc = mdata.H4Ku - func_correct_iseli_z(mdata.F4K, F2, mdata.fB2, mdata.Fs);
    mdata.H4KF3c = func_correct_iseli_z(mdata.F4K, F3, mdata.fB3, mdata.Fs);  
    mdata.H4KF4c = func_correct_iseli_z(mdata.F4K, F4, mdata.fB4, mdata.Fs);  
    mdata.H4KF5c = func_correct_iseli_z(mdata.F4K, F5, mdata.fB5, mdata.Fs);  
    mdata.H4KF3cpos = mdata.H4KF3c;
    mdata.H4KF4cpos = mdata.H4KF4c;
    mdata.H4KF5cpos = mdata.H4KF5c;

    mdata.H4KF3cpos(mdata.H4KF3cpos < 0) = 0;
    mdata.H4KF4cpos(mdata.H4KF4cpos < 0) = 0;
    mdata.H4KF5cpos(mdata.H4KF5cpos < 0) = 0;
    
    mdata.H4KF5cpos(isnan(mdata.H4KF5cpos)) = 0;

    mdata.H4Kc = mdata.H4Ku - mdata.H4KF3cpos - mdata.H4KF4cpos - mdata.H4KF5cpos;

    %mdata.H4Kc = mdata.H3Kc - func_correct_iseli_z(mdata.F4K, F5, mdata.fB5, mdata.Fs);

    if (smoothwin~=0)
        mdata.H4Ku = filter(ones(smoothwin,1)/smoothwin, 1, mdata.H4Ku);
        mdata.H4Kc = filter(ones(smoothwin,1)/smoothwin, 1, mdata.H4Kc);
    end    
end


% 5K
if (isfield(mdata, 'H5K') && isfield(mdata, 'F5K'))
    mdata.H5Ku = mdata.H5K;
    mdata.H5KF3c = func_correct_iseli_z(mdata.F5K, F3, mdata.fB3, mdata.Fs);  
    mdata.H5KF4c = func_correct_iseli_z(mdata.F5K, F4, mdata.fB4, mdata.Fs); 
    mdata.H5KF5c = func_correct_iseli_z(mdata.F5K, F5, mdata.fB5, mdata.Fs); 
    mdata.H5KF3cpos = mdata.H5KF3c;
    mdata.H5KF4cpos = mdata.H5KF4c;
    mdata.H5KF5cpos = mdata.H5KF5c;

    mdata.H5KF3cpos(mdata.H5KF3cpos < 0) = 0;
    mdata.H5KF4cpos(mdata.H5KF4cpos < 0) = 0;
    mdata.H5KF5cpos(mdata.H5KF5cpos < 0) = 0;
    mdata.H5KF5cpos(isnan(mdata.H5KF5cpos)) = 0;

    mdata.H5Kc = mdata.H5Ku - mdata.H5KF3cpos - mdata.H5KF4cpos - mdata.H5KF5cpos;

    if (smoothwin~=0)
        mdata.H5Ku = filter(ones(smoothwin,1)/smoothwin, 1, mdata.H5Ku);
        mdata.H5Kc = filter(ones(smoothwin,1)/smoothwin, 1, mdata.H5Kc);
    end    
end

% the uncorrected combo parameters
if (isfield(mdata, 'H1') && isfield(mdata, 'H2'))
    mdata.H1H2u = mdata.H1 - mdata.H2;
    if (smoothwin ~= 0)
        mdata.H1H2u = filter(ones(smoothwin,1)/smoothwin, 1, mdata.H1H2u);
    end
end

if (isfield(mdata, 'H2') && isfield(mdata, 'H4'))
    mdata.H2H4u = mdata.H2 - mdata.H4;
    if (smoothwin ~= 0)
        mdata.H2H4u = filter(ones(smoothwin,1)/smoothwin, 1, mdata.H2H4u);
    end
end

if (isfield(mdata, 'H1') && isfield(mdata, 'A1'))
    mdata.H1A1u = mdata.H1 - mdata.A1;
    if (smoothwin ~= 0)
        mdata.H1A1u = filter(ones(smoothwin,1)/smoothwin, 1, mdata.H1A1u);
    end
end

if (isfield(mdata, 'H1') && isfield(mdata, 'A2'))
    mdata.H1A2u = mdata.H1 - mdata.A2;
    if (smoothwin ~= 0)
        mdata.H1A2u = filter(ones(smoothwin,1)/smoothwin, 1, mdata.H1A2u);
    end
end

if (isfield(mdata, 'H1') && isfield(mdata, 'A3'))
    mdata.H1A3u = mdata.H1 - mdata.A3;
    if (smoothwin ~= 0)
        mdata.H1A3u = filter(ones(smoothwin,1)/smoothwin, 1, mdata.H1A3u);
    end
end

if (isfield(mdata, 'H4') && isfield(mdata, 'H2K'))
    mdata.H42Ku = mdata.H4 - mdata.H2K;
    if (smoothwin ~= 0)
        mdata.H42Ku = filter(ones(smoothwin,1)/smoothwin, 1, mdata.H42Ku);
    end
end
    
if (isfield(mdata, 'H2K') && isfield(mdata, 'H5K'))
    mdata.H2KH5Ku = mdata.H2Ku - mdata.H5Ku;
    if (smoothwin ~= 0)
        mdata.H2KH5Ku = filter(ones(smoothwin,1)/smoothwin, 1, mdata.H2KH5Ku);
    end
end


% this section is included for old VS compatibility, previously, the
% corrected versions of HxHx and HxAx were stored as HxHx and HxAx (i.e.
% without the "c"
if (isfield(mdata, 'H1H2'))
    mdata.H1H2c = mdata.H1H2;
end

if (isfield(mdata, 'H2H4'))
    mdata.H2H4c = mdata.H2H4;
end

if (isfield(mdata, 'H1A1'))
    mdata.H1A1c = mdata.H1A1;
end

if (isfield(mdata, 'H1A2'))
    mdata.H1A2c = mdata.H1A2;
end

if (isfield(mdata, 'H1A3'))
    mdata.H1A3c = mdata.H1A3;
end


% check if the others require smoothing
if (smoothwin ~= 0)
    if (isfield(mdata, 'H1H2c'))
        mdata.H1H2c = filter(ones(smoothwin,1)/smoothwin, 1, mdata.H1H2c);
    end
    
    if (isfield(mdata, 'H2H4c'))
        mdata.H2H4c = filter(ones(smoothwin,1)/smoothwin, 1, mdata.H2H4c);
    end
    
    if (isfield(mdata, 'H1A1c'))
        mdata.H1A1c = filter(ones(smoothwin,1)/smoothwin, 1, mdata.H1A1c);
    end
    
    if (isfield(mdata, 'H1A2c'))
        mdata.H1A2c = filter(ones(smoothwin,1)/smoothwin, 1, mdata.H1A2c);
    end
    
    if (isfield(mdata, 'H1A3c'))
        mdata.H1A3c = filter(ones(smoothwin,1)/smoothwin, 1, mdata.H1A3c);
    end
    
    if (isfield(mdata, 'H42Kc'))
        mdata.H42Kc = filter(ones(smoothwin,1)/smoothwin, 1, mdata.H42Kc);
    end
    
    if (isfield(mdata, 'H2KH5Kc'))
        mdata.H2KH5Kc = filter(ones(smoothwin,1)/smoothwin, 1, mdata.H2KH5Kc);
    end
    
    if (isfield(mdata, 'CPP'))
        mdata.CPP = filter(ones(smoothwin,1)/smoothwin, 1, mdata.CPP);
    end
       
    if (isfield(mdata, 'HNR05'))
        mdata.HNR05 = filter(ones(smoothwin,1)/smoothwin, 1, mdata.HNR05);
    end

    if (isfield(mdata, 'HNR15'))
        mdata.HNR15 = filter(ones(smoothwin,1)/smoothwin, 1, mdata.HNR15);
    end

    if (isfield(mdata, 'HNR25'))
        mdata.HNR25 = filter(ones(smoothwin,1)/smoothwin, 1, mdata.HNR25);
    end

    if (isfield(mdata, 'HNR35'))
        mdata.HNR35 = filter(ones(smoothwin,1)/smoothwin, 1, mdata.HNR35);
    end
    
end