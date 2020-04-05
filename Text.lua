Text = {
    text,
    x,
    y,
    size,
    letterSpacing,
    red,
    green,
    blue,
    alpha,
    boxs
}

Temp = {}

function Text:new(_text,_x,_y)
    object = {}
    setmetatable(object, self)
    Text.__index = self
    object.text = _text
    object.x = _x
    object.y = _y
    object.size = 4
    object.letterSpacing = 24
    object.red = 255
    object.green = 255
    object.blue = 255
    object.alpha = 255
    object.boxs = {}
    return object
end

function Text:clean()
    for i=1,#Temp do
        if(Temp[i] == self.boxs) then 
            table.remove(Temp,i)
            break
        end
    end
    for i=1,#self.boxs do
        self.boxs[i]:Hide()
        self.boxs[i] = nil
    end
end

function Text:show()
    for i=1,#self.boxs do
        if(self.boxs[i]~=nil) then
            self.boxs[i]:Show()
        end
    end
end

function Text:hide()
    for i=1,#self.boxs do
        if(self.boxs[i]~=nil) then
            self.boxs[i]:Hide()
        end
    end
end

function Text:setText(_text)
    self.text = _text
    self:clean()
    self:print()
end

function Text:translate(_x,_y)
    self.x = self.x+_x
    self.y = self.x+_y

    if self.boxs ~= nil then
        for i = 1,#self.boxs do
            self.boxs[i]:Set({x = self.boxs[i]:Get().x + _x, y = self.boxs[i]:Get().y + _y})
        end
    end
end

function Text:setColor(_r,_g,_b,_a)
    self.red = _r
    self.green = _g
    self.blue = _b
    self.alpha = _a
    if self.boxs ~= nil then
        for i = 1,#self.boxs do
            self.boxs[i]:Set({r = self.red, g = self.green, b = self.blue, a = self.alpha})
        end
    end
end

function Text:setSize(_size,_letterSpacing)
    self.size = _size
    self.letterSpacing = _letterSpacing
    if self.boxs ~= nil then
        for i = 1,#self.boxs do
            self.boxs[i]:Set({x =i *self.letterSpacing + self.x + x1*self.size, y = self.y - y1*self.size, width = (x2 -x1)*self.size, height = (y2-y1)*-self.size})
        end
    end
end

function Text:print()
    if(#self.boxs == 0) then 
        self.text = string.lower(self.text)
        length = SubStringGetTotalIndex(self.text)
        for i=1,length do
            char = SubStringUTF8(self.text,i,i)
            if(Font[char] ~= nil) then
                for j=1,#Font[char] do
                    x1 = Font[char][j][1]
                    y1 = Font[char][j][2]
                    x2 = Font[char][j][3]
                    y2 = Font[char][j][4]
                    box = UI.Box.Create() 
                    box:Set({x =i *self.letterSpacing + self.x + x1*self.size, y = self.y - y1*self.size , width = (x2 -x1)*self.size, height = (y2-y1)*-self.size, r = self.red, g = self.green, b = self.blue, a = self.alpha})
                    table.insert(self.boxs,box)
                end 
                table.insert(Temp,self.boxs)
            end
        end
    end
end

function SubStringUTF8(str, startIndex, endIndex)
    if startIndex < 0 then
        startIndex = SubStringGetTotalIndex(str) + startIndex + 1;
    end

    if endIndex ~= nil and endIndex < 0 then
        endIndex = SubStringGetTotalIndex(str) + endIndex + 1;
    end

    if endIndex == nil then 
        return string.sub(str, SubStringGetTrueIndex(str, startIndex));
    else
        return string.sub(str, SubStringGetTrueIndex(str, startIndex), SubStringGetTrueIndex(str, endIndex + 1) - 1);
    end
end

function SubStringGetTotalIndex(str)
    local curIndex = 0;
    local i = 1;
    local lastCount = 1;
    repeat 
        lastCount = SubStringGetByteCount(str, i)
        i = i + lastCount;
        curIndex = curIndex + 1;
    until(lastCount == 0);
    return curIndex - 1;
end

function SubStringGetTrueIndex(str, index)
    local curIndex = 0;
    local i = 1;
    local lastCount = 1;
    repeat 
        lastCount = SubStringGetByteCount(str, i)
        i = i + lastCount;
        curIndex = curIndex + 1;
    until(curIndex >= index);
    return i - lastCount;
end

function SubStringGetByteCount(str, index)
    local curByte = string.byte(str, index)
    local byteCount = 1;
    if curByte == nil then
        byteCount = 0
    elseif curByte > 0 and curByte <= 127 then
        byteCount = 1
    elseif curByte>=192 and curByte<=223 then
        byteCount = 2
    elseif curByte>=224 and curByte<=239 then
        byteCount = 3
    elseif curByte>=240 and curByte<=247 then
        byteCount = 4
    end
    return byteCount;
end
Font = {}
Font["a"] = {
	{0,0,1,4},
	{2,0,3,4},
	{1,1,2,2},
    {1,4,2,5},
}
Font["b"] = {
	{0,0,1,5},
	{1,0,2,1},
	{1,2,2,3},
    {1,4,2,5},
    {2,1,3,2},
    {2,3,3,4},
};
Font["c"] = {
	{0,1,1,4},
	{1,0,3,1},
	{1,4,3,5},
};
Font["d"] = {
	{0,0,1,5},
	{1,0,2,1},
    {1,4,2,5},
    {2,1,3,4},
};
Font["e"] = {
	{0,1,1,4},
	{1,0,3,1},
    {1,2,3,3},
    {1,4,3,5},
};
Font["f"] = {
	{0,0,1,4},
	{1,2,3,3},
    {1,4,3,5},
};
Font["g"] = {
	{0,1,1,4},
	{1,0,2,1},
    {2,0,3,3},
    {1,4,3,5},
};
Font["h"] = {
	{0,0,1,5},
	{2,0,3,5},
    {1,2,2,3},
};
Font["i"] = {
    {1,0,2,5},
};
Font["j"] = {
    {0,1,1,3},
    {1,0,2,1},
    {2,1,3,5},
};
Font["k"] = {
    {0,0,1,5},
    {2,0,3,2},
    {2,3,3,5},
    {1,2,2,3},
};
Font["l"] = {
    {0,1,1,5},
    {1,0,3,1},
};
Font["m"] = {
    {0,0,1,5},
	{2,0,3,5},
    {1,3,2,4},
};
Font["n"] = {
    {0,0,1,5},
    {1,4,2,5},
    {2,0,3,4},
};
Font["o"] = {
    {0,1,1,4},
    {2,1,3,4},
    {1,0,2,1},
    {1,4,2,5},
}
Font["p"] = {
    {0,0,1,4},
    {1,1,2,2},
    {1,4,2,5},
    {2,2,3,4},
}
Font["q"] = {
    {0,2,1,4},
    {2,2,3,4},
    {1,0,2,2},
    {1,4,2,5},
}
Font["r"] = {
    {0,0,1,4},
    {1,1,2,2},
    {1,4,2,5},
    {2,2,3,4},
    {2,0,3,1},
}
Font["s"] = {
    {0,0,2,1},
    {2,1,3,2},
    {1,2,2,3},
    {0,3,1,4},
    {1,4,3,5},
}
Font["t"] = {
    {0,4,3,5},
    {1,0,2,4},
}
Font["u"] = {
    {0,0,1,5},
    {1,0,2,1},
    {2,1,3,5},
}
Font["v"] = {
    {0,1,1,5},
    {1,0,2,1},
    {2,1,3,5},
}
Font["w"] = {
    {0,0,1,5},
	{2,0,3,5},
    {1,1,2,2},
}
Font["x"] = {
    {0,0,1,2},
	{0,3,1,5},
    {2,0,3,2},
    {2,3,3,5},
    {1,2,2,3},
}
Font["y"] = {
    {0,3,1,5},
    {2,3,3,5},
    {1,0,2,3},
}
Font["z"] = {
    {0,0,3,1},
    {0,4,3,5},
    {0,1,1,2},
    {1,2,2,3},
    {2,3,3,4},
}
Font["0"] = {
    {0,0,1,5},
    {2,0,3,5},
    {1,0,2,1},
    {1,4,2,5},
}
Font["1"] = {
    {1,0,2,5},
    {0,3,1,4},
}
Font["2"] = {
    {0,0,1,3},
    {2,2,3,5},
    {1,0,3,1},
    {1,2,2,3},
    {0,4,2,5},
}
Font["3"] = {
    {2,0,3,5},
    {0,0,2,1},
    {0,2,2,3},
    {0,4,2,5},
}
Font["4"] = {
    {0,2,1,5},
	{2,0,3,5},
    {1,2,2,3},
}
Font["5"] = {
    {0,2,1,5},
	{0,0,3,1},
    {1,2,3,3},
    {1,4,3,5},
    {2,1,3,2},
}
Font["6"] = {
    {0,0,1,5},
	{1,0,3,1},
    {1,2,3,3},
    {1,4,3,5},
    {2,1,3,2},
}
Font["7"] = {
    {0,4,3,5},
    {2,0,3,4},
}
Font["8"] = {
    {0,0,1,5},
    {2,0,3,5},
    {1,0,2,1},
    {1,2,2,3},
    {1,4,2,5},
}
Font["9"] = {
    {0,0,3,1},
    {2,1,3,5},
    {0,2,1,5},
    {1,2,2,3},
    {1,4,2,5},
}
Font["."] = {
    {1,0,2,1},
}
Font[":"] = {
    {1,1,2,2},
    {1,3,2,4},
}
Font["?"] = {
    {1,0,2,1},
    {1,2,2,3},
    {2,2,3,5},
    {0,4,2,5},
}
Font["!"] = {
    {1,0,2,1},
    {1,2,2,5},
}
Font["+"] = {
    {1,1,2,4},
    {0,2,3,3},
}

Font["-"] = {
    {0,2,3,3},
}
Font["("] = {
    {0,1,1,4},
    {1,0,2,1},
    {1,4,2,5},
}
Font["("] = {
    {2,1,3,4},
    {1,0,2,1},
    {1,4,2,5},
}
Font[">"] = {
    {0,0,1,1},
    {1,1,2,2},
    {2,2,3,3},
    {0,4,1,5},
    {1,3,2,4},
}
Font["<"] = {
    {0,2,1,3},
    {1,1,2,2},
    {0,2,1,3},
    {1,3,2,4},
    {2,4,3,5},
}
Font["="] = {
    {0,1,3,2},
    {0,3,3,4},
}
Font["\'"] = {
    {1,3,2,5},
}
Font["\\"] = {
    {0,3,1,5},
    {1,2,2,3},
    {2,0,3,2},
}
Font["/"] = {
    {0,0,1,2},
    {1,2,2,3},
    {2,3,3,5},
}

Font["上"] = {
    {4,0,5,12},
    {5,7,10,8},
    {0,0,4,1},
    {5,0,11,1},
}
Font["下"] = {
    {0,10,11,11},
    {4,0,5,10},
    {6,7,7,8},
    {7,6,8,7},
    {8,5,9,6},
    {9,3,10,5},
}
Font["左"] = {
    {4,8,5,12},
    {0,9,4,10},
    {5,9,11,10},
    {3,5,4,8},
    {4,5,10,6},
    {2,3,3,5},
    {6,0,7,5},
    {1,2,2,3},
    {0,1,1,2},
    {2,0,6,1},
    {7,0,11,1},
}
Font["右"] = {
    {5,9,6,12},
    {0,9,5,10},
    {6,9,11,10},
    {4,7,5,9},
    {3,0,4,7},
    {4,5,10,6},
    {2,4,3,5},
    {9,0,10,5},
    {1,3,2,4},
    {0,2,1,3},
    {4,1,9,2},
}
-- Font["小"] = {
--     {5,0,6,12},
--     {2,6,3,8},
--     {8,7,9,8},
--     {9,5,10,7},
--     {1,4,2,6},
--     {10,3,11,5},
--     {0,3,1,4},
--     {3,0,5,1},
-- }
-- Font["跳"] = {
--     {0,8,1,12},
--     {1,11,4,12},
--     {6,2,7,12},
--     {8,1,9,12},
--     {3,8,4,11},
--     {4,9,5,10},
--     {10,9,11,10},
--     {1,8,3,9},
--     {5,8,6,9},
--     {9,8,10,9},
--     {2,2,3,8},
--     {0,1,1,6},
--     {3,5,4,6},
--     {5,5,6,6},
--     {9,5,10,6},
--     {4,4,5,5},
--     {10,4,11,5},
--     {3,2,4,3},
--     {10,0,11,3},
--     {1,1,2,2},
--     {5,1,6,2},
--     {4,0,5,1},
--     {9,0,10,1},
-- }
-- Font["跃"] = {
--     {8,11,10,12},
--     {0,7,1,11},
--     {1,10,4,11},
--     {5,10,8,11},
--     {3,7,4,10},
--     {7,4,8,10},
--     {1,7,3,8},
--     {2,2,3,7},
--     {5,6,7,7},
--     {8,6,11,7},
--     {3,5,4,6},
--     {0,1,1,5},
--     {6,2,7,4},
--     {8,2,9,4},
--     {3,2,4,3},
--     {1,1,2,2},
--     {5,1,6,2},
--     {9,1,10,2},
--     {4,0,5,1},
--     {10,0,11,1},
-- }
-- label = Text:new("你们好啊!",50,200)
-- label:setSize(3,38)
-- label:print()

up = Text:new("上",60,500)
up:setSize(2,4)
-- up:print()

down = Text:new("下",60,550)
down:setSize(2,4)
-- down:print()

left = Text:new("左",30,550)
left:setSize(2,4)
-- left:print()

right = Text:new("右",90,550)
right:setSize(2,4)
-- right:print()

-- jump = Text:new("跳跃",110,500)
-- jump:setSize(2,28)
-- jump:print()

-- crouch = Text:new("小跳",110,550)
-- crouch:setSize(2,28)
-- crouch:print()