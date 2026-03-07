{-# LANGUAGE GHC2021 #-}
module Tegami.Render (
    writeImage,
    autoImage
) where

import Tegami.Core

import System.Environment (getArgs, getProgName)
import Codec.Picture
import Control.Parallel.Strategies (parListChunk, rdeepseq, using)
import qualified Data.Vector.Storable as VS
import Data.Word (Word8)


safenth :: [a] -> Int -> a -> a
safenth [] _ x = x
safenth l  0 _ = head l
safenth l  n x = safenth (tail l) (n - 1) x


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
    rows     = map (renderRow aa image w) [0 .. h-1]
               `using` parListChunk 8 rdeepseq
    pixels   = VS.concat rows
    juicyImg = Image w h pixels :: Image PixelRGB8


autoImage :: Raster a => Image a -> IO ()
autoImage image = do
    args <- getArgs
    name <- getProgName
    let w  = safenth (map read args) 0 800
        h  = safenth (map read args) 1 800
        aa = safenth (map read args) 2 1
    writeImage aa (name ++ ".png") image w h
