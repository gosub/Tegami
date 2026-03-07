{-# LANGUAGE GHC2021 #-}
module Tegami.Render (
    writeImage,
    autoImage
) where

import Tegami.Core

import System.Environment (getArgs, getProgName)
import Codec.Picture hiding (Image)
import qualified Codec.Picture as JP
import Control.Parallel.Strategies (parListChunk, rdeepseq, using)
import qualified Data.Vector.Storable as VS
import Data.Word (Word8)


safenth :: [a] -> Int -> a -> a
safenth []     _ x = x
safenth (a:_)  0 _ = a
safenth (_:as) n x = safenth as (n - 1) x


renderRow :: Raster a => Int -> Image a -> Int -> Int -> Double -> Double -> VS.Vector Word8
renderRow aa image w y stepX stepY = VS.fromList $ concatMap pixelBytes [0 .. w-1]
  where
    worldY = 2.0 - stepY * fromIntegral y
    pixelBytes x = [r8, g8, b8]
      where
        cx  = -2.0 + stepX * fromIntegral x
        sub = [ fromIntegral i / fromIntegral aa - 0.5 | i <- [0 .. aa-1] ]
        samples  = [ toIntRGB $ image (cx + dx * stepX / fromIntegral aa,
                                       worldY + dy * stepY / fromIntegral aa)
                   | dx <- sub, dy <- sub ]
        n        = aa * aa
        avg xs   = sum xs `div` n
        (rs, gs, bs) = unzip3 samples
        r8 = fromIntegral (avg rs)
        g8 = fromIntegral (avg gs)
        b8 = fromIntegral (avg bs)


writeImage :: Raster a => Int -> FilePath -> Image a -> Int -> Int -> IO ()
writeImage aa path image w h = writePng path juicyImg
  where
    stepX    = 4.0 / fromIntegral w
    stepY    = 4.0 / fromIntegral h
    rows     = map (\y -> renderRow aa image w y stepX stepY) [0 .. h-1]
               `using` parListChunk 8 rdeepseq
    pixels   = VS.concat rows
    juicyImg = JP.Image w h pixels :: JP.Image PixelRGB8


autoImage :: Raster a => Image a -> IO ()
autoImage image = do
    args <- getArgs
    name <- getProgName
    let w    = safenth (map read args) 0 800
        h    = safenth (map read args) 1 800
        aa   = safenth (map read args) 2 2
        path = safenth args 3 (name ++ ".png")
    writeImage aa path image w h
