function KF_NonUniform_Timestep()
	disp('Kalman Filter for a Non-Uniform Timestep')
	
	%=============================
	% Step size parameters
	step_n = 0.2;   % Average discrete time step size
	step_s = 0.06;  % Standard deviation of the discrete time step size
	sim_time = 60; % Duration of the simulation (sec)
	disp(sprintf('%g sec simulation with timesteps avg = %g sec, stdev = %g sec', sim_time, step_n, step_s))
	% End step size parameters
	%=============================
	
	%======================================
	% System/Estimator configuration
	
	% Magnitude of the forcing function
	u_mag = -1;
	
	% Discrete system setup
	A_func = @(dt)[[1 dt; 0 1]];   % Function to generate an A matrix based on the step size
	B_func = @(dt)[[dt^2/2 dt]'];  % Function to generate a B matrix based on the step size
	C = [1 0];                     % Tracked state is x(1)
	
	% Setup initial conditions for the truth model and the estimator
	x_truth = [-20 5]';
	x_est = [0 0]';
	
	% Process noise setup, based on time step sizes
	Q_std = 0.05;                          % Process noise standard deviation
	w = @(dt)[Q_std  * [(dt^2/2); dt]];    % Create process noise matrix function using the process noise std
	w_k = @(dt)[w(dt) .* randn(2,1)];      % Add process noise at time step k
	Q_k = @(dt)[w(dt) * w(dt)'];           % Q_k = Ex = w*w'
	
	% Initialize the covariance matrix using an estimated average step size.
	P = Q_k(step_n);
	
	% Measurement noise setup
	R_std = 5;                             % Measurement noise standard deviation
	v = R_std;                             % Base level measurment noise for y = Cx + v
	v_k = @()[v * randn];                  % Measurement noise variance
	R_k = R_std^2;                         % R_k = Ez = v * v'
	
	% End System/Estimator configuration
	%======================================
	
	% Set the time values for the loop
	start_time = timestamp();
	last_update_time = timestamp();
	
	% Not ideal to have a continuously growing array here, but
	% it'll do for demonstration purposes
	history = [];
	step_count = 0;
	t_step = timestamp();
	
	% Simulate the System with a Kalman Filter estimator
	while t_step < start_time + sim_time
		step_count = step_count + 1;
		
		% Alter the input force depending on the simulation time
		if mod(t_step-start_time,20) < 10
			u = u_mag;
		else
			u = -u_mag;
		end
		
		% Determine the actual runtime step size
		dt = t_step - last_update_time;
		last_update_time = t_step;
		
		%==========================
		% System model update
		
		% Create a state matrix based on the measured time step
		A = A_func(dt);
		B = B_func(dt);
		
		% Update the truth model state without process noise
		x_truth = A * x_truth + B * u;
		% Add process noise to the system state
		x_truth = x_truth + w_k(dt);
		
		% Generate a noisy measurement
		y = C * x_truth + v_k();
		
		% End system model update
		%==========================
		
		
		%==========================
		% Estimator update
		
		% (a priori) Predict the next state and covariance values
		x_est = A * x_est + B * u;  % state
		P = A * P * A' + Q_k(dt);    % covariance
		
		% Compute Kalman Gain
		K = P * C' * inv(C * P * C' + R_k);
		
		% (a posteriori) Update predictions
		x_adj = K * (y - C * x_est); % Calulate the measurement based adjustement
		x_est = x_est + x_adj;       % Combine the predicted state with the measurement adjustment
		P = (eye(2) - K * C) * P;    % Update the coviance matrix
		
		% End estimator update
		%==========================
		
		% Determine the position error
		x_err = x_est(1) - x_truth(1);
		
		history(step_count, :) = [t_step-start_time x_truth(1) y x_est(1) x_err];
		
		% Create a gaussian based variable time step
		pause(step_n + randn * step_s)
		
		% Update the current timestamp
		% This gets referenced a few times so just recalc and store
		t_step = timestamp();
	end
	
	% Summary
	disp('Simulation Complete');
	disp(sprintf(' Final state error: %g', x_err))
	
	% Show the simulation results
	plot_simulation_results(history)
end

% Most use cases have timesteps measured in units other than days.
% builtin now returns a timestamp in days
% x by 86400 seconds in a day for the seconds based timestamp
function t = timestamp()
	t = now() * 86400;
end

function plot_simulation_results(history)
	subplot(2,1,1)
	hold on;
	plot(history(:, 1), history(:, 3), 'k.');
	plot(history(:, 1), history(:, 2), 'g--', 'LineWidth', 2);
	plot(history(:, 1), history(:, 4), 'b-', 'LineWidth', 2);
	legend('measured', 'truth', 'estimated', 'Location', 'SouthEast');
	title('Kalman Filter with Non-Uniform Timesteps')
	xlabel('Time (sec)')
	ylabel('State')
	subplot(2,1,2);
	plot(history(:, 1), history(:, 5), 'r-', 'LineWidth', 2);
	legend('estimated - truth', 'Location', 'SouthEast');
	xlabel('Time (sec)')
	ylabel('Error')
	hold off;
end
