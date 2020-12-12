module Main (main) where

import Happstack.Server
import Happstack.Server.SimpleHTTPS

main :: IO ()
main = simpleHTTPS conf myApp
  where
    -- Create the ceritficates with the following command:
    --   $ openssl req -x509 -newkey rsa:4096 -keyout privkey.pem -out cert.pem -days 900 -nodes -subj '/CN=hi7-c-0002c.hi.de.bosch.com'
    conf = nullTLSConf { tlsPort=43443
                       , tlsCert="./cert.pem"
                       , tlsKey="./privkey.pem"
                       }


myApp :: ServerPart Response
myApp = decodeBody policy >> dir ".well-known" (dir "acme-challenge" fileServing)
  where
    policy :: BodyPolicy
    policy = defaultBodyPolicy "/tmp/" 4096 4096 4096


fileServing :: ServerPart Response
fileServing = serveDirectory DisableBrowsing ["index.html"] "/var/lib/acme/acme-challenge/.well-known/acme-challenge/"
