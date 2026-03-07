import Tegami.Render (autoImage)
import Tegami.Shape (checkers)
import Tegami.Transform (radInvert)


image_024 = checkers . radInvert

main = autoImage $ image_024
