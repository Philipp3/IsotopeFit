function out = findinvolvedmolecules(molecules,searchlist,index)
%out = findinvolvedmolecules(molecules,index)
%   searches for molecules, that are within the massrange of molecule with
%   number [index]
%   only indices in searchlist are relevant. searchlist needs to be sorted!
%   output: list of indices

minmass=molecules{index}.minmass;
maxmass=molecules{index}.maxmass;

% i=find(searchlist==index);
% 
% while (molecules{searchlist(i)}.maxmass>minmass)&&(i>=1)
%     fprintf('%s-',molecules{searchlist(i)}.name);
%     i=i-1;
% end
% minind=i+1;
% 
% i=find(searchlist==index);
% while (molecules{searchlist(i)}.minmass<maxmass)&&(i<=length(searchlist))
%     fprintf('%s-',molecules{searchlist(i)}.name);
%     i=i+1;
% end
% maxind=i-1;
% 
% fprintf('\n');

out=[];
for i=searchlist
    if ((molecules{i}.minmass<=maxmass)&&(molecules{i}.minmass>=minmass))||...
       ((molecules{i}.maxmass<=maxmass)&&(molecules{i}.maxmass>=minmass))||...
       ((molecules{i}.minmass<=minmass)&&(molecules{i}.maxmass>=maxmass))
        out=[out i];
        %fprintf('%s-',molecules{i}.name);
    end
end
%fprintf('\n');
%out=searchlist(minind:maxind);

end

