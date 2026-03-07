{-# LANGUAGE GHC2021 #-}
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

cross :: BinaryMask
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


hexrings :: BinaryMask
hexrings p = odd $ maximum [abs hx, abs hy, abs hz]
  where (hx, hy, hz) = hexround $ cart2hex p


honeycomb :: Magnitude -> BinaryMask
honeycomb threshold p = maximum [dx+dy, dy+dz, dx+dz] > threshold
  where (cx, cy, cz) = cart2hex p
        (hx, hy, hz) = hexround (cx, cy, cz)
        dx = abs (cx - fromIntegral hx)
        dy = abs (cy - fromIntegral hy)
        dz = abs (cz - fromIntegral hz)

rings :: BinaryMask
rings = even . floor . dist0


-- IQ SDF shapes -------------------------------------------------------

-- Axis-aligned ellipse with semi-axes a (x) and b (y).
-- Exact analytical SDF ported from Inigo Quilez.
ellipse :: Magnitude -> Magnitude -> BinaryMask
ellipse a b p = sdf <= 0
  where
    (px0, py0) = let (x,y) = p in (abs x, abs y)
    (px, py, ea, eb) = if px0 > py0 then (py0, px0, b, a)
                                     else (px0, py0, a, b)
    l  = eb*eb - ea*ea
    m  = ea*px/l;  m2 = m*m
    n  = eb*py/l;  n2 = n*n
    c  = (m2+n2-1)/3;  c3 = c*c*c
    q  = c3 + m2*n2*2
    d  = c3 + m2*n2
    g  = m + m*n2
    co | d < 0    =
           let h  = acos (q/c3) / 3
               s  = cos h
               t  = sin h * sqrt 3
               rx = sqrt ((-c)*(s+t+2) + m2)
               ry = sqrt ((-c)*(s-t+2) + m2)
           in (ry + signum l * rx + abs g / (rx*ry) - m) / 2
       | otherwise =
           let h  = 2*m*n*sqrt d
               s  = signum (q+h) * abs (q+h)**(1/3)
               t  = signum (q-h) * abs (q-h)**(1/3)
               rx = -(s+t) - c*4 + 2*m2
               ry = (s-t)*sqrt 3
               rm = sqrt (rx*rx + ry*ry)
           in (ry/sqrt (rm-rx) + 2*g/rm - m) / 2
    si  = sqrt (max 0 (1 - co*co))
    sdf = dist0 (ea*co - px, eb*si - py) * signum (py - eb*si)

-- Stadium (pill): line segment from a to b thickened by radius r.
capsule :: Point -> Point -> Magnitude -> BinaryMask
capsule a b r p = sdf <= 0
  where
    (pax, pay) = let (px,py) = p; (ax,ay) = a in (px-ax, py-ay)
    (bax, bay) = let (ax,ay) = a; (bx,by) = b in (bx-ax, by-ay)
    h   = max 0 (min 1 (dot (pax,pay) (bax,bay) / dot (bax,bay) (bax,bay)))
    sdf = dist0 (pax - bax*h, pay - bay*h) - r

-- Box with half-extents (w, h) and uniform corner radius r.
roundedBox :: Magnitude -> Magnitude -> Magnitude -> BinaryMask
roundedBox w h r p = sdf <= 0
  where
    (x, y)   = p
    (qx, qy) = (abs x - w + r, abs y - h + r)
    sdf = min (max qx qy) 0 + dist0 (max qx 0, max qy 0) - r

-- Filled pie slice: outer radius r, half-angle ha (radians).
pie :: Magnitude -> Magnitude -> BinaryMask
pie r ha p = sdf <= 0
  where
    (px0, py) = p
    px  = abs px0
    cx  = sin ha;  cy = cos ha
    l   = dist0 (px, py) - r
    h   = max 0 (min r (dot (px,py) (cx,cy)))
    m   = dist0 (px - cx*h, py - cy*h)
    sdf = max l (m * signum (cy*px - cx*py))

-- Annular arc: outer radius ra, half-thickness rb, half-angle ha.
arc :: Magnitude -> Magnitude -> Magnitude -> BinaryMask
arc ra rb ha p = sdf <= 0
  where
    (px0, py) = p
    px  = abs px0
    scx = sin ha;  scy = cos ha
    base | scy*px > scx*py = dist0 (px - scx*ra, py - scy*ra)
         | otherwise       = abs (dist0 (px,py) - ra)
    sdf = base - rb

-- Star polygon with n points, outer radius r.
-- m controls pointiness: m=2 is sharpest, m=n gives a regular n-gon.
star :: Int -> Magnitude -> Magnitude -> BinaryMask
star n r m p = sdf <= 0
  where
    an        = pi / fromIntegral n
    en        = pi / m
    acx       = cos an;  acy = sin an
    ecx       = cos en;  ecy = sin en
    (px, py)  = p
    bn        = (atan2 px py `mod'` (2*an)) - an
    len       = dist0 p
    qx        = len*cos bn - r*acx
    qy        = len*sin bn - r*acy
    h         = max 0 (min (r*acy/ecy) (-(dot (qx,qy) (ecx,ecy))))
    rx        = qx + ecx*h
    ry        = qy + ecy*h
    sdf       = dist0 (rx, ry) * signum rx

-- Vesica piscis: intersection of two circles of radius r whose centres
-- are 2*d apart (on the x-axis).
vesica :: Magnitude -> Magnitude -> BinaryMask
vesica r d p = sdf <= 0
  where
    (px, py) = let (x,y) = p in (abs x, abs y)
    b   = sqrt (r*r - d*d)
    sdf | (py-b)*d > px*b = dist0 (px, py-b) * signum d
        | otherwise       = dist0 (px+d, py) - r

-- Crescent moon: large circle of radius ra centred at origin, with a
-- circular bite of radius rb whose centre is at distance d along x.
moon :: Magnitude -> Magnitude -> Magnitude -> BinaryMask
moon d ra rb p = sdf <= 0
  where
    (px, py0) = p
    py = abs py0
    a  = (ra*ra - rb*rb + d*d) / (2*d)
    b  = sqrt (max 0 (ra*ra - a*a))
    sdf | d*(px*b - py*a) > d*d * max (b-py) 0
            = dist0 (px-a, py-b) - ra
        | otherwise
            = max (dist0 (px,py) - ra) (-(dist0 (px-d,py) - rb))

-- Diamond (rhombus) with half-extents w (x) and h (y).
rhombus :: Magnitude -> Magnitude -> BinaryMask
rhombus w h p = sdf <= 0
  where
    (px, py) = let (x,y) = p in (abs x, abs y)
    ndot (x1,y1) (x2,y2) = x1*x2 - y1*y2
    hh  = max (-1) (min 1 (ndot (w,h) (w-2*px, h-2*py) / dot (w,h) (w,h)))
    d   = dist0 (px - 0.5*w*(1-hh), py - 0.5*h*(1+hh))
    sdf = d * signum (px*h + py*w - w*h)

-- Isosceles triangle: base half-width bw, height bh.
-- Base runs along y=0, apex at (0, bh).
isoscelesTri :: Magnitude -> Magnitude -> BinaryMask
isoscelesTri bw bh p = sdf <= 0
  where
    (px0, py) = p
    px  = abs px0
    t1  = max 0 (min 1 (dot (px,py) (bw,bh) / dot (bw,bh) (bw,bh)))
    a   = (px - bw*t1, py - bh*t1)
    t2  = max 0 (min 1 (px/bw))
    b   = (px - bw*t2, py - bh)
    s   = -signum bh
    da  = (dot a a, s*(px*bh - py*bw))
    db  = (dot b b, s*(py - bh))
    (d0, d1) = if fst da < fst db then da else db
    sdf = -(sqrt d0 * signum d1)
