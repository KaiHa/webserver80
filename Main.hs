module Main (main) where

import Happstack.Server

main :: IO ()
main = simpleHTTP conf myApp
  where
    conf = nullConf { port=80 }


myApp :: ServerPart Response
myApp = decodeBody policy >> dir ".well-known" (dir "acme-challenge" fileServing)
  where
    policy :: BodyPolicy
    policy = defaultBodyPolicy "/tmp/" 4096 4096 4096


fileServing :: ServerPart Response
fileServing = serveDirectory DisableBrowsing ["index.html"] "/var/lib/acme/acme-challenges/.well-known/acme-challenge/"
