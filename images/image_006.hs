import Tegami.Render (autoImage)
import Tegami.Shape (rays)
import Tegami.Transform (twirl)

main = autoImage $ rays 6 . twirl
