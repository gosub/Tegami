import Tegami.Render (autoPPM)
import Tegami.Shape (checkers)
import Tegami.Transform (radInvert)


image_024 = checkers . radInvert

main = autoPPM $ image_024
