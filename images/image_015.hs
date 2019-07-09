import Tegami.Render (autoPPM)
import Tegami.Shape (stripes)
import Tegami.Transform (slicer, zoom)
import Tegami.Core (twopi)


image_015 = stripes . slicer (twopi/3) . zoom 0.25

main = autoPPM $ image_015
