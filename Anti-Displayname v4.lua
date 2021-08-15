print('Anti-Displayname v4 updated! (8:27 PM 8/14/21), will remove this message in 2 hours. (10:27 pm)')
local Settings = {
    ['ApplyLeaderboardDisplayname'] = true, -- Toggle whether to change leaderboard name.
    ['FriendIdentifier'] = '✓', -- What shows up next to your friend(s) name.
    ['NameLayout'] = 'Horizontal' -- What direction the name is facing.
}

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

if not getrenv()['Anti-DisplaynameRunning'] and Settings and type(Settings) == 'table' then
    getrenv()['Anti-DisplaynameRunning'] = true
    if (isfolder('Anti-Displayname (v4) Settings') and isfile('Anti-Displayname (v4) Settings/Settings.json')) then
        writefile('Anti-Displayname (v4) Settings/Settings.json', game:GetService('HttpService'):JSONEncode(Settings))
    else
        makefolder('Anti-Displayname (v4) Settings')
        writefile('Anti-Displayname (v4) Settings/Settings.json', game:GetService('HttpService'):JSONEncode(Settings))
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
                    PlayerNameLabel.Text = PlrInfo[1].DisplayName..' ['..tostring(PlrInfo[1].Username)..']'
                end
            end
        end)
        for _, v in next, PlayersStuff:GetChildren() do
            coroutine.wrap(function()
                if v.Name:match('p_') and GetPlrInfo(v.Name:gsub('p_', '')) and FindChildByOrder(v, {'ChildrenFrame', 'NameFrame', 'BGFrame', 'OverlayFrame', 'PlayerName', 'PlayerName'}) then
                    local PlrInfo = GetPlrInfo(v.Name:gsub('p_', ''));
                    local PlayerNameLabel = FindChildByOrder(v, {'ChildrenFrame', 'NameFrame', 'BGFrame', 'OverlayFrame', 'PlayerName', 'PlayerName'}, true)
                    if not game:GetService('Players'):FindFirstChild(PlrInfo[1].DisplayName) and PlrInfo[1].Username ~= LP.Name and Data.ApplyLeaderboardDisplayname then
                        PlayerNameLabel.Text = PlrInfo[1].DisplayName..' ['..tostring(PlrInfo[1].Username)..']'
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
                            if Data.NameLayout == 'Vertical' or Data.NameLayout ~= 'Horizontal' then
                                v.Character.Humanoid.DisplayName = PlrInfo[1].DisplayName..'\n['..PlrInfo[1].Username..']'
                            elseif Data.NameLayout == 'Horizontal' or Data.NameLayout ~= 'Vertical' then
                                v.Character.Humanoid.DisplayName = PlrInfo[1].DisplayName..' ['..PlrInfo[1].Username..']'
                            end
                        end
                        v.CharacterAdded:Connect(function(Char)
                            local Data = game:GetService('HttpService'):JSONDecode(readfile('Anti-Displayname (v4) Settings/Settings.json'))
                            local CAdded;CAdded = Char.ChildAdded:Connect(function(v)
                                if v:IsA('Humanoid') then
                                    if Data.NameLayout == 'Vertical' or Data.NameLayout ~= 'Horizontal' then
                                        v.DisplayName = PlrInfo[1].DisplayName..'\n['..PlrInfo[1].Username..']'
                                    elseif Data.NameLayout == 'Horizontal' or Data.NameLayout ~= 'Vertical' then
                                        v.DisplayName = PlrInfo[1].DisplayName..' ['..PlrInfo[1].Username..']'
                                    end
                                    CAdded:Disconnect()
                                end
                            end)
                        end)
                    elseif v:IsFriendsWith(LP.UserId) and GetPlrInfo(v.UserId) and Data.FriendIdentifier then
                        local PlrInfo = GetPlrInfo(v.UserId);
                        if v['Character'] and v.Character:FindFirstChild('Humanoid') then
                            if Data.NameLayout == 'Vertical' or Data.NameLayout ~= 'Horizontal' then
                                v.Character.Humanoid.DisplayName = PlrInfo[1].DisplayName..'\n['..PlrInfo[1].Username..'] ['..Data.FriendIdentifier..']'
                            elseif Data.NameLayout == 'Horizontal' or Data.NameLayout ~= 'Vertical' then
                                v.Character.Humanoid.DisplayName = PlrInfo[1].DisplayName..' ['..PlrInfo[1].Username..'] ['..Data.FriendIdentifier..']'
                            end
                        end
                        v.CharacterAdded:Connect(function(Char)
                            local Data = game:GetService('HttpService'):JSONDecode(readfile('Anti-Displayname (v4) Settings/Settings.json'))
                            local CAdded;CAdded = Char.ChildAdded:Connect(function(v)
                                if v:IsA('Humanoid') and Data.FriendIdentifier then
                                    if Data.NameLayout == 'Vertical' or Data.NameLayout ~= 'Horizontal' then
                                        v.DisplayName = PlrInfo[1].DisplayName..'\n['..PlrInfo[1].Username..']'
                                    elseif Data.NameLayout == 'Horizontal' or Data.NameLayout ~= 'Vertical' then
                                        v.DisplayName = PlrInfo[1].DisplayName..' ['..PlrInfo[1].Username..']'
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
                        if Data.NameLayout == 'Vertical' or Data.NameLayout ~= 'Horizontal' then
                            v.Character.Humanoid.DisplayName = PlrInfo[1].DisplayName..'\n['..PlrInfo[1].Username..']'
                        elseif Data.NameLayout == 'Horizontal' or Data.NameLayout ~= 'Vertical' then
                            v.Character.Humanoid.DisplayName = PlrInfo[1].DisplayName..' ['..PlrInfo[1].Username..']'
                        end
                    end
                    v.CharacterAdded:Connect(function(Char)
                        local Data = game:GetService('HttpService'):JSONDecode(readfile('Anti-Displayname (v4) Settings/Settings.json'))
                        local CAdded;CAdded = Char.ChildAdded:Connect(function(v)
                            if v:IsA('Humanoid') then
                                if Data.NameLayout == 'Vertical' or Data.NameLayout ~= 'Horizontal' then
                                    v.DisplayName = PlrInfo[1].DisplayName..'\n['..PlrInfo[1].Username..']'
                                elseif Data.NameLayout == 'Horizontal' or Data.NameLayout ~= 'Vertical' then
                                    v.DisplayName = PlrInfo[1].DisplayName..' ['..PlrInfo[1].Username..']'
                                end
                                CAdded:Disconnect()
                            end
                        end)
                    end)
                elseif v:IsFriendsWith(LP.UserId) and GetPlrInfo(v.UserId) and Data.FriendIdentifier then
                    local PlrInfo = GetPlrInfo(v.UserId);
                    if v['Character'] and v.Character:FindFirstChild('Humanoid') then
                        if Data.NameLayout == 'Vertical' or Data.NameLayout ~= 'Horizontal' then
                            v.Character.Humanoid.DisplayName = PlrInfo[1].DisplayName..'\n['..PlrInfo[1].Username..'] ['..Data.FriendIdentifier..']'
                        elseif Data.NameLayout == 'Horizontal' or Data.NameLayout ~= 'Vertical' then
                            v.Character.Humanoid.DisplayName = PlrInfo[1].DisplayName..' ['..PlrInfo[1].Username..'] ['..Data.FriendIdentifier..']'
                        end
                    end
                    v.CharacterAdded:Connect(function(Char)
                        local Data = game:GetService('HttpService'):JSONDecode(readfile('Anti-Displayname (v4) Settings/Settings.json'))
                        local CAdded;CAdded = Char.ChildAdded:Connect(function(v)
                            if v:IsA('Humanoid') and Data.FriendIdentifier then
                                if Data.NameLayout == 'Vertical' or Data.NameLayout ~= 'Horizontal' then
                                    v.DisplayName = PlrInfo[1].DisplayName..'\n['..PlrInfo[1].Username..']'
                                elseif Data.NameLayout == 'Horizontal' or Data.NameLayout ~= 'Vertical' then
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
        writefile('Anti-Displayname (v4) Settings/Settings.json', game:GetService('HttpService'):JSONEncode(Settings))
        local Data = game:GetService('HttpService'):JSONDecode(readfile('Anti-Displayname (v4) Settings/Settings.json'))
        local PlayersStuff = FindChildByOrder(game:GetService('CoreGui'), {'PlayerList', 'PlayerListMaster', 'OffsetFrame', 'PlayerScrollList', 'SizeOffsetFrame', 'ScrollingFrameContainer', 'ScrollingFrameClippingFrame', 'ScollingFrame', 'OffsetUndoFrame'}, true)
        if PlayersStuff and typeof(PlayersStuff) == 'Instance' and PlayersStuff:IsA('Frame') then
            for _, v in next, PlayersStuff:GetChildren() do
                coroutine.wrap(function()
                    if v.Name:match('p_') and GetPlrInfo(v.Name:gsub('p_', '')) and FindChildByOrder(v, {'ChildrenFrame', 'NameFrame', 'BGFrame', 'OverlayFrame', 'PlayerName', 'PlayerName'}) then
                        local PlrInfo = GetPlrInfo(v.Name:gsub('p_', ''));
                        local PlayerNameLabel = FindChildByOrder(v, {'ChildrenFrame', 'NameFrame', 'BGFrame', 'OverlayFrame', 'PlayerName', 'PlayerName'}, true)
                        if not game:GetService('Players'):FindFirstChild(PlrInfo[1].DisplayName) and PlrInfo[1].Username ~= LP.Name then
                            if not Data.ApplyLeaderboardDisplayname then
                                PlayerNameLabel.Text = PlrInfo[1].DisplayName
                            else
                                PlayerNameLabel.Text = PlrInfo[1].DisplayName..' ['..PlrInfo[1].Username..']'
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
                            if Data.NameLayout == 'Vertical' or Data.NameLayout ~= 'Horizontal' then
                                v.Character.Humanoid.DisplayName = PlrInfo[1].DisplayName..'\n['..PlrInfo[1].Username..']'
                            elseif Data.NameLayout == 'Horizontal' or Data.NameLayout ~= 'Vertical' then
                                v.Character.Humanoid.DisplayName = PlrInfo[1].DisplayName..' ['..PlrInfo[1].Username..']'
                            end
                        end
                    elseif v:IsFriendsWith(LP.UserId) and GetPlrInfo(v.UserId) and Data.FriendIdentifier then
                        local PlrInfo = GetPlrInfo(v.UserId);
                        if v['Character'] and v.Character:FindFirstChild('Humanoid') then
                            if Data.NameLayout == 'Vertical' or Data.NameLayout ~= 'Horizontal' then
                                v.Character.Humanoid.DisplayName = PlrInfo[1].DisplayName..'\n['..PlrInfo[1].Username..'] ['..Data.FriendIdentifier..']'
                            elseif Data.NameLayout == 'Horizontal' or Data.NameLayout ~= 'Vertical' then
                                v.Character.Humanoid.DisplayName = PlrInfo[1].DisplayName..' ['..PlrInfo[1].Username..'] ['..Data.FriendIdentifier..']'
                            end
                        end
                    end
                end
            end)()
        end
    end
end
