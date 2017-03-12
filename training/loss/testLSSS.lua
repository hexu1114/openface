--
-- Created by IntelliJ IDEA.
-- User: cenk
-- Date: 06.03.2017
-- Time: 08:29
-- To change this template use File | Settings | File Templates.
--



cuda = false

require 'nn'
require '../loss/LSSS'

torch.setdefaulttensortype('torch.FloatTensor')
if cuda then
    require 'cutorch'
    torch.setdefaulttensortype('torch.CudaTensor')
    cutorch.manualSeedAll(0)
end

colour = require 'trepl.colorize'
local b = colour.blue

torch.manualSeed(0)

nsize = 2
xsize = 4
input = torch.Tensor { { 19, 9 }, { 15, 7 }, { 7, 2 }, { 17, 6 } }
target = torch.Tensor { 1, 1, 2, 2 }

--input = nn.Normalize(2):forward(input)
print(input)
loss = nn.LiftedStructuredSimilaritySoftmaxCriterion()
if cuda then loss = loss:cuda() end
print(colour.red('loss: '), loss:forward(input, target), '\n')
gradInput = loss:backward(input, target)
print(gradInput)