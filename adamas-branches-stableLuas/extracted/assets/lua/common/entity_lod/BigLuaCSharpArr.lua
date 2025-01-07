BigLuaCSharpArr = SimpleBaseClass("BigLuaCSharpArr", PoolSimpleBaseClass)

function BigLuaCSharpArr:__init()
    self.CSharpArr = LuaCSharpArr.New(100)
    self.access = self.CSharpArr:GetCSharpAccess()
end

function BigLuaCSharpArr:__cache()

end

function BigLuaCSharpArr:__delete()
    self.CSharpArr:DestroyCSharpAccess()
end