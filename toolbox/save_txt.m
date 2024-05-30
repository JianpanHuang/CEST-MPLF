function save_txt(path, data)
% FUNCTION
%   To save 'data' as a txt file under 'path', path includes file name
% AUTHOR:
%   Jianpan Huang   Email: jianpanhuang@outlook.com

%%
fid=fopen(path,'wt');
[m,n]=size(data);
 for mm=1:1:m
   for nn=1:1:n
      if nn==n
        fprintf(fid,'%g\n', data(mm,nn));
      else
        fprintf(fid,'%g\t', data(mm,nn));
      end
   end
end
fclose(fid);