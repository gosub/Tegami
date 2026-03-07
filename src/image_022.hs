import Tegami.Render (autoImage)
import Tegami.Shape (disc)
import Tegami.Transform (trans, zoom, tile')
import Tegami.Core (xor)


image_022 = (xor <$> disc . tile' <*> anelli . trans (1,1)) . zoom 0.75
  where anelli = (xor <$> disc <*> disc . zoom 0.8) . tile'

main = autoImage $ image_022
