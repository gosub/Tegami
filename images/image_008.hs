import Tegami.Render (autoPPM)
import Tegami.Shape (disc, square, poly, girandola, flower)
import Tegami.Transform (zoom)
import Tegami.Composition (tile)


image_008 = tile expo . zoom 0.3
  where expo r c = (map (. zoom 0.3) (cycle images)) !! (abs (r*7+c))
        images = singles ++ polys ++ girandolas ++ flowers
        singles = [disc, square]
        girandolas = [girandola n | n <- [3..10]]
        flowers = [flower n | n <- [3..10]]
        polys = [poly n | n <- [3..10]]


main = autoPPM $ image_008
