Given the field and source code, remove unwanted formatting created by some IDE's and copy the source code using the information stored 
in ```field.pos```.

Pass the code to [CodeHighlighter](https://github.com/tong/codehighlighter) for syntax highlighting, pass the documentation to 
[mdown](https://github.com/jasononeil/mdown) for markdown conversion.

Finally individual sections are created. Sections take the form:

		{
			docs_text: ...
			code_text: ...
			id: ...
		}