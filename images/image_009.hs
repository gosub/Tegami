import Tegami.Render (autoPPM)
import Tegami.Shape (checkers, disc)
import Tegami.Transform (zoom)


image_009 = (&&) <$> checkers . zoom 0.25 <*> disc

main = autoPPM $ image_009
