module Main (main) where

import Data.Char (toLower)
import Happstack.Server
import Happstack.Server.SimpleHTTPS
import System.Process (readProcess)
import System.Random

main :: IO ()
main = do
  name <- getRandName
  simpleHTTPS conf (myApp name)
  where
    -- Create the ceritficates with the following command:
    --   $ openssl req -x509 -newkey rsa:4096 -keyout privkey.pem -out cert.pem -days 900 -nodes -subj '/CN=example.com'
    conf = nullTLSConf { tlsPort=myport
                       , tlsCert="./cert.pem"
                       , tlsKey="./privkey.pem"
                       }


getRandName :: IO String
getRandName = do
  g <- getStdGen
  hostname <- readProcess "hostname" ["-f"] ""
  let randStr = take 24 $ randomRs ('a', 'z') g
  putStrLn "Will serve at:"
  putStrLn $ " https://" <> (map toLower $ init hostname) <> ":" <> show myport <> "/" <> randStr
  pure randStr


myApp :: String -> ServerPart Response
myApp a = decodeBody policy >> dir a fileServing
  where
    policy :: BodyPolicy
    policy = defaultBodyPolicy "/tmp/" 4096 4096 4096


fileServing :: ServerPart Response
fileServing = serveDirectory EnableBrowsing ["index.html"] "./public-files/"


myport :: Int
myport = 43443
