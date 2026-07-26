# godot-graphics-exercises — regenerate and check.
#
# There is nothing to compile: these are Godot scripts. What can be checked is
# that they parse and that the generated files still match the LaTeX they come
# from.
#
# @author Ismael Sallami Moreno

.PHONY: all check extract diff-check lint clean

all: check

# Parse every .gd file. Known failures are listed in tools/known-parse-failures.txt.
check:
	./tools/check.sh

# Regenerate src/sessions and src/practicals from the LaTeX write-up.
extract:
	python3 tools/extract-from-latex.py

# Fail if the committed files differ from what the extractor produces, so the
# two cannot drift apart unnoticed.
diff-check: extract
	git diff --exit-code -- src/sessions src/practicals

# Style rules. Reported, not enforced: the code is a delivered artifact.
lint:
	-gdlint $$(find src -name '*.gd')

clean:
	rm -rf src/sessions src/practicals
