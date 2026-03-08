import Tegami.Render (autoImage)
import Tegami.Shape ( ellipse, capsule, roundedBox
                    , pie, arc, star
                    , vesica, moon, rhombus, isoscelesTri )
import Tegami.Transform (zoom)
import Tegami.Composition (tile)


image_031 = tile expo . zoom 0.3
  where
    expo r c = (cycle shapes) !! (abs (r*7+c) `mod` length shapes)
    shapes   = map (. zoom 0.4)
        [ ellipse 0.75 0.45
        , capsule (-0.8, 0) (0.8, 0) 0.22
        , roundedBox 0.65 0.55 0.18
        , pie 0.85 (pi/3)
        , arc 0.85 0.12 (pi/3)
        , star 5 0.9 0.4
        , star 6 0.9 0.4
        , vesica 0.85 0.5
        , moon 0.5 0.85 0.65
        , rhombus 0.55 0.8
        , isoscelesTri 0.5 0.85
        ]


main = autoImage image_031
