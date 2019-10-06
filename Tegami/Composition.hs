module Tegami.Composition where


tile f (x, y) = patch (patch_x, patch_y)
  where patch = f row col
        row = round y
        col = round x
        patch_x = x - fromIntegral col
        patch_y = y - fromIntegral row

concentric_tile f (x,y) = patch (x,y)
    where patch = f ring
          ring = max (round $ abs x) (round $ abs y)
