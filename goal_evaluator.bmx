Rem
	bbdoc: Base class to create a goal evaluator
End Rem
Type TGoalEvaluator Abstract
'when the desirability score for a goal has been evaluated it is multiplied 
	'by this value. It can be used to create bots with preferences based upon
	'their personality
	Field m_dCharacterBias:Double
	
	Rem
		bbdoc: Object creation
	End Rem
	Method Create:Object(CharacterBias:Double)
		Self.m_dCharacterBias = CharacterBias
		Return Self
	End Method
	
	Rem
		bbdoc: returns a score between 0 and 1 representing the desirability of the strategy the concrete subclass represents
	End Rem
	Method CalculateDesirability:Double(Owner:Object) Abstract
	
	Rem
		bbdoc: adds the appropriate goal to the given bot's brain
	End Rem
	Method SetGoal(Owner:Object) Abstract
End Type
