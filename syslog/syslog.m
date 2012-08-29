%SYSLOG - Matlab logging utility.
%
% SYSLOG(msg,filename) logs strings to the
%   working directory.  Lines are prepended with
%   a timestamp YYYY_MM_DD_HH_NN_SS.
%
% Input:
% msg
%   value   - string to be appended to the log file
%   type    - char
% filename
%   value   - filename prefix to be logged to
%             the format filename_YYYY_MM_DD_HH.log
%   default - 'syslog'
%   type    - char
function syslog(msg,filename)
	% Default the log file name if not provided
	if nargin < 2
		filename = 'syslog';
	end
	
	% Make sure that the passed message is a character string
	% If not, (shame on you check out the doc above)
	% try to cast to a character string
	if ~isa(msg,'char')
		% Note: Can't promise an appropiately formatted string
		% If you really need a specific format, construct
		% the string first and send it in.
		try
			msg = num2str(msg);
		catch
			% Cast to a character string failed. Bail!
			return
		end
	end
	
	c = clock;
	
	% Biggest sink for time is creating a file if it 
	% doesn't exist so this rotates on an hourly basis.
	% full_filename = filename_YYYY_MM_DD_HH.log
	full_filename = sprintf('%s\\%s_%s.log',pwd,filename,sprintf('%04d_%02d_%02d_%02d',c(1:4)));
	
	% Open file in append mode
	fid = fopen(full_filename,'a');
	if fid == -1
		% Failed to open file, just return silently
		return
	end
	
	% Write the log line to the file.  Prepend with a time stamp
	% YYYY_MM_DD_HH_NN_SS msg
	try
		% Attempt to append message to the file
		fprintf(fid, sprintf('%s %s\n', sprintf('%04d_%02d_%02d_%02d_%02d_%02.0f',c(1:6)), msg));
	catch
		% Write failed, do nothing so we don't break calling code
	end
	fclose(fid);
end