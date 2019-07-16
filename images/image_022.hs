import Tegami.Render (autoPPM)
import Tegami.Shape (disc)
import Tegami.Transform (trans, zoom, tile')
import Tegami.Core (xor)


image_022 = (xor <$> disc . tile' <*> anelli . trans (1,1)) . zoom 0.75
  where anelli = (xor <$> disc <*> disc . zoom 0.8) . tile'

main = autoPPM $ image_022
