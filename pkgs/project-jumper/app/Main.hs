{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TemplateHaskell #-}

module Main (main) where

import Control.Monad (forM, forM_)
import Data.List (intercalate, sortOn)
import Data.List.NonEmpty (NonEmpty (..))
import qualified Data.List.NonEmpty as NE
import Data.Ord (Down (..))
import Data.Text (Text)
import qualified Data.Text as T
import Data.Version (showVersion)
import Development.GitRev
import Options.Applicative
import Path
import Path.IO
import Paths_project_jumper (version)
import System.Console.ANSI
import System.Exit (exitFailure)
import System.FilePath (dropTrailingPathSeparator)
import System.IO

main :: IO ()
main = do
  Opts {..} <- execParser optsParserInfo
  projectsRoot <- getProjectsRoot
  projects <- listProjects projectsRoot
  target <-
    selectMatch optKeyword projects >>= \case
      x :| [] -> return x
      choices -> chooseMatch optKeyword choices
  projectDir projectsRoot target >>= putStrLn . fromAbsDir

-- | Keyword to use for search for matches.
newtype Keyword = Keyword Text

-- | The root of the project directory.
newtype ProjectsRoot = ProjectsRoot (Path Abs Dir)

-- | The directory of a project.
data Project = Project
  { -- | Project owner.
    projectOwner :: Text,
    -- | Project name.
    projectName :: Text
  }
  deriving (Show)

-- | Locate project directory for current user.
getProjectsRoot :: IO ProjectsRoot
getProjectsRoot = do
  homeDir <- getHomeDir
  -- TODO The root should be configurable
  return $ ProjectsRoot (homeDir </> $(mkRelDir "projects"))

-- | List available projects.
listProjects :: ProjectsRoot -> IO [Project]
listProjects (ProjectsRoot root) = do
  (ownerDirs, _) <- listDirRel root
  fmap concat . forM ownerDirs $ \owner -> do
    (names, _) <- listDirRel (root </> owner)
    let relDirToText = T.pack . dropTrailingPathSeparator . toFilePath
        ownerText = relDirToText owner
        toProject = Project ownerText . relDirToText
    return (toProject <$> names)

-- | Select a matching project(s).
selectMatch ::
  -- | The keyword
  Keyword ->
  -- | Projects to choose from
  [Project] ->
  -- | Either a collection of close-enough projects or a definitive match
  IO (NonEmpty Project)
selectMatch keyword projects = do
  case NE.groupWith fst
    . sortOn (Down . fst)
    . filter ((> 0) . fst)
    $ fmap assignScore projects of
    [] -> giveup "No matches found."
    (matches : _) -> return (snd <$> matches)
  where
    assignScore project =
      (score keyword (projectName project), project)

-- | Calculate the similarity score between the keyword and a project name.
score ::
  -- | The keyword
  Keyword ->
  -- | Project name
  Text ->
  -- | The score
  Int
score (Keyword keyword) name =
  if k `T.isInfixOf` n
    then
      if T.length k == T.length n
        then 2
        else 1
    else 0
  where
    k = T.toLower keyword
    n = T.toLower name

-- | Prompt the user to choose among the given projects.
chooseMatch ::
  -- | The keyword
  Keyword ->
  -- | The projects to choose from
  NonEmpty Project ->
  IO Project
chooseMatch (Keyword keyword) xs = do
  -- TODO The use of color should be configurable
  let withSGR sgrs m = do
        hSetSGR stderr sgrs
        () <- m
        hSetSGR stderr [Reset]
      cyan = withSGR [SetColor Foreground Dull Cyan]
      green = withSGR [SetColor Foreground Dull Green]
      put = hPutStr stderr
      -- TODO The letters should be configurable
      choices = NE.zip (NE.fromList "aoeuhtns") xs
  forM_ choices $ \(letter, Project {..}) -> do
    cyan $ put [letter]
    put " "
    put (T.unpack projectOwner)
    put "/"
    let (lowercasePrefix, _) =
          T.breakOn (T.toLower keyword) (T.toLower projectName)
        prefixLength = T.length lowercasePrefix
        (prefix, rest) = T.splitAt prefixLength projectName
        (match, suffix) = T.splitAt (T.length keyword) rest
    put (T.unpack prefix)
    green $ put (T.unpack match)
    put (T.unpack suffix)
    put "\n"
  hSetBuffering stdin NoBuffering
  usersChoice <- getChar
  case lookup usersChoice (NE.toList choices) of
    Nothing -> giveup "Invalid selection."
    Just x -> return x

-- | Obtain absolute path to the project directory.
projectDir ::
  -- | Project root
  ProjectsRoot ->
  -- | Project of interest
  Project ->
  -- | Absolute path to the project
  IO (Path Abs Dir)
projectDir (ProjectsRoot projectRoot) Project {..} = do
  ownerDir <- parseRelDir (T.unpack projectOwner)
  nameDir <- parseRelDir (T.unpack projectName)
  return (projectRoot </> ownerDir </> nameDir)

-- | Print a message to 'stderr' and stop execution with non-zero exit code.
giveup :: String -> IO a
giveup msg = do
  hPutStrLn stderr msg
  exitFailure

----------------------------------------------------------------------------
-- Command line options parsing

data Opts = Opts
  { -- | Keyword that identifies the project.
    optKeyword :: Keyword
  }

optsParserInfo :: ParserInfo Opts
optsParserInfo =
  info (helper <*> ver <*> optsParser) . mconcat $
    [ fullDesc,
      progDesc "project-jumper"
    ]
  where
    ver :: Parser (a -> a)
    ver =
      infoOption verStr . mconcat $
        [ long "version",
          short 'v',
          help "Print version of the program"
        ]
    verStr =
      intercalate
        "\n"
        [ unwords
            [ "project-jumper",
              showVersion version,
              $gitBranch,
              $gitHash
            ]
        ]

optsParser :: Parser Opts
optsParser =
  Opts
    <$> (fmap Keyword . argument str . mconcat)
      [ metavar "KEYWORD",
        help "Keyword that is used to identify the name of the project"
      ]
