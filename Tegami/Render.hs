module Tegami.Render (
    imageToPPM,
    writePPM,
    autoPPM
) where

import Tegami.Core

import System.Environment (getArgs, getProgName)
import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as BC
import Data.Char (chr)


imageToPPM :: Raster a => Image a -> Integer -> Integer -> B.ByteString
imageToPPM image w h =  header `B.append` (B.concat $ do
    y <- [0..h-1]
    x <- [0..w-1]
    let (r, g, b) = toIntRGB $ image (-2.0 + stepX * fromIntegral x, 2.0 - stepY * fromIntegral y)
    return $ BC.pack [chr r, chr g, chr b])
    where
        header = BC.pack $ "P6\n" ++ show w ++ " " ++ show h ++ "\n255\n"
        stepX = 4.0 / (fromIntegral w) :: Double
        stepY = 4.0 / (fromIntegral h) :: Double


writePPM name image w h = B.writeFile (name ++ ".ppm") $ imageToPPM image w h


safenth :: [a] -> Int -> a -> a
safenth [] _ x = x
safenth l 0 x  =  head l 
safenth l n x  = safenth (tail l) (n - 1) x


autoPPM :: Raster a => Image a -> IO ()
autoPPM image = do
    args <- getArgs
    let w = safenth (map read args) 0 1600
    let h = safenth (map read args) 1 1600
    name <- getProgName
    writePPM name image w h
