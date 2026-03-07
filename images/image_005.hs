import Tegami.Render (autoImage)
import Tegami.Shape (cross)
import Tegami.Transform (zoom, rot)
import Tegami.Composition (tile)

main = autoImage $ tile rotocross . zoom 0.2
  where rotocross r c = cross . zoom 0.5 . rot (fromIntegral (r+c)/10)
