	
class fileName():
    
	def __init__(self, stm):
		self.stm = stm
		var constants = language.statements.filter(typeof(DefineConst))
		var addConstants = language.statements.filter(typeof(AddConst))FOR constant : constants
		createPreprocessorDefine(constant, addConstants)ENDFORFOR defineVar : language.statements.filter(typeof(DefineVar))
		defineVar.doDefineVarENDFOR
	
	FOR include : language.statements.filter(typeof(Include))
	include.doInclude
	ENDFOR
	
	FOR stat : language.statements
	stat.doStatement
	ENDFOR
