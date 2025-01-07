AlchemyProxy = BaseClass("AlchemyProxy", Proxy)

function AlchemyProxy:__InitProxy()
    self:BindMsg("alchemy_info")
    self:BindMsg("alchemy")
end

function AlchemyProxy:__InitComplete()

end

function AlchemyProxy:Send_alchemy(formulaId, items, counts)
    return {formula_id = formulaId, solution = items, count = counts}
end

function AlchemyProxy:Recv_alchemy(data)
    --return data
end

function AlchemyProxy:Send_alchemy_info()
    return
end

function AlchemyProxy:Recv_alchemy_info(data)
    mod.AlchemyCtrl:UpdateFormulaList(data)
end

