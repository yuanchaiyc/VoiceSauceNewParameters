function paramlist = func_getoutputparameterlist(param)
% paramlist = func_getoutputparameterlist(param)
% Input:  param - parameter (optional)
% Output: paramlist - list of parameters; or
%         index of the parameter in the list
% Notes:  Dual purpose function
%
% Author: Yen-Liang Shue, Speech Processing and Auditory Perception Laboratory, UCLA
% Modifications: Soo Jin Park
% Copyright UCLA SPAPL 2009-2015

paramlist = {'H1* (H1c)', ...
             'H2* (H2c)', ...
             'H3* (H3c)', ...
             'H4* (H4c)', ...
             'A1* (A1c)', ...
             'A2* (A2c)', ...
             'A3* (A3c)', ...
             '1K* (H1Kc)', ...
             '1K5* (H1K5c)', ...
             '2K* (H2Kc)', ...
             '3K* (H3Kc)', ...
             '4K* (H4Kc)', ...
             '5K* (H5Kc)', ...
             'F1K (F1K)', ...
             'F2K (F2K)', ...
             'F3K (F3K)', ...
             'F4K (F4K)', ...
             'F5K (F5K)', ...
             'H1F1correction (H1F1c)', ...
             'H1F2correction (H1F2c)', ...
             'H2F1correction (H2F1c)', ...
             'H2F2correction (H2F2c)', ...
             'H3F1correction (H3F1c)', ...
             'H3F2correction (H3F2c)', ...
             'H4F1correction (H4F1c)', ...
             'H4F2correction (H4F2c)', ...
             'H1KF1correction (H1KF1c)', ...
             'H1KF2correction (H1KF2c)', ...
             'H1KF3correction (H1KF3c)', ...
             'H2KF1correction (H2KF1c)', ...
             'H2KF2correction (H2KF2c)', ...
             'H2KF3correction (H2KF3c)', ...
             'H3KF2correction (H3KF2c)', ...
             'H3KF3correction (H3KF3c)', ...
             'H3KF4correction (H3KF4c)', ...
             'H4KF3correction (H4KF3c)', ...
             'H4KF4correction (H4KF4c)', ...
             'H4KF5correction (H4KF5c)', ...
             'H5KF3correction (H5KF3c)', ...
             'H5KF4correction (H5KF4c)', ...
             'H5KF5correction (H5KF5c)', ...
             'A1F1correction (A1F1c)', ...
             'A1F2correction (A1F2c)', ...             
             'A2F1correction (A2F1c)', ...
             'A2F2correction (A2F2c)', ...   
             'A3F1correction (A3F1c)', ...
             'A3F2correction (A3F2c)', ...             
             'A3F3correction (A3F3c)', ...             
             'H1*-H2* (H1H2c)', ...
             'H2*-H4* (H2H4c)', ...
             'H1*-A1* (H1A1c)', ...
             'H1*-A2* (H1A2c)', ...
             'H1*-A3* (H1A3c)', ...
             'H4*-2K* (H42Kc)', ...
             '2K*-5K (H2KH5Kc)', ...
             'CPP (CPP)', ...
             'Energy (Energy)', ...
             'HNR05 (HNR05)', ...
             'HNR15 (HNR15)', ...
             'HNR25 (HNR25)', ...
             'HNR35 (HNR35)', ...    
             'SHR (SHR)', ...
             'H1 (H1u)', ...
             'H2 (H2u)', ...
             'H3 (H3u)', ...
             'H4 (H4u)', ...
             'A1 (A1u)', ...
             'A2 (A2u)', ...
             'A3 (A3u)', ...
             '1K (H1Ku)', ...
             '1K5 (H1K5u)', ...
             '2K (H2Ku)', ...
             '3K (H3Ku)', ...
             '4K (H4Ku)', ...
             '5K (H5Ku)', ...
             'H1-H2 (H1H2u)', ...
             'H2-H4 (H2H4u)', ...
             'H1-A1 (H1A1u)', ...
             'H1-A2 (H1A2u)', ...
             'H1-A3 (H1A3u)', ...   
             'H4-2K (H42Ku)', ...
             '2K-5K (H2KH5Ku)', ...
             'F0 - Straight (strF0)', ...
             'F0 - Snack (sF0)', ...
             'F0 - Praat (pF0)', ...
             'F0 - SHR (shrF0)', ...          
             'F1 - Snack (sF1)', ...
             'F2 - Snack (sF2)', ...
             'F3 - Snack (sF3)', ...
             'F4 - Snack (sF4)', ...
             'F1 - Praat (pF1)', ...
             'F2 - Praat (pF2)', ...
             'F3 - Praat (pF3)', ...
             'F4 - Praat (pF4)', ...
             'F5 - Praat (pF5)', ...
             'F1 - Other (oF1)', ...
             'F2 - Other (oF2)', ...
             'F3 - Other (oF3)', ...
             'F4 - Other (oF4)', ...
             'B1 - Formula (fB1)', ...
             'B2 - Formula (fB2)', ...
             'B3 - Formula (fB3)', ...
             'B4 - Formula (fB4)', ...
             'B1 - Snack (sB1)', ...
             'B2 - Snack (sB2)', ...
             'B3 - Snack (sB3)', ...
             'B4 - Snack (sB4)', ...
             'B1 - Praat (pB1)', ...
             'B2 - Praat (pB2)', ...
             'B3 - Praat (pB3)', ...
             'B4 - Praat (pB4)', ...
             'B5 - Praat (pB5)', ...
             'B1 - Other (oB1)', ...
             'B2 - Other (oB2)', ...
             'B3 - Other (oB3)', ...
             'B4 - Other (oB4)', ...
             'epoch (epoch)',...
             'SoE (soe)',...
             };
         
% user is asking for index to a param
if (nargin == 1)
    for k=1:length(paramlist)
        if (strcmp(paramlist{k}, param))
            paramlist = k;
            return;
        end
    end
    paramlist = -1;  % param not found in list
end
