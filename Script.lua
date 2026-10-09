n),0,1,0)
    fill.BackgroundColor3 = Color3.fromRGB(130,80,240)
    fill.BorderSizePixel = 0
    fill.Active = false
    fill.Parent = bar
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)

    local dr = false
    local function upd(inp)
        local bx = bar.AbsolutePosition.X
        local bw = bar.AbsoluteSize.X
        if bw <= 0 then return end
        local r = math.clamp((inp.Position.X - bx) / bw, 0, 1)
        local v = math.floor(mn + r * (mx - mn))
        fill.Size = UDim2.new(r, 0, 1, 0)
        val.Text = tostring(v)
        cb(v)
    end
    bar.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dr = true; upd(inp)
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if dr and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then upd(inp) end
    end)
    UIS.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then dr = false end
    end)
end

local function Button(txt, ord, col, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,0,0,40)
    b.BackgroundColor3 = col
    b.Text = txt
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.AutoButtonColor = false
    b.LayoutOrder = ord
    b.Parent = Cont
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    b.MouseButton1Click:Connect(cb)
end

local function ColorRow(ord)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,0,0,44)
    f.BackgroundColor3 = Color3.fromRGB(30,26,44)
    f.LayoutOrder = ord
    f.Parent = Cont
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,8)
    local colors = {
        Color3.fromRGB(255,50,50),
        Color3.fromRGB(50,255,80),
        Color3.fromRGB(80,150,255),
        Color3.fromRGB(255,220,50),
        Color3.fromRGB(255,80,200),
        Color3.fromRGB(255,255,255)
    }
    for i, c in ipairs(colors) do
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0.15, -4, 0, 32)
        b.Position = UDim2.new((i-1)*0.16, 10, 0, 6)
        b.BackgroundColor3 = c
        b.Text = ""
        b.AutoButtonColor = false
        b.Parent = f
        Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
        b.MouseButton1Click:Connect(function() S.hbColor = c end)
    end
end

-- CONTENT
Section("АИМБОТ", 1)
Toggle("Аимбот", 2, false, function(s) S.aim = s end)
Slider("Плавность", 3, 1, 100, 20, function(v) S.smooth = v/100 end)
Slider("Радиус ФОВ", 4, 30, 500, 150, function(v) S.fov = v end)

Section("ИГРОК", 5)
Toggle("Невидимость", 6, false, function(s) S.invis = s; setInvis(s) end)
Toggle("Полёт", 7, false, function(s) S.fly = s; setFly(s) end)
Slider("Скорость полёта", 8, 10, 300, 50, function(v) S.flySpeed = v end)

Section("ESP", 9)
Toggle("ESP (обводка)", 10, false, function(s) S.esp = s; updateESP() end)

Section("ХИТБОКСЫ", 11)
Toggle("Увеличитель хитбоксов", 12, false, function(s) S.hitbox = s; setHitbox(s) end)
Slider("Размер хитбокса", 13, 1, 100, 2, function(v) S.hbSize = v; if S.hitbox then applyHB() end end)
Toggle("Показать хитбоксы", 14, false, function(s) S.showHB = s end)
ColorRow(15)

Section("ДЕЙСТВИЯ", 16)
Button("УБИТЬ ВСЕХ", 17, Color3.fromRGB(150,40,70), killAll)

Section("МЕНЮ", 18)
Button("ЗАКРЫТЬ МЕНЮ", 19, Color3.fromRGB(60,60,70), function()
    S.aim=false; S.invis=false; S.fly=false; S.esp=false; S.hitbox=false; S.showHB=false
    setInvis(false); setFly(false); setHitbox(false)
    for _, h in pairs(espCache) do h:Destroy() end
    for _, b in pairs(hbVisuals) do b:Destroy() end
    visFolder:Destroy()
    Gui:Destroy()
end)

-- MINIMIZE
local min = false
local origSize = Win.Size
MB.MouseButton1Click:Connect(function()
    min = not min
    if min then
        Cont.Visible = false
        Win.Size = UDim2.new(0, 320, 0, 42)
    else
        Cont.Visible = true
        Win.Size = or
