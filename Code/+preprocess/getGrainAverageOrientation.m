function [quats] = getGrainAverageOrientation(...
    grainIDs, orientations, symOps, imageQuality)

scanLength = length(grainIDs);

if nargin < 4
    imageQuality = ones(scanLength, 1);
end


if isequal(size(orientations), [scanLength, 3])
    % Passed in euler angles
    quats = euler2quat(orientations);
elseif isequal(size(orientations), [scanLength, 4])
    % Passed in quaterinons
    quats = orientations;
elseif isequal(size(orientations), [3, 3, scanLength])
    % Passed in g matricies
    quats = rmat2quat(orientations);
else
    error('OpenXY:GetGrainAverageOrientation', ...
        ['Incorrect orientation shape. The argument ''orientations'' '...
        'should be euler angles, g matricies or quaternions'])
end

sz = size(symOps);
if numel(sz) == 3
    if sz(1) ~= 3
        symOps = permute(symOps, [2 3 1]);
    end
    symOps = rmat2quat(symOps);
end

numGrains = max(grainIDs);
avgQuats = zeros(numGrains, 4);
rotQuats = zeros(scanLength, 4);

allAvg = rotQuats;

for ii = 1:numGrains
    currGrain = grainIDs == ii;
    currQuats = quats(currGrain, :);
    currIQ = imageQuality(currGrain);
    [avgQuats(ii, :), rotQuats(currGrain, :)] = getSymetryQuats(currQuats, symOps, currIQ);
    allAvg(currGrain, :) = repmat(avgQuats(ii, :), sum(currGrain), 1);
end

makeIPF(quats, 'Original');
makeIPF(rotQuats, 'Rotated');
makeIPF(allAvg, 'GrainAvg');


end

function [avg_q, rot_quats] = getSymetryQuats(quats, symOps, imageQuality)
%Still some problems on grains 2 & 3...

[~, best] = max(imageQuality);

refQuat = quats(best, :);

numQuats = size(quats, 1);
symQuats = quatmult(symOps, quats, 'noreshape');
symQuats = cat(3, symQuats, - symQuats);

rot_quats = zeros(size(quats));

for ii = 1:numQuats
    curQuats = squeeze(symQuats(ii, :, :))';
    misos = quatangle(refQuat, curQuats);
    [~, minInd] = min(misos);
    rot_quats(ii, :) = curQuats(minInd, :);
end
qMat = rot_quats' * rot_quats;
[v, d] = eig(qMat);
[~, maxInd] = max(max(d));

avg_q = v(:, maxInd)';

end

function makeIPF(quats, titleString)
figure;
ax = axes;

g = quat2rmat(quats);
dims = [29 31];
type = 'Square';

ipf = PlotIPF(g,dims,type,0);

image(ax, ipf);
axis(ax, 'image');
title(ax, titleString);

end
