module Tegami.Transform where

import Tegami.Core

import Data.Fixed (mod')
import Control.Arrow ((***))

trans :: Point -> Transform
trans p = \(x, y) -> (x-x1, y-y1)
          where (x1, y1) = p

rot :: Magnitude -> Transform
rot alpha p = polar2cart (r, angle-alpha)
                where (r, angle) = cart2polar p

scale :: Magnitude -> Magnitude -> Transform
scale sx sy (x, y) = (x/sx, y/sy)

cw :: Transform
cw = rot (-pi/2)

ccw :: Transform
ccw = rot (pi/2)

zoom :: Magnitude -> Transform
zoom z = scale z z

wave freq amp (x, y) = (x, y - amp * sin(x * freq))

ringer :: Magnitude -> Transform
ringer modulo = polar2cart . ((`mod'` modulo) *** id) . cart2polar

slicer :: Magnitude -> Transform
slicer modulo = polar2cart . (id *** (`mod'` modulo))  . cart2polar

twirlBy :: Magnitude -> Transform
twirlBy amount p = polar2cart(r, theta2)
  where theta2 = theta + r * amount
        (r, theta) = cart2polar p

twirl :: Transform
twirl = twirlBy 1

