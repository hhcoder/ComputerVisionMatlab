function ret = file2data(fname, fsize, mode)
    fid = fopen(fname, 'r');
    ret = fread(fid, fsize, mode);
    fclose(fid);
end