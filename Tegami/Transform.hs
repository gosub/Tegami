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

iso :: Magnitude -> Magnitude -> Transform
iso tileW tileH (x, y) = (tx, ty)
  where tx = (x / tileW) + (y / tileH)
        ty = (y / tileH) - (x / tileW)

mirror :: Transform
mirror = abs *** id

transpose :: Transform
transpose (x, y) = (y, x)

spiralBy :: Magnitude -> Magnitude -> Transform
spiralBy arms tight = trns . cart2polar
  where trns (r, a) = (mod' (r*tight + a / twopi*arms) 1, a)

spiral :: Transform
spiral = spiralBy 1 1

both :: (a -> b) -> (a, a) -> (b, b)
both f (x, y) = (f x, f y)

tile :: Transform
tile = both ((`mod'` 1) . abs)

tile' :: Transform
tile' = trans (1,1) . zoom 0.5 . tile . zoom 2 . trans ((-1),(-1))

radInvert :: Transform
radInvert = withPolar f
  where f (r, a) = (1/r, a)

unsafeCircleLimit :: Transform
unsafeCircleLimit = withPolar f
  where f (r, a) = (r/(1-r), a)

circleLimit :: Image a -> Image a -> Image a
circleLimit im bg = withMask disc (im . unsafeCircleLimit) bg
  where disc p = (dist0 p) <= 1.0
