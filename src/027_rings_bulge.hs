import Tegami.Render (autoImage)
import Tegami.Shape (rings)
import Tegami.Transform (zoom)
import Tegami.Core (withPolar)


image_027 = rings . bulge . zoom 0.25
  where bulge  = withPolar polarbulge
        polarbulge (r, a) = (r/(sin (a+pi/4)), a)

main = autoImage $ image_027
