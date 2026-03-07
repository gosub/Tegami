{-# LANGUAGE GHC2021 #-}
module Tegami.Shift where

import Tegami.Transform (trans, rot, zoom)
import Tegami.Core (twopi, Transform, Image)

shift :: (Image a -> Image a -> Image a) -> Transform -> Image a -> Image a
shift op t img = op img $ img . t

shiftH :: (Image a -> Image a -> Image a) -> Double -> Image a -> Image a
shiftH op x = shift op $ trans (x, 0)

shiftV :: (Image a -> Image a -> Image a) -> Double -> Image a -> Image a
shiftV op y = shift op $ trans (y, 0)

shiftRot :: (Image a -> Image a -> Image a) -> Double -> Image a -> Image a
shiftRot op theta = shift op $ rot theta

shiftConc :: (Image a -> Image a -> Image a) -> Double -> Image a -> Image a
shiftConc op ratio = shift op $ zoom ratio

around :: (Image a -> Image a -> Image a) -> Double -> Double -> Image a -> Image a
around op radius n p = foldr1 op ps
  where ps = [p . trans (x i, y i) | i <- [0..n-1]]
        x i = radius * (cos (angle i))
        y i = radius * (sin (angle i))
        angle i = i * twopi / n
