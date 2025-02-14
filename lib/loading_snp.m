function [S] = loading_snp(fname)
%   written by Chihyun Cho (2020.4.17)
%
%   loading snp file format
%
%   return -----------------
%   S.Fr : frequency
%   S.param : S-parameter
%
%  revision 20.10.06  # 이후 나오는 주석! 처리
%  revision 20.11.05  시간이 걸리더라도 !와 #는 제외하고 한줄씩 데이터 리딩
%  revision 21.02.19  s4p 읽을 수 있도록 수정. coder 변환 가능토록 수정


% number of ports are obtained from file name
nP = str2double(fname(end-1));

fid = fopen(fname, 'r');

nHead = 0;
while ~feof(fid)
    posi = ftell(fid);
    tline = fgetl(fid);
    
    if tline(1) == '#'
        C = upper(split(tline));
        
%         a = double(upper(tline));
%         
%         idx = find(a==32);
%         
%         m = 1;
%         for k=1:length(idx)-1
%             tempC = strip(char(a(idx(k):idx(k+1))));
%             if isempty(tempC) == 0
%                 C{m} = tempC;
%                 m = m+1;
%             end
%         end
        
        
    elseif tline(1) == '!'
        
    else
        
        fseek(fid,posi,'bof');
        
        a = fscanf(fid, '%f');
    end
    
    
end

L = length(a);
A = reshape(a, [1+nP^2*2 L/(1+nP^2*2)])';

switch C{2}
    case 'HZ'
        f = 1;
    case 'KHZ'
        f = 1e3;
    case 'MHZ'
        f = 1e6;
    case 'GHZ'
        f = 1e9;
    case 'THz'
        f = 1e12;
        
    case 'S'
        f = 1;
end


switch C{4}
    case 'RI'
        
        for k=1:nP^2
            temp{k} = A(:,k*2) + 1j*A(:,k*2+1);
        end
        
    case 'DB'
        
        for k=1:nP^2
            temp{k} = 10.^(A(:,k*2)/20) .* exp(1j*deg2rad(A(:,k*2+1)));
        end
        
        
    case 'MA'
        
        for k=1:nP^2
            temp{k} = A(:,k*2) .* exp(1j*deg2rad(A(:,k*2+1)));
        end
        
end


S.Param = [temp{1:nP^2}];
S.Fr = A(:,1)*f;

fclose(fid);

end



