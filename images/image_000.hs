import Tegami.Render (autoImage)
import Tegami.Core (xor)
import Tegami.Shape (disc, square)
import Tegami.Transform (trans, rot)

main = autoImage $ xor <$> disc . trans (0.5, 0) <*> square . rot (pi/4)
