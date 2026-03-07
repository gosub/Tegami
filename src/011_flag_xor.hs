import Tegami.Render (autoImage)
import Tegami.Shape (stripes)
import Tegami.Transform (zoom, wave, cw)
import Tegami.Core (xor)


image_011 = (xor <$> flag <*> flag . cw) . zoom 0.1
              where flag = stripes . wave 1 1


main = autoImage $ image_011
