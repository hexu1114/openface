--DONE But Not Tested

local HadsellMarginCriterion, parent = torch.class('nn.HadsellMarginCriterion', 'nn.Criterion')

function HadsellMarginCriterion:__init()
    parent.__init(self)
    self.alpha = 1
    self.Li = torch.Tensor()
    self.gradInput = {}
end


function HadsellMarginCriterion:updateOutput(inputs, target)
    local x1 = inputs[1]
    local x2 = inputs[2]
    local N = x1:size(1)
    optimLogger:add {
        (x1 - x2):norm(2, 2):pow(2):cmul(target):mean(),
        (x1 - x2):norm(2, 2):pow(2):cmul(target):max(),
        torch.max(torch.cat(torch.Tensor(N):zero():type(torch.type(x1)), self.alpha - (x1 - x2):norm(2, 2), 2), 2):pow(2):cmul(1 - target):mean(),
        torch.max(torch.cat(torch.Tensor(N):zero():type(torch.type(x1)), self.alpha - (x1 - x2):norm(2, 2), 2), 2):pow(2):cmul(1 - target):max()
    }
    self.Li = ((x1 - x2):norm(2, 2):pow(2):cmul(target)
            + torch.max(torch.cat(torch.Tensor(N):zero():type(torch.type(x1)), self.alpha - (x1 - x2):norm(2, 2), 2), 2):pow(2):cmul(1 - target)) / 2

    self.output = self.Li:sum() / N
    return self.output
end

function HadsellMarginCriterion:updateGradInput(inputs, target)
    local x1 = inputs[1]
    local x2 = inputs[2]
    local N = x1:size(1)
    self.gradInput[1] = ((x1 - x2):cmul(torch.cmul(self.Li:gt(0):repeatTensor(x1:size(2), 1):t():type(x1:type()), target:repeatTensor(x1:size(2), 1):t():type(x1:type())))
            + (self.alpha - (x1 - x2)):cmul(torch.cmul(self.Li:gt(0):repeatTensor(x1:size(2), 1):t():type(x1:type()), (target - 1):repeatTensor(x1:size(2), 1):t():type(x1:type()))))

    self.gradInput[2] = ((x2 - x1):cmul(torch.cmul(self.Li:gt(0):repeatTensor(x1:size(2), 1):t():type(x1:type()), target:repeatTensor(x1:size(2), 1):t():type(x1:type())))
            + (self.alpha - (x2 - x1)):cmul(torch.cmul(self.Li:gt(0):repeatTensor(x1:size(2), 1):t():type(x1:type()), (target - 1):repeatTensor(x1:size(2), 1):t():type(x1:type()))))

    return self.gradInput
end
