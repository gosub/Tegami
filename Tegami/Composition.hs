{-# LANGUAGE GHC2021 #-}
module Tegami.Composition where

import Tegami.Core


tile :: (Int -> Int -> Image a) -> Image a
tile f (x, y) = patch (patch_x, patch_y)
  where patch = f row col
        row = round y
        col = round x
        patch_x = x - fromIntegral col
        patch_y = y - fromIntegral row

concentric_tile :: (Int -> Image a) -> Image a
concentric_tile f (x,y) = patch (x,y)
    where patch = f ring
          ring = max (round $ abs x) (round $ abs y)
