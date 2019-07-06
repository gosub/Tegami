import Tegami.Render (autoPPM)
import Tegami.Shape (rays)
import Tegami.Transform (twirl, zoom)
import Tegami.Core (xor)

main = autoPPM $ (xor <$> rays 8 <*> rays 8 . twirl) . zoom 0.5
