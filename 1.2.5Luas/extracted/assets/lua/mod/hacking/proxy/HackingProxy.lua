HackingProxy = BaseClass("HackingProxy", Proxy)

function HackingProxy:__init()

end

function HackingProxy:__InitProxy()
    self:BindMsg("hacking_build")
end

function HackingProxy:__InitComplete()

end

function HackingProxy:Send_hacking_build(build_id)
    return {build_id = build_id}
end