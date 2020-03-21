#include "fileName.h"

FOR include : language.statements.filter(typeof(Include))
	include.doInclude
ENDFOR
FOR defineVar : language.statements.filter(typeof(DefineVar))
	defineVar.doDefineVar
ENDFOR
FOR statement : language.statements.filter(typeof(FunctionDeclaration))
	statement.doDefineVar
ENDFOR
FOR statement : language.statements.filter(typeof(CondExpression))
	statement.doDefineVar
ENDFOR
FOR statement : language.statements.filter(typeof(ElseIf))
	statement.doDefineVar
ENDFOR
FOR statement : language.statements.filter(typeof(Else))
	statement.doDefineVar
ENDFOR
FOR statement : language.statements.filter(typeof(WhileExpression))
	statement.doDefineVar
ENDFOR
FOR statement : language.statements.filter(typeof(Loop))
	statement.doDefineVar
ENDFOR
FOR stat : language.statements
	stat.doStatement
ENDFOR
