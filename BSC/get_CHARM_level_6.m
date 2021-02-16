function get_CHARM_level_6(keyfile)
%currently gets level 5 VOIs because I am lazy
%for l6 change Last_Level to 6 and remove addendum
%intended for CHARM/SARMkeyds - dataset with Index, Abbreviation and last
%level

%get the Level 6 VOIS
l6=keyfile(keyfile.Last_Level == 5, :);
l6addendum = keyfile(keyfile.Last_Level == 6 & keyfile.First_Level~=6, :);
l6 = vertcat(l6,l6addendum);

%generate the filenames
l6_vois = strcat(num2str(l6.Index),'_',l6.Abbreviation,'.voi');
l6_vois = strtrim(l6_vois);
l6_vois = strrep(l6_vois, '/','_');

%and copy the files
mkdir level_5;
for i = 1:length(l6_vois)
    copyfile([pwd filesep l6_vois{i}], 'level_5');
end

