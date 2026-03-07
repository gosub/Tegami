import Tegami.Render (autoImage)
import Tegami.Shape (hexrings)
import Tegami.Transform (zoom)


image_019 = hexrings . zoom 0.25

main = autoImage $ image_019
