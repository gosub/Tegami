module Tegami.Shift where

import Tegami.Transform (trans, rot)

shift op t img = op img $ img . t
shiftH op x = shift op $ trans (x, 0)
shiftV op y = shift op $ trans (y, 0)
shiftRot op theta = shift op $ rot theta
