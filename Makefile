all: compile

compile:
	@ ocamlc -c prolog.ml
	@ ocamllex lexer.mll
	@ ocamlyacc parser.mly
	@ ocamlc -c parser.mli
	@ ocamlc -c lexer.ml
	@ ocamlc -c parser.ml
	@ ocamlc -c interpreter.ml
	@ ocamlc -o interpreter prolog.cmo lexer.cmo parser.cmo interpreter.cmo

run:
	@ ./interpreter database.pl

clean:
	@ rm lexer.ml lexer.cmi lexer.cmo parser.cmi parser.cmo parser.ml parser.mli prolog.cmo prolog.cmi interpreter.cmo interpreter.cmi interpreter