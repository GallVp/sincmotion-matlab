function userToRef = androidGravity2RotMat(zVector)

if isrow(zVector)
    zVector = zVector';
end

zVector = zVector ./ norm(zVector);

zUnit = [0;0;1];


% Take zVector to unit vector
v = cross(zVector, zUnit);
c = dot(zVector, zUnit);

vCross = [0 -v(3) v(2);v(3) 0 -v(1);-v(2) v(1) 0];

userToRef = eye(3) + vCross + vCross^2 * (1 / (1+c));
end
