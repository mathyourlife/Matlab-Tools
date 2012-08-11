%ORTHOGONAL_SET - Generate an orthogonal set of vectors off one vector
%
%Given a vector, use that as the basis for a rotated coordinate axes.
%The provided vector is normalized and set as the new rotated z-axis.
%New x and y unit vector need to be created so that they are 
%perpendicular to each other and the given vector.  This funciton
%can be used to generate a grid with the passed vector as its
%normal vector.
%
% Input:
% @data
%   value - Matrix composed of of N sets of (x,y,z) coordinates
%           with dimensions Nx3
%   type  - Nx3 matrix
%
% Return:
% @n
%   value - Unit vector that is normal to the fit
%           plane and initial point the average of the
%           @data.y, @data.y, @data.z
%   type  - 3x1 vector
function [x, y, z] = orthogonal_set(z)
	
	z = z / norm(z);
	
	tmp = rand(3,1);
	while sum(cross(z,tmp)) == 0
		tmp = rand(3,1);
	end
	tmp = tmp / norm(tmp);
	
	y = cross(tmp,z);
	y = y / norm(y);
	
	x = cross(y,z);
	x = x / norm(x);
	
end