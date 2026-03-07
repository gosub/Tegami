import Tegami.Render (autoImage)
import Tegami.Shape (honeycomb)
import Tegami.Transform (zoom)


image_020 = honeycomb 0.8 . zoom 0.5

main = autoImage $ image_020
