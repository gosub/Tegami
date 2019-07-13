import Tegami.Render (autoPPM)
import Tegami.Shape (hexrings)
import Tegami.Transform (zoom)


image_019 = hexrings . zoom 0.25

main = autoPPM $ image_019
