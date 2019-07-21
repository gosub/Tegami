import Tegami.Render (autoPPM)
import Tegami.Shape (stripe)
import Tegami.Transform (transpose, zoom, spiralBy)
import Tegami.Composition (tile)


image_026 = tile spirs . zoom 0.25
  where spirs r c = stripe . transpose . zoom 0.5 . smallspiral r c
        smallspiral a b = spiralBy (fromIntegral a) (fromIntegral b)

main = autoPPM $ image_026
