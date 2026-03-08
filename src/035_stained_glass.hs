import Tegami.Render (autoImage)
import Tegami.Core (withMask)
import Tegami.Shape (rays, annulus, disc', poly)
import Tegami.Transform (zoom, rot)
import Tegami.Color (red, blue, yellow, cyan, magenta, white, black)

image_035 = withMask (disc' 0.95) inner (const black)
  where
    inner  = withMask (annulus 0.55) ring1 (withMask (annulus 0.25) ring2 hub)
    ring1  = withMask (rays 8) (const yellow) (const blue)
    ring2  = withMask (rays 6) (const red)    (const cyan)
    hub    = withMask (poly 6 . zoom 0.9) (const white) (const magenta)

main = autoImage image_035
