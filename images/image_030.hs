import Tegami.Render (autoPPM)
import Tegami.Shape (stripes)
import Tegami.Composition (concentric_tile)
import Tegami.Transform (zoom, rot)

leaning_stripes True = stripes . zoom 0.05 . rot (pi/4)
leaning_stripes False = stripes . zoom 0.05 . rot (-pi/4)

image_030 = concentric_tile (\r -> leaning_stripes (odd r)) . zoom 0.5

main = autoPPM $ image_030
