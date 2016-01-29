function test_print_rotate_matrix( a )
fid = fopen('test_print_rotate_matrix.txt', 'wt');

end_j = size(a,1);
end_i = size(a,2);

    for j=end_j:-1:1
for i=end_i:-1:1
    fprintf(fid,'%6ff, ', a(j,i));
    end
    fprintf(fid,'\n');
end
    
fclose(fid);
end