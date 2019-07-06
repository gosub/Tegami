import Tegami.Render (autoPPM)
import Tegami.Shape (rays)
import Tegami.Transform (twirl)

main = autoPPM $ rays 6 . twirl
