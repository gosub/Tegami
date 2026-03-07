import Tegami.Render (autoImage)
import Tegami.Shape (checkers)
import Tegami.Transform (circleLimit, zoom)
import Tegami.Color (black)


image_025 = circleLimit (checkers . zoom 0.25) (const False)

main = autoImage $ image_025
