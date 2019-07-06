module Tegami.Shape where

import Tegami.Core
import Tegami.Transform (scale, rot, trans)
import Tegami.Shift (shiftRot)

import Control.Applicative (liftA2)
import Data.Fixed (mod')

disc :: BinaryMask
disc p = (dist0 p) <= 1.0

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

{-
tri p1 p2 p3 p = s > 0 && t > 0 && s + t < 2 * a * (signum a)
                 where (x, y) = p
                       (x1, y1) = p1
                       (x2, y2) = p2
                       (x3, y3) = p3
                       a = ((-y2) * x3 + y1 * ((-x2) + x3) + x1 * (y2 - y3) + x2 * y3) / 2.0;
                       s = (y1 * x3 - x1 * y3 + (y3 - y1) * x + (x1 - x3) * y) * (signum a);
                        t = (x1 * y2 - y1 * x2 + (y1 - y2) * x + (x2 - x1) * y) * (signum a);
-}

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

