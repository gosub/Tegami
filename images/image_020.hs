import Tegami.Render (autoPPM)
import Tegami.Shape (honeycomb)
import Tegami.Transform (zoom)


image_020 = honeycomb 0.8 . zoom 0.5

main = autoPPM $ image_020
