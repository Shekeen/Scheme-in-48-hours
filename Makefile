FILES=$(wildcard scheme/*.hs)

main: main.hs $(FILES)
	ghc -XExistentialQuantification -outputdir build main.hs
