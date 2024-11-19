function [F1, F2, F3, F4, F5, B1, B2, B3, B4, B5] = func_parseFMT(matdata, FMTalgorithm)
% [F1, F2, F3] = func_parseFMT(matdata, FMTalgorithm)
% Input:  matdata - mat data
%         FMTalgorithm - FMT algorithm to use
% Output: F1, F2, F3 vectir
% Notes:  choose the FMT vectors depending on what is specified
%
% Author: Yen-Liang Shue, Speech Processing and Auditory Perception Laboratory, UCLA
% Modified: 5/15/2015 by Soo to add estimated formant bandwidths
% Copyright UCLA SPAPL 2009-2015


F1 = []; F2 = []; F3 = []; F4 = []; F5 = [];
B1 = []; B2 = []; B3 = []; B4 = []; B5 = [];

switch(FMTalgorithm)
    case {'Formants (Snack)'}
        if (isfield(matdata, 'sF1') && isfield(matdata, 'sF2') && isfield(matdata, 'sF3') && isfield(matdata, 'sF4'))
            F1 = matdata.sF1;
            F2 = matdata.sF2;
            F3 = matdata.sF3;
            F4 = matdata.sF4;
            B1 = matdata.sB1;
            B2 = matdata.sB2;
            B3 = matdata.sB3;
            B4 = matdata.sB4;
        end
        
    case {'Formants (Praat)'}
        if (isfield(matdata, 'pF1') && isfield(matdata, 'pF2') && isfield(matdata, 'pF3') && isfield(matdata, 'pF4') && isfield(matdata, 'pF5'))
            F1 = matdata.pF1;
            F2 = matdata.pF2;
            F3 = matdata.pF3;
            F4 = matdata.pF4;
            F5 = matdata.pF5;
            B1 = matdata.pB1;
            B2 = matdata.pB2;
            B3 = matdata.pB3;
            B4 = matdata.pB4;
            B5 = matdata.pB5;
        end
        
    case {'Formants (Other)'}
        if (isfield(matdata, 'oF1') && isfield(matdata, 'oF2') && isfield(matdata, 'oF3') && isfield(matdata, 'oF4') && isfield(matdata, 'oF5'))
            F1 = matdata.oF1;
            F2 = matdata.oF2;
            F3 = matdata.oF3;
            F4 = matdata.oF4;
            F5 = matdata.oF5;
            B1 = matdata.oB1;
            B2 = matdata.oB2;
            B3 = matdata.oB3;
            B4 = matdata.oB4;
            B5 = matdata.oB5;
        end
        
    otherwise
        F1 = [];
        F2 = [];
        F3 = [];
        F4 = [];
        F5 = [];
        B1 =[];
        B2 =[];
        B3 =[];
        B4 =[];
        B5 =[];
end
