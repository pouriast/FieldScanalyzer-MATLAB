function names = GetFolderSet(path)

listing = dir(path);
names = {listing.name};

% ok = regexpi(names, '.*\.(rawx)$', 'start');
ok = regexpi(names, 'A', 'start');
names = names(~cellfun(@isempty,ok));

for i = 1:length(names)
  names{i} = fullfile(path,names{i});
end
