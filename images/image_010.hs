import Tegami.Render (autoImage)
import Tegami.Shape (stripes)
import Tegami.Transform (zoom, wave)


image_010 = stripes . wave 3 1 . zoom 0.75

main = autoImage $ image_010
