SmallLuaCSharpArr = BaseClass("SmallLuaCSharpArr", PoolBaseClass)

function SmallLuaCSharpArr:__init()
    self.CSharpArr = LuaCSharpArr.New(15)
    self.access = self.CSharpArr:GetCSharpAccess()
end

function SmallLuaCSharpArr:__cache()
    for i = 1, 15 do
        self.CSharpArr[i] = 0
    end
end

function SmallLuaCSharpArr:__delete()
    self.CSharpArr:DestroyCSharpAccess()
end