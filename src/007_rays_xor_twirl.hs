import Tegami.Render (autoImage)
import Tegami.Shape (rays)
import Tegami.Transform (twirl, zoom)
import Tegami.Core (xor)

main = autoImage $ (xor <$> rays 8 <*> rays 8 . twirl) . zoom 0.5
