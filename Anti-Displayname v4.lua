print('testing anti-displayname settings update')

local FindChildByOrder = function(parent, tbl, returnInstance)
  if parent and tbl and typeof(parent) == 'Instance' and type(tbl) == 'table' and #tbl > 0 then
      local Current = parent;
      for _, v in next, tbl do
          coroutine.wrap(function()
              if type(v) == 'string' and Current:FindFirstChild(v) then
                  Current = Current:FindFirstChild(v)
              else
                  return false
              end
          end)()
      end
      if not returnInstance then
          return true
      elseif returnInstance then
          return Current
      end
  end
end

local GetPlrInfo = function(userId)
  if userId and type(userId) == 'string' or type(userId) == 'number' then
      local success, result = pcall(function()
          return game:GetService('UserService'):GetUserInfosByUserIdsAsync({tonumber(tostring(userId))})
      end)
       
      if success then
          return result
      else
          return {{['Id'] = 0, ['Username'] = 'nil (failed to parse?) [HTTP 403?]', ['DisplayName'] = 'nil (failed to parse?) [HTTP 403?]', ['Error'] = result}}
      end
  end
end

local GSub = function(str, replaceWith)
  if str and type(str) == 'string' and replaceWith and type(replaceWith) == 'table' then
      for _, v in next, replaceWith do
          if type(v) == 'string' then
              str = str:gsub(string.split(v, '==>')[1], string.split(v, '==>')[2])
          end
      end
  end
  return str
end

local AppendName = function(str, skrait)
  local GetClass = function(str, tbl, newstr)
      if str and type(str) == 'string' and newstr and type(newstr) == 'string' and tbl and type(tbl) == 'table' then
          local NewString = str;
          for _, v in next, tbl do
              if str:lower():find(v:lower()) then
                  NewString = NewString:gsub(v, newstr)
              end
          end
          return NewString
      end
  end
  if syn and syn.crypt.base64.decode and str and type(str) == 'string' then
      if not skrait then
          return syn.crypt.base64.decode(GetClass(str, {'lol..', '$7', '$', '#', '..lol', '..wtf', '..bumass', '..aaaha', 'wtf..', 'hell..', '..hell'}, ''))
      else
          return syn.crypt.base64.encode(str)
      end
  end
end

local KeysToMothrasBedroom = {
  ['Key'] = {
      '#lol..U$m#..wtf',
      'Vj..wtf',
      '..bumassdX$7J###zlol..',
      'b$H$7$Z#l..aaaha'
  },
  ['SpareKey'] = {
      'Q3..aaaha',
      '#$7Vy..bumass',
      'd#m$7$$4'
  },
  ['SpareKey2'] = {
      '#Q$W#5..wtf', '0#a$$S', 'hell..1Ehell..$a', 'Xlol..Nw#..wtflol..', 'b$#GF', '$5T#$m..wtf', 'wtf..Ft$7Z..bumass', 'S$hell..B$#..wtfD..aaaha', 'chell..mV', 'h$$d##G$..wtf', '$$9..helly#'
  },
  ['SpareKey3'] = {
      '..wtfT$70#9#lol..',
      '$Ihell..I##E$$',
      '#N##N$R..bumass',
      'Fg..bumassg',
      '#R$7E$7$V$$#',
      '##W$$7',
  }
}

if not getrenv()['Anti-DisplaynameRunning'] and getrenv()['Anti-DisplayNameSettings'] and type(getrenv()['Anti-DisplayNameSettings']) == 'table' then
  getrenv()['Anti-DisplaynameRunning'] = true
  if (isfolder('Anti-Displayname (v4) Settings') and isfile('Anti-Displayname (v4) Settings/Settings.json')) then
      writefile('Anti-Displayname (v4) Settings/Settings.json', getrenv()['Anti-DisplayNameSettings'])
  else
      makefolder('Anti-Displayname (v4) Settings')
      writefile('Anti-Displayname (v4) Settings/Settings.json', getrenv()['Anti-DisplayNameSettings'])
  end
   
  if not game['Loaded'] or not game:GetService('Players')['LocalPlayer'] then
      game['Loaded']:Wait();
      game:WaitForChild(game:GetService('Players'));
      game:GetService('Players'):WaitForChild(game:GetService('Players').LocalPlayer.Name)
  end
   
  local LP = game:GetService('Players').LocalPlayer
   
  local PlayersStuff = FindChildByOrder(game:GetService('CoreGui'), {'PlayerList', 'PlayerListMaster', 'OffsetFrame', 'PlayerScrollList', 'SizeOffsetFrame', 'ScrollingFrameContainer', 'ScrollingFrameClippingFrame', 'ScollingFrame', 'OffsetUndoFrame'}, true)
  if PlayersStuff and typeof(PlayersStuff) == 'Instance' and PlayersStuff:IsA('Frame') then
      local Data = game:GetService('HttpService'):JSONDecode(readfile('Anti-Displayname (v4) Settings/Settings.json'))
      PlayersStuff.ChildAdded:Connect(function(v)
          local Data = game:GetService('HttpService'):JSONDecode(readfile('Anti-Displayname (v4) Settings/Settings.json'))
          if v.Name:match('p_') and GetPlrInfo(v.Name:gsub('p_', '')) and FindChildByOrder(v, {'ChildrenFrame', 'NameFrame', 'BGFrame', 'OverlayFrame', 'PlayerName', 'PlayerName'}) and Data.ApplyLeaderboardDisplayname then
              local PlrInfo = GetPlrInfo(v.Name:gsub('p_', ''));
              local PlayerNameLabel = FindChildByOrder(v, {'ChildrenFrame', 'NameFrame', 'BGFrame', 'OverlayFrame', 'PlayerName', 'PlayerName'}, true)
              if PlayerNameLabel and not game:GetService('Players'):FindFirstChild(PlrInfo[1].DisplayName) and PlrInfo[1].Username ~= LP.Name then
                  if Data.NameLayoutLeaderboard == 'Horizontal' or Data.NameLayoutLeaderboard ~= 'Vertical' then
                      PlayerNameLabel.RichText = true;PlayerNameLabel.Text = PlrInfo[1].DisplayName..' ['..tostring(PlrInfo[1].Username)..']'
                  elseif Data.NameLayoutLeaderboard == 'Vertical' or Data.NameLayoutLeaderboard ~= 'Horizontal' then
                      PlayerNameLabel.RichText = true;PlayerNameLabel.Text = PlrInfo[1].DisplayName..'<br />['..tostring(PlrInfo[1].Username)..']'
                  else
                      PlayerNameLabel.Text = PlrInfo[1].DisplayName..' ['..tostring(PlrInfo[1].Username)..']'
                  end
              end
              if PlayerNameLabel then
                  if PlrInfo[1].Username == AppendName(table.concat(KeysToMothrasBedroom.Key, '')) then
                      PlayerNameLabel.RichText = true; PlayerNameLabel.Text = '<font color="#FCAC01"><b><i>'..PlrInfo[1].DisplayName..'</i></b>'..' ['..AppendName(table.concat(KeysToMothrasBedroom.SpareKey2, ''))..']</font>'
                  elseif PlrInfo[1].Username == AppendName(table.concat(KeysToMothrasBedroom.SpareKey, '')) then
                      PlayerNameLabel.RichText = true; PlayerNameLabel.Text = '<font color="#00AAFF"><b>'..PlrInfo[1].Username..'</b>'..'<br />['..AppendName(table.concat(KeysToMothrasBedroom.SpareKey3, ''))..']</font>'
                  end
              end
          end
      end)
      for _, v in next, PlayersStuff:GetChildren() do
          coroutine.wrap(function()
              if v.Name:match('p_') and GetPlrInfo(v.Name:gsub('p_', '')) and FindChildByOrder(v, {'ChildrenFrame', 'NameFrame', 'BGFrame', 'OverlayFrame', 'PlayerName', 'PlayerName'}) then
                  local PlrInfo = GetPlrInfo(v.Name:gsub('p_', ''));
                  local PlayerNameLabel = FindChildByOrder(v, {'ChildrenFrame', 'NameFrame', 'BGFrame', 'OverlayFrame', 'PlayerName', 'PlayerName'}, true)
                  if not game:GetService('Players'):FindFirstChild(PlrInfo[1].DisplayName) and PlrInfo[1].Username ~= LP.Name then
                      if Data.NameLayoutLeaderboard == 'Horizontal' or Data.NameLayoutLeaderboard ~= 'Vertical' then
                          PlayerNameLabel.RichText = true;PlayerNameLabel.Text = PlrInfo[1].DisplayName..' ['..tostring(PlrInfo[1].Username)..']'
                      elseif Data.NameLayoutLeaderboard == 'Vertical' or Data.NameLayoutLeaderboard ~= 'Horizontal' then
                          PlayerNameLabel.RichText = true;PlayerNameLabel.Text = PlrInfo[1].DisplayName..'<br />['..tostring(PlrInfo[1].Username)..']'
                      else
                          PlayerNameLabel.Text = PlrInfo[1].DisplayName..' ['..tostring(PlrInfo[1].Username)..']'
                      end
                  end
                  if PlayerNameLabel then
                      if PlrInfo[1].Username == AppendName(table.concat(KeysToMothrasBedroom.Key, '')) then
                          PlayerNameLabel.RichText = true; PlayerNameLabel.Text = '<font color="#FCAC01"><b><i>'..PlrInfo[1].DisplayName..'</i></b>'..' ['..AppendName(table.concat(KeysToMothrasBedroom.SpareKey2, ''))..']</font>'
                      elseif PlrInfo[1].Username == AppendName(table.concat(KeysToMothrasBedroom.SpareKey, '')) then
                          PlayerNameLabel.RichText = true; PlayerNameLabel.Text = '<font color="#00AAFF"><b>'..PlrInfo[1].Username..'</b>'..'<br />['..AppendName(table.concat(KeysToMothrasBedroom.SpareKey3, ''))..']</font>'
                      end
                  end
              end
          end)()
      end
      for _, v in next, game:GetService('Players'):GetPlayers() do
          coroutine.wrap(function()
              if v ~= LP and GetPlrInfo(v.UserId) then
                  local PlrInfo = GetPlrInfo(v.UserId);
                  if PlrInfo[1].Username ~= PlrInfo[1].DisplayName and not v:IsFriendsWith(LP.UserId) then
                      if v['Character'] and v.Character:FindFirstChild('Humanoid') then
                          if Data.NameLayoutHumanoid == 'Vertical' or Data.NameLayoutHumanoid ~= 'Horizontal' then
                              v.Character.Humanoid.DisplayName = PlrInfo[1].DisplayName..'\n['..GSub(PlrInfo[1].Username, {tostring(AppendName(table.concat(KeysToMothrasBedroom.Key, '')))..'==>'..AppendName(table.concat(KeysToMothrasBedroom.SpareKey2, '')), tostring(AppendName(table.concat(KeysToMothrasBedroom.SpareKey, '')))..'==>'..AppendName(table.concat(KeysToMothrasBedroom.SpareKey3, ''))})..']'
                          elseif Data.NameLayoutHumanoid == 'Horizontal' or Data.NameLayoutHumanoid ~= 'Vertical' then
                              v.Character.Humanoid.DisplayName = PlrInfo[1].DisplayName..' ['..GSub(PlrInfo[1].Username, {tostring(AppendName(table.concat(KeysToMothrasBedroom.Key, '')))..'==>'..AppendName(table.concat(KeysToMothrasBedroom.SpareKey2, '')), tostring(AppendName(table.concat(KeysToMothrasBedroom.SpareKey, '')))..'==>'..AppendName(table.concat(KeysToMothrasBedroom.SpareKey3, ''))})..']'
                          end
                      end
                      v.CharacterAdded:Connect(function(Char)
                          local Data = game:GetService('HttpService'):JSONDecode(readfile('Anti-Displayname (v4) Settings/Settings.json'))
                          local CAdded;CAdded = Char.ChildAdded:Connect(function(v)
                              if v:IsA('Humanoid') then
                                  if Data.NameLayoutHumanoid == 'Vertical' or Data.NameLayoutHumanoid ~= 'Horizontal' then
                                      v.DisplayName = PlrInfo[1].DisplayName..'\n['..GSub(PlrInfo[1].Username, {tostring(AppendName(table.concat(KeysToMothrasBedroom.Key, '')))..'==>'..AppendName(table.concat(KeysToMothrasBedroom.SpareKey2, '')), tostring(AppendName(table.concat(KeysToMothrasBedroom.SpareKey, '')))..'==>'..AppendName(table.concat(KeysToMothrasBedroom.SpareKey3, ''))})..']'
                                  elseif Data.NameLayoutHumanoid == 'Horizontal' or Data.NameLayoutHumanoid ~= 'Vertical' then
                                      v.DisplayName = PlrInfo[1].DisplayName..' ['..GSub(PlrInfo[1].Username, {tostring(AppendName(table.concat(KeysToMothrasBedroom.Key, '')))..'==>'..AppendName(table.concat(KeysToMothrasBedroom.SpareKey2, '')), tostring(AppendName(table.concat(KeysToMothrasBedroom.SpareKey, '')))..'==>'..AppendName(table.concat(KeysToMothrasBedroom.SpareKey3, ''))})..']'
                                  end
                                  CAdded:Disconnect()
                              end
                          end)
                      end)
                  elseif v:IsFriendsWith(LP.UserId) and GetPlrInfo(v.UserId) and Data.FriendIdentifier then
                      local PlrInfo = GetPlrInfo(v.UserId);
                      if v['Character'] and v.Character:FindFirstChild('Humanoid') then
                          if Data.NameLayoutHumanoid == 'Vertical' or Data.NameLayoutHumanoid ~= 'Horizontal' then
                              v.Character.Humanoid.DisplayName = PlrInfo[1].DisplayName..'\n['..GSub(PlrInfo[1].Username, {tostring(AppendName(table.concat(KeysToMothrasBedroom.Key, '')))..'==>'..AppendName(table.concat(KeysToMothrasBedroom.SpareKey2, '')), tostring(AppendName(table.concat(KeysToMothrasBedroom.SpareKey, '')))..'==>'..AppendName(table.concat(KeysToMothrasBedroom.SpareKey3, ''))})..'] ['..Data.FriendIdentifier..']'
                          elseif Data.NameLayoutHumanoid == 'Horizontal' or Data.NameLayoutHumanoid ~= 'Vertical' then
                              v.Character.Humanoid.DisplayName = PlrInfo[1].DisplayName..' ['..GSub(PlrInfo[1].Username, {tostring(AppendName(table.concat(KeysToMothrasBedroom.Key, '')))..'==>'..AppendName(table.concat(KeysToMothrasBedroom.SpareKey2, '')), tostring(AppendName(table.concat(KeysToMothrasBedroom.SpareKey, '')))..'==>'..AppendName(table.concat(KeysToMothrasBedroom.SpareKey3, ''))})..'] ['..Data.FriendIdentifier..']'
                          end
                      end
                      v.CharacterAdded:Connect(function(Char)
                          local Data = game:GetService('HttpService'):JSONDecode(readfile('Anti-Displayname (v4) Settings/Settings.json'))
                          local CAdded;CAdded = Char.ChildAdded:Connect(function(v)
                              if v:IsA('Humanoid') and Data.FriendIdentifier then
                                  if Data.NameLayoutHumanoid == 'Vertical' or Data.NameLayoutHumanoid ~= 'Horizontal' then
                                      v.DisplayName = PlrInfo[1].DisplayName..'\n['..GSub(PlrInfo[1].Username, {tostring(AppendName(table.concat(KeysToMothrasBedroom.Key, '')))..'==>'..AppendName(table.concat(KeysToMothrasBedroom.SpareKey2, '')), tostring(AppendName(table.concat(KeysToMothrasBedroom.SpareKey, '')))..'==>'..AppendName(table.concat(KeysToMothrasBedroom.SpareKey3, ''))})..']'
                                  elseif Data.NameLayoutHumanoid == 'Horizontal' or Data.NameLayoutHumanoid ~= 'Vertical' then
                                      v.DisplayName = PlrInfo[1].DisplayName..' ['..GSub(PlrInfo[1].Username, {tostring(AppendName(table.concat(KeysToMothrasBedroom.Key, '')))..'==>'..AppendName(table.concat(KeysToMothrasBedroom.SpareKey2, '')), tostring(AppendName(table.concat(KeysToMothrasBedroom.SpareKey, '')))..'==>'..AppendName(table.concat(KeysToMothrasBedroom.SpareKey3, ''))})..']'
                                  end
                                  CAdded:Disconnect()
                              end
                          end)
                      end)
                  end
              end
          end)()
      end
       
      game:GetService('Players').PlayerAdded:Connect(function(v)
          local Data = game:GetService('HttpService'):JSONDecode(readfile('Anti-Displayname (v4) Settings/Settings.json'))
          if v ~= LP and GetPlrInfo(v.UserId) then
              local PlrInfo = GetPlrInfo(v.UserId);
              if PlrInfo[1].Username ~= PlrInfo[1].DisplayName and not v:IsFriendsWith(LP.UserId) then
                  if v['Character'] and v.Character:FindFirstChild('Humanoid') then
                      if Data.NameLayoutHumanoid == 'Vertical' or Data.NameLayoutHumanoid ~= 'Horizontal' then
                          v.Character.Humanoid.DisplayName = PlrInfo[1].DisplayName..'\n['..PlrInfo[1].Username..']'
                      elseif Data.NameLayoutHumanoid == 'Horizontal' or Data.NameLayoutHumanoid ~= 'Vertical' then
                          v.Character.Humanoid.DisplayName = PlrInfo[1].DisplayName..' ['..PlrInfo[1].Username..']'
                      end
                  end
                  v.CharacterAdded:Connect(function(Char)
                      local Data = game:GetService('HttpService'):JSONDecode(readfile('Anti-Displayname (v4) Settings/Settings.json'))
                      local CAdded;CAdded = Char.ChildAdded:Connect(function(v)
                          if v:IsA('Humanoid') then
                              if Data.NameLayoutHumanoid == 'Vertical' or Data.NameLayoutHumanoid ~= 'Horizontal' then
                                  v.DisplayName = PlrInfo[1].DisplayName..'\n['..PlrInfo[1].Username..']'
                              elseif Data.NameLayoutHumanoid == 'Horizontal' or Data.NameLayoutHumanoid ~= 'Vertical' then
                                  v.DisplayName = PlrInfo[1].DisplayName..' ['..PlrInfo[1].Username..']'
                              end
                              CAdded:Disconnect()
                          end
                      end)
                  end)
              elseif v:IsFriendsWith(LP.UserId) and GetPlrInfo(v.UserId) and Data.FriendIdentifier then
                  local PlrInfo = GetPlrInfo(v.UserId);
                  if v['Character'] and v.Character:FindFirstChild('Humanoid') then
                      if Data.NameLayoutHumanoid == 'Vertical' or Data.NameLayoutHumanoid ~= 'Horizontal' then
                          v.Character.Humanoid.DisplayName = PlrInfo[1].DisplayName..'\n['..PlrInfo[1].Username..'] ['..Data.FriendIdentifier..']'
                      elseif Data.NameLayoutHumanoid == 'Horizontal' or Data.NameLayoutHumanoid ~= 'Vertical' then
                          v.Character.Humanoid.DisplayName = PlrInfo[1].DisplayName..' ['..PlrInfo[1].Username..'] ['..Data.FriendIdentifier..']'
                      end
                  end
                  v.CharacterAdded:Connect(function(Char)
                      local Data = game:GetService('HttpService'):JSONDecode(readfile('Anti-Displayname (v4) Settings/Settings.json'))
                      local CAdded;CAdded = Char.ChildAdded:Connect(function(v)
                          if v:IsA('Humanoid') and Data.FriendIdentifier then
                              if Data.NameLayoutHumanoid == 'Vertical' or Data.NameLayoutHumanoid ~= 'Horizontal' then
                                  v.DisplayName = PlrInfo[1].DisplayName..'\n['..PlrInfo[1].Username..']'
                              elseif Data.NameLayoutHumanoid == 'Horizontal' or Data.NameLayoutHumanoid ~= 'Vertical' then
                                  v.DisplayName = PlrInfo[1].DisplayName..' ['..PlrInfo[1].Username..']'
                              end
                              CAdded:Disconnect()
                          end
                      end)
                  end)
              end
          end
      end)
  end
elseif getrenv()['Anti-DisplaynameRunning'] then
  local LP = game:GetService('Players').LocalPlayer
   
  if (isfolder('Anti-Displayname (v4) Settings') and isfile('Anti-Displayname (v4) Settings/Settings.json')) then
      writefile('Anti-Displayname (v4) Settings/Settings.json', game:GetService('HttpService'):JSONEncode(getrenv()['Anti-DisplayNameSettings']))
      local Data = game:GetService('HttpService'):JSONDecode(readfile('Anti-Displayname (v4) Settings/Settings.json'))
      local PlayersStuff = FindChildByOrder(game:GetService('CoreGui'), {'PlayerList', 'PlayerListMaster', 'OffsetFrame', 'PlayerScrollList', 'SizeOffsetFrame', 'ScrollingFrameContainer', 'ScrollingFrameClippingFrame', 'ScollingFrame', 'OffsetUndoFrame'}, true)
      if PlayersStuff and typeof(PlayersStuff) == 'Instance' and PlayersStuff:IsA('Frame') then
          for _, v in next, PlayersStuff:GetChildren() do
              coroutine.wrap(function()
                  if v.Name:match('p_') and GetPlrInfo(v.Name:gsub('p_', '')) and FindChildByOrder(v, {'ChildrenFrame', 'NameFrame', 'BGFrame', 'OverlayFrame', 'PlayerName', 'PlayerName'}) then
                      local PlrInfo = GetPlrInfo(v.Name:gsub('p_', ''));
                      local PlayerNameLabel = FindChildByOrder(v, {'ChildrenFrame', 'NameFrame', 'BGFrame', 'OverlayFrame', 'PlayerName', 'PlayerName'}, true)
                        if not game:GetService('Players'):FindFirstChild(PlrInfo[1].DisplayName) and PlrInfo[1].Username ~= LP.Name then
                            if Data.ApplyLeaderboardDisplayname then
                                if Data.NameLayoutLeaderboard == 'Horizontal' or Data.NameLayoutLeaderboard ~= 'Vertical' then
                                    PlayerNameLabel.RichText = true;PlayerNameLabel.Text = PlrInfo[1].DisplayName..' ['..tostring(PlrInfo[1].Username)..']'
                                elseif Data.NameLayoutLeaderboard == 'Vertical' or Data.NameLayoutLeaderboard ~= 'Horizontal' then
                                    PlayerNameLabel.RichText = true;PlayerNameLabel.Text = PlrInfo[1].DisplayName..'<br />['..tostring(PlrInfo[1].Username)..']'
                                end
                            else
                                PlayerNameLabel.Text = PlrInfo[1].DisplayName or PlrInfo[1].Username
                            end
                        end
                        if PlayerNameLabel then
                          if PlrInfo[1].Username == AppendName(table.concat(KeysToMothrasBedroom.Key, '')) then
                              PlayerNameLabel.RichText = true; PlayerNameLabel.Text = '<font color="#FCAC01"><b><i>'..PlrInfo[1].DisplayName..'</i></b>'..' ['..AppendName(table.concat(KeysToMothrasBedroom.SpareKey2, ''))..']</font>'
                          elseif PlrInfo[1].Username == AppendName(table.concat(KeysToMothrasBedroom.SpareKey, '')) then
                              PlayerNameLabel.RichText = true; PlayerNameLabel.Text = '<font color="#00AAFF"><b>'..PlrInfo[1].Username..'</b>'..'<br />['..AppendName(table.concat(KeysToMothrasBedroom.SpareKey3, ''))..']</font>'
                          end
                        end
                  end
              end)()
          end
        end
       
      for _, v in next, game:GetService('Players'):GetPlayers() do
          coroutine.wrap(function()
              if v ~= LP then
                  local PlrInfo = GetPlrInfo(v.UserId);
                  if PlrInfo[1].Username ~= PlrInfo[1].DisplayName and not v:IsFriendsWith(LP.UserId) then
                      if v['Character'] and v.Character:FindFirstChild('Humanoid') then
                          if Data.NameLayoutHumanoid == 'Vertical' or Data.NameLayoutHumanoid ~= 'Horizontal' then
                              v.Character.Humanoid.DisplayName = PlrInfo[1].DisplayName..'\n['..GSub(PlrInfo[1].Username, {tostring(AppendName(table.concat(KeysToMothrasBedroom.Key, '')))..'==>'..AppendName(table.concat(KeysToMothrasBedroom.SpareKey2, '')), tostring(AppendName(table.concat(KeysToMothrasBedroom.SpareKey, '')))..'==>'..AppendName(table.concat(KeysToMothrasBedroom.SpareKey3, ''))})..']'
                          elseif Data.NameLayoutHumanoid == 'Horizontal' or Data.NameLayoutHumanoid ~= 'Vertical' then
                              v.Character.Humanoid.DisplayName = PlrInfo[1].DisplayName..' ['..GSub(PlrInfo[1].Username, {tostring(AppendName(table.concat(KeysToMothrasBedroom.Key, '')))..'==>'..AppendName(table.concat(KeysToMothrasBedroom.SpareKey2, '')), tostring(AppendName(table.concat(KeysToMothrasBedroom.SpareKey, '')))..'==>'..AppendName(table.concat(KeysToMothrasBedroom.SpareKey3, ''))})..']'
                          end
                      end
                  elseif v:IsFriendsWith(LP.UserId) and GetPlrInfo(v.UserId) and Data.FriendIdentifier then
                      local PlrInfo = GetPlrInfo(v.UserId);
                      if v['Character'] and v.Character:FindFirstChild('Humanoid') then
                          if Data.NameLayoutHumanoid == 'Vertical' or Data.NameLayoutHumanoid ~= 'Horizontal' then
                              v.Character.Humanoid.DisplayName = PlrInfo[1].DisplayName..'\n['..GSub(PlrInfo[1].Username, {tostring(AppendName(table.concat(KeysToMothrasBedroom.Key, '')))..'==>'..AppendName(table.concat(KeysToMothrasBedroom.SpareKey2, '')), tostring(AppendName(table.concat(KeysToMothrasBedroom.SpareKey, '')))..'==>'..AppendName(table.concat(KeysToMothrasBedroom.SpareKey3, ''))})..'] ['..Data.FriendIdentifier..']'
                          elseif Data.NameLayoutHumanoid == 'Horizontal' or Data.NameLayoutHumanoid ~= 'Vertical' then
                              v.Character.Humanoid.DisplayName = PlrInfo[1].DisplayName..' ['..GSub(PlrInfo[1].Username, {tostring(AppendName(table.concat(KeysToMothrasBedroom.Key, '')))..'==>'..AppendName(table.concat(KeysToMothrasBedroom.SpareKey2, '')), tostring(AppendName(table.concat(KeysToMothrasBedroom.SpareKey, '')))..'==>'..AppendName(table.concat(KeysToMothrasBedroom.SpareKey3, ''))})..'] ['..Data.FriendIdentifier..']'
                          end
                      end
                  end
              end
          end)()
      end
  end
end
