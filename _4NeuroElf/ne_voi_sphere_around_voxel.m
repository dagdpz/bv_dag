function [xg] = ne_voi_sphere_around_voxel(c,r)
% c: voi center
% r: sphere radius

% modified from NE VOI::AddSphericalVOI

% create grid
% rc = round(c);
rc = c;
cr = ceil(r + 0.5);
[xg, yg, zg] = ndgrid( ...
    rc(1)-cr:rc(1)+cr, rc(2)-cr:rc(2)+cr, rc(3)-cr:rc(3)+cr);

% fill with grid
xg = [xg(:), yg(:), zg(:)];

% compute distance
yg = sqrt(sum((xg - rc(ones(1, size(xg, 1)), :)) .^ 2, 2));

% sort by distance
[yg, ygi] = sort(yg);
xg = xg(ygi, :);

% remove further away stuff
xg(yg > r, :) = [];