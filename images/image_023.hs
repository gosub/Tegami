import Tegami.Render (autoPPM)
import Tegami.Shape (rings, disc)
import Tegami.Transform (cw, ccw, wave, twirlBy, rot,
                         zoom, scale, mirror, trans)
import Tegami.Core (cart2polar, polar2cart, withMask)
import Tegami.Color (red, black, white)

import Control.Arrow ((***))

image_023_poster = img . trans ((-0.3), 0.5)
  where img = withMask heart (const red) bg
        heart = disc . scale 0.9 1.7 . rot (-pi/4) . mirror . zoom 0.333
        bg = withMask (onde . twirlBy 0.1) (const black) (const white)
        onde = rings . zoom 0.1 . polardisto
        polardisto = polar2cart . disto . cart2polar
        disto = cw .  wave 12 1 .  (id *** (\x -> x + sin (x/2))) . ccw

main = autoPPM $ image_023_poster
