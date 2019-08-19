import Tegami.Render (autoPPM)
import Tegami.Shape (annulus)
import Tegami.Core (xor)
import Tegami.Transform (trans)

image_029 = xor <$> ann <*> ann . trans (0.5, 0)
  where ann = annulus 0.7

main = autoPPM $ image_029
