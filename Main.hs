module Main (main) where

import Data.Char (toLower)
import Happstack.Server
import Happstack.Server.SimpleHTTPS
import Options.Applicative
import System.Process (readProcess)
import System.Random

main :: IO ()
main = do
  args <- execParser argParser
  name <- getRandName
  simpleHTTPS conf (myApp args name)
  where
    -- Create the ceritficates with the following command:
    --   $ openssl req -x509 -newkey rsa:4096 -keyout privkey.pem -out cert.pem -days 900 -nodes -subj '/CN=example.com'
    conf = nullTLSConf { tlsPort=myport
                       , tlsCert="./cert.pem"
                       , tlsKey="./privkey.pem"
                       }
    argParser = info (cfgParser <**> helper)
                ( fullDesc
                  <> progDesc "Serve a directory and its content via https"
                  <> header "webserver80 - serve file via https" )


getRandName :: IO String
getRandName = do
  g <- getStdGen
  hostname <- readProcess "hostname" ["-f"] ""
  let randStr = take 24 $ randomRs ('a', 'z') g
  putStrLn "Will serve at:"
  putStrLn $ " https://" <> (map toLower $ init hostname) <> ":" <> show myport <> "/" <> randStr
  pure randStr


myApp :: Config -> String -> ServerPart Response
myApp args a = decodeBody policy >> dir a (fileServing $ publicPath args)
  where
    policy :: BodyPolicy
    policy = defaultBodyPolicy "/tmp/" 4096 4096 4096


fileServing :: FilePath -> ServerPart Response
fileServing = serveDirectory EnableBrowsing ["index.html"]


myport :: Int
myport = 43443


data Config = Config
  { publicPath :: String }


cfgParser :: Parser Config
cfgParser = Config
      <$> argument str
          ( metavar "PATH2PUBLISH"
            <> help "Path to publish (default: ./public-files/)"
            <> value "./public-files/" )
