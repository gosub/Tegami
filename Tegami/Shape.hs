module Tegami.Shape where

import Tegami.Core
import Tegami.Transform (scale, rot, trans)
import Tegami.Shift (shiftRot)
import Tegami.Hex (cart2hex, hexround)

import Control.Applicative (liftA2)
import Data.Fixed (mod')

disc' :: Magnitude -> BinaryMask
disc' r p = (dist0 p) <= r

disc :: BinaryMask
disc = disc' 1.0

annulus :: Magnitude -> BinaryMask
annulus inner = xor <$> disc <*> (disc' inner)

square :: BinaryMask
square (x,y) = x <= 1.0 && x >= -1.0 && y >= -1.0 && y <= 1.0 

checkers :: BinaryMask
checkers (x, y) = even $ floor x + floor y

stripe :: BinaryMask
stripe (_, y) = y <= 1 && y >= 0

stripes :: BinaryMask
stripes (_, y) = odd $ ceiling y

top :: BinaryMask
top (_, y) = y >= 0

cross = shiftRot (liftA2 (||)) (pi/2) $ square . scale (1/3) 1

rays :: Integral a => a -> BinaryMask
rays n = even . truncate . (/ twopi) . (* fromIntegral n) . snd . cart2polar

poly :: Integral a => a -> BinaryMask
poly n = foldr1 (liftA2 (&&)) planes
         where planes = [semi . rot (fromIntegral i * ang) | i <- [0..n-1]]
               ang = twopi / fromIntegral n
               semi = top . trans (0, -apothem)
               apothem = cos (pi / fromIntegral n)


tri (x1,y1) (x2,y2) (x3,y3) (x,y) = s > 0 && t > 0 && s + t < 2 * a * (signum a)
  where a = ((-y2) * x3 + y1 * ((-x2) + x3) + x1 * (y2 - y3) + x2 * y3) / 2.0
        s = (y1 * x3 - x1 * y3 + (y3 - y1) * x + (x1 - x3) * y) * (signum a)
        t = (x1 * y2 - y1 * x2 + (y1 - y2) * x + (x2 - x1) * y) * (signum a)


girandola :: Integral a => a -> BinaryMask
girandola n p = r <= limit
  where (r, theta) = cart2polar p
        limit = 0.5 + 0.5 * (((theta * fromIntegral n) `mod'` twopi) / twopi)

flower :: Integral a => a -> BinaryMask
flower n p = r < maxdist
  where (r, theta) = cart2polar p
        pifrac = pi / (fromIntegral n)
        dx = even $ floor (theta / pifrac)
        progress = (theta `mod'` pifrac) / pifrac
        maxdist = if dx then 0.5 + 0.5 * progress else 1.0 - 0.5 * progress


blob threshold ps p = force > threshold
  where force = sum (map weight distances)
        weight d = 1/d
        distances = [dist p x | x <- ps]


hexrings p = odd $ maximum [abs hx, abs hy, abs hz]
  where (hx, hy, hz) = hexround $ cart2hex p


honeycomb threshold p = maximum [dx+dy, dy+dz, dx+dz] > threshold
  where (cx, cy, cz) = cart2hex p
        (hx, hy, hz) = hexround (cx, cy, cz)
        dx = abs (cx - fromIntegral hx)
        dy = abs (cy - fromIntegral hy)
        dz = abs (cz - fromIntegral hz)

rings :: BinaryMask
rings = even . floor . dist0
