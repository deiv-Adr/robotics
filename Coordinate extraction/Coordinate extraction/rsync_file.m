function rsync_file(source_file, destination_ip, destination_dir)
    % Construct the rsync command
    rsync_command = sprintf('rsync -avz %s %s:%s', source_file, destination_ip, destination_dir);

    % Execute the command using the system function
    [status, result] = system(rsync_command);

    if status ~= 0
        warning('Rsync failed: %s', result);
    else
        disp('Rsync completed successfully.');
    end
end