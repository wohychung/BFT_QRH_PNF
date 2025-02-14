function user_var = load_uservar(uservar_name)
  if exist('./UserVar.m', 'file')
    movefile( ...
      './UserVar.m', ...
      sprintf('UserVar_backup/UserVar_%s.m', datetime('now','Format','yyMMdd_HHmmss')) ...
    );
  end
  if exist(uservar_name, 'file')
    copyfile(uservar_name, './UserVar.m');
  else
    print('Expected file not found')
    return
  end
  user_var = UserVar();
end