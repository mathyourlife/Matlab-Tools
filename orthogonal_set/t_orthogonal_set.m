function t_orthogonal_set()
	% Starting with the x vector will create two
	% vectors in the yz plane
	z_in = [1 0 0]';
	[x, y, z] = orthogonal_set(z_in);
	verify_results(z_in,x,y,z);
	
	% Starting with the y vector will create two
	% vectors in the xz plane
	z_in = [0 1 0]';
	[x, y, z] = orthogonal_set(z_in);
	verify_results(z_in,x,y,z);
	
	% Starting with the z vector will create two
	% vectors in the xy plane
	z_in = [0 0 1]';
	[x, y, z] = orthogonal_set(z_in);
	verify_results(z_in,x,y,z);
	
	% Generate a large random vector so we can
	% verify unit vectors still come back
	z_in = (rand(3,1) - rand(3,1)) * 200;
	[x, y, z] = orthogonal_set(z_in);
	verify_results(z_in,x,y,z);
	
	% Create a random selecion of vectors to test
	for i=1:5
		z_in = (rand(3,1) - rand(3,1)) * 2;
		[x, y, z] = orthogonal_set(z_in);
		verify_results(z_in,x,y,z);
	end
end


function verify_results(z_in,x,y,z)
	disp(sprintf('Test: Reference z-axis points in the global direction [%0.3f %0.3f %0.3f]',z_in))
	disp(sprintf('  Resultant orthogonal set: x = [%0.3f %0.3f %0.3f], y = [%0.3f %0.3f %0.3f], z = [%0.3f %0.3f %0.3f]',x,y,z))
	if norm(x) > 1 + 1e-10 || norm(x) < 1 - 1e-10
		error('x did not come out with a normal vector')
		return
	end
	if norm(y) > 1 + 1e-10 || norm(y) < 1 - 1e-10
		error('y did not come out with a normal vector')
		return
	end
	if norm(z) > 1 + 1e-10 || norm(z) < 1 - 1e-10
		error('z did not come out with a normal vector')
		return
	end
	
	if sum(abs(cross(z_in,z))) > 1e-10
		error('z is not the same direction as specified')
		return
	end
	
	check = cross(x,y);
	if sum(abs(cross(check,z))) > 1e-10
		error('x cross y should have been z')
		return
	end
	
	check = cross(y,z);
	if sum(abs(cross(check,x))) > 1e-10
		error('y cross z should have been x')
		return
	end
	
	check = cross(z,x);
	if sum(abs(cross(check,y))) > 1e-10
		error('z cross x should have been y')
		return
	end
	
	disp('  *Passed*')
end

