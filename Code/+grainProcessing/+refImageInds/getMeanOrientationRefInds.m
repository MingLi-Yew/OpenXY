function refInds = getMeanOrientationRefInds(Settings)

import grainProcessing.refImageInds.*;

grainIDs = Settings.grainID;
IQ = Settings.IQ;
angles = Settings.Angles;

%Get Quaternion symmetry operators
if length(unique(Settings.Phase)) > 1
    %TODO handle Multi-Phase materials
else
    M = ReadMaterial(Settings.Phase{1});
end
lattype = M.lattice;
if strcmp(lattype,'hexagonal')
    q_symops = rmat2quat(permute(gensymopsHex,[3 2 1]));
else
    q_symops = rmat2quat(permute(gensymops,[3 2 1]));
end


% TODO Continue to work from here
end
