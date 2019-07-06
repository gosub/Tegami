import Tegami.Render (autoPPM)
import Tegami.Shape (stripes)
import Tegami.Transform (zoom, wave)


image_010 = stripes . wave 3 1 . zoom 0.75

main = autoPPM $ image_010
