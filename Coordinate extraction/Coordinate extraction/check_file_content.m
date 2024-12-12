function content = check_file_content(file_path)
    % Open the file for reading
    fid = fopen(file_path, 'r');

    % Read the entire file content as a string
    content = fscanf(fid, '%s');

    % Close the file
    fclose(fid);

    % Remove leading/trailing whitespace
    content = strtrim(content);

    % Convert the content to a numeric value (0 or 1)
    content = str2double(content);
end