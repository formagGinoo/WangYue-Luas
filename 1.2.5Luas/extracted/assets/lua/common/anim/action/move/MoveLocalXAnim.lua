MoveLocalXAnim = BaseClass("MoveLocalXAnim", AnimBaseTween)

function MoveLocalXAnim:__init(transform,toX,time)
    self.transform = transform
    self.toX = toX
    self.time = time
end

function MoveLocalXAnim:OnTween()
    local tween = self.transform:DOLocalMoveX(self.toX,self.time)
    return tween
end

function MoveLocalXAnim.Create(root,animData,nodes,animNodes)
    local transform = AnimUtils.GetComponent(root,animData.path)
    local anim = MoveLocalXAnim.New(transform,animData.toX,animData.time)
    return anim
end