module Tegami.Shift where

import Tegami.Transform (trans, rot, zoom)
import Tegami.Core (twopi)

shift op t img = op img $ img . t
shiftH op x = shift op $ trans (x, 0)
shiftV op y = shift op $ trans (y, 0)
shiftRot op theta = shift op $ rot theta
shiftConc op ratio = shift op $ zoom ratio

around op radius n p = foldr1 op ps
  where ps = [p . trans (x i, y i) | i <- [0..n-1]]
        x i = radius * (cos (angle i))
        y i = radius * (sin (angle i))
        angle i = i * twopi / n
