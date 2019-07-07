import Tegami.Render (autoPPM)
import Tegami.Shape (disc, poly)
import Tegami.Transform (zoom, ringer)
import Tegami.Core (xor)


image_012 = (xor <$> disc <*> poly 3) . ringer 1 . zoom 0.5

main = autoPPM $ image_012
