#ifndef fileName.toUpperCase()_H
#define fileName.toUpperCase()_H

#include "../../TestFramework/TestControl.h"

var constants = language.statements.filter(typeof(DefineConst))
var addConstants = language.statements.filter(typeof(AddConst))

FOR constant : constants
	createPreprocessorDefine(constant, addConstants)
ENDFOR

FOR defineVar : language.statements.filter(typeof(DefineVar))
	extern INT32U defineVar.name;
ENDFOR

FOR functionDeclaration : language.statements.filter(typeof(FunctionDeclaration))
	functionDeclaration.doFunctionDeclarationPrototype
ENDFOR

#endif
