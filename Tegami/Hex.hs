module Tegami.Hex where

import Tegami.Core


type HexPoint = (Double, Double, Double)

cart2hex :: Point -> HexPoint
cart2hex (x, y) = (q, (-q)-r, r)
                  where q = x * 2.0 / 3.0
                        r = (-x) / 3.0 + sqrt(3.0) / 3.0 * y

hexround :: Integral a => HexPoint -> (a,a,a)
hexround (cx, cy, cz) = (x, y, z)
  where rx = round cx
        ry = round cy
        rz = round cz
        x_diff = abs (fromIntegral rx - cx)
        y_diff = abs (fromIntegral ry - cy)
        z_diff = abs (fromIntegral rz - cz)
        cond1 = x_diff > y_diff && x_diff > z_diff
        cond2 = y_diff > z_diff
        x = if cond1 then (-ry)-rz else rx
        y = if (not cond1) && cond2 then (-rx)-rz else ry
        z = if (not cond1) && (not cond2) then  (-rx)-ry else rz

