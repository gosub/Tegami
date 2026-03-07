import Tegami.Render (autoImage)
import Tegami.Shape (blob)
import Tegami.Transform (trans)


image_014 = blob 2.57 [(1, 0), ((-1), 0), (0, 1.7)] . trans (0, (-0.5))

main = autoImage $ image_014
