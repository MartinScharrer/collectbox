LaTeX package 'collectbox'
~~~~~~~~~~~~~~~~~~~~~~~~~~
Copyright (c) 2010-2022 by Martin Scharrer <martin.scharrer@web.de>
License: LaTeX Project Public License, v1.3 or later: http://www.latex-project.org/lppl.txt
Repository: https://github.com/MartinScharrer/collectbox
Issues: https://github.com/MartinScharrer/collectbox/issues

This package provides macros to collect and process an macro argument (i.e.
something which looks like a macro argument) as horizontal box instead as a real
macro argument. These "arguments" will be stored like when using \savebox,
\sbox or the lrbox environment and allow verbatim or other special code. Instead
of explicit braces also implicit braces in the form of \bgroup and \egroup
are supported. This allows to split the begin and end over different macros or to
place them in the begin and end code of an environment. The provided macros are
mainly intended to be used inside other macros or environments
