--DONE but not tested
local LMNNPullCriterion, parent = torch.class('nn.LMNNPullCriterion', 'nn.Criterion')

function LMNNPullCriterion:__init()
    parent.__init(self)
    self.Li = torch.Tensor()
    self.gradInput = {}
end

function LMNNPullCriterion:updateOutput(inputs)
    local x1 = inputs[1]
    local x2 = inputs[2]
    local N = x1:size(1)

    self.Li = (x1 - x2):norm(2, 2):pow(2)

    self.output = self.Li:sum() / N
    return self.output
end

function LMNNPullCriterion:updateGradInput(inputs)
    local x1 = inputs[1]
    local x2 = inputs[2]
    local N = x1:size(1)


    self.gradInput[1] = torch.cmul(x1 - x2, self.Li:gt(0):repeatTensor(x1:size(2), 1):t():type(x1:type())) * 2 / N
    self.gradInput[2] = torch.cmul(x2 - x1, self.Li:gt(0):repeatTensor(x1:size(2), 1):t():type(x1:type())) * 2 / N

    return self.gradInput
end
