import Tegami.Render (autoPPM)
import Tegami.Shape (square)
import Tegami.Transform (zoom, rot)
import Tegami.Composition (tile)

main = autoPPM $ tile rotsquare . zoom 0.3
  where rotsquare r c = square . zoom 0.3333 . rot (fromIntegral (r+c)/10)
