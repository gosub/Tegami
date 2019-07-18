{-# LANGUAGE TypeSynonymInstances, FlexibleInstances #-}

module Tegami.Core where


type Point = (Double, Double)
type Image a = Point -> a
type Magnitude = Double -- [0; 1]
type RGB = (Magnitude, Magnitude, Magnitude)
type BinaryMask = Image Bool
type Transform = Point -> Point


class Raster a where
  toIntRGB :: a -> (Int, Int, Int)
  toIntRGB = const (0,0,0)

instance Raster Bool where
  toIntRGB True = (255, 255, 255)
  toIntRGB False = (0, 0, 0)

instance Raster RGB where
  toIntRGB (r, g, b) = (round (cr * 255),
                        round (cg * 255),
                        round (cb * 255))
    where cr = clamp 0 1.0 r
          cg = clamp 0 1.0 g
          cb = clamp 0 1.0 b
          clamp mn mx = max mn . min mx


origin :: Point
origin = (0, 0)

twopi = pi * 2.0

dist :: Point -> Point -> Magnitude
dist a b = sqrt ((x2-x1)**2 + (y2-y1)**2) where
                (x1, y1) = a
                (x2, y2) = b

dist0 p = dist origin p

atan2' y x | alpha >= 0 = alpha
           | otherwise = alpha + twopi
           where alpha = atan2 y x

polar2cart (r, theta) = (r*cos(theta), r*sin(theta))

cart2polar (x, y) = (dist0 (x,y), atan2' y x)

withPolar :: Transform -> Transform
withPolar f = polar2cart . f . cart2polar

xor :: Eq a => a -> a -> Bool
xor = (/=)

withMask m a b p = if' (m p) (a p) (b p)
  where if' True x _ = x
        if' False _ y = y
