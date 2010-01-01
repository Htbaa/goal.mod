SuperStrict

Import htbaapub.goal

Const GOAL_FART:Int = 100
Const GOAL_SING:Int = 101
Const GOAL_JUMP:Int = 102

Type TActor
	Field name:String
	Field m_pBrain:TBotGoalThink
	Field currentSong:String
	
	Method New()
		Self.m_pBrain = TBotGoalThink(New TBotGoalThink.Create(Self, 1))
		Self.name = "John Doe"
	End Method
	
	Method Destroy()
		Self.m_pBrain.Destroy()
	End Method
	
	Method Update()
		Self.m_pBrain.Process()
	End Method
	
	Method ToString:String()
		Return "Hello! My name's: " + Self.name
	End Method
End Type

Type TBotGoalThink Extends TGoalComposite
	Field m_Evaluators:TList = New TList

	Method New()
		Self.m_Evaluators.AddLast(TBotSingGoalEvaluate(New TBotSingGoalEvaluate.Create(1)))
		Self.m_Evaluators.AddLast(TBotJumpGoalEvaluate(New TBotJumpGoalEvaluate.Create(1)))
	End Method
	
	Method Activate()
		Self.Arbitrate()
		Self.m_iStatus = STATUS_ACTIVE
	End Method
	
	Method Process:Int()
  		'If status is inactive, call Activate()
  		Self.ActivateIfInactive()

		Local SubgoalStatus:Int = Self.ProcessSubgoals()
		
		If SubgoalStatus = STATUS_COMPLETED Or SubgoalStatus = STATUS_FAILED
			Self.m_iStatus = STATUS_INACTIVE
		End If
		
  		Return Self.m_iStatus
	End Method
	
	Method Terminate()
		Self.Destroy()
	End Method
	
	Rem
		bbdoc: this method iterates through each goal evaluator and selects the one
		that has the highest score as the current goal
	End Rem
	Method Arbitrate()
		Local best:Double = 0
		Local MostDesirable:TGoalEvaluator
		
		For Local curDes:TGoalEvaluator = EachIn Self.m_Evaluators
			Local desirability:Double = TGoalEvaluator(curDes).CalculateDesirability(Self.m_pOwner)
			If desirability >= best
				best = desirability
				MostDesirable = curDes
			End If
		Next
		
		Assert MostDesirable, "TBotGoalThink.Arbitrate() no evaluator selected!"
		Print "MostDesirable: " + TTypeId.ForObject(MostDesirable).Name() + " at " + best
		MostDesirable.SetGoal(Self.m_pOwner)
	End Method
	
	Rem
		bbdoc: returns true if the given goal is not at the front of the subgoal list 
	End Rem
	Method NotPresent:Int(GoalType:Int)
		If Not Self.m_SubGoals.IsEmpty()
			Return Not TGoal(Self.m_SubGoals.First()).GetType() = GoalType
		End If
		Return True
	End Method
	
	'Top level goal types
	Method AddGoal_Sing()
		If Self.NotPresent(GOAL_SING)
			'Self.RemoveAllSubgoals()
			Self.AddSubgoal(TBotGoalSing(New TBotGoalSing.Create(Self.m_pOwner, GOAL_SING)))
		End If
	End Method
	
	Method AddGoal_Jump()
		If Self.NotPresent(GOAL_JUMP)
			'Self.RemoveAllSubgoals()
			Self.AddSubgoal(TBotGoalJump(New TBotGoalJump.Create(Self.m_pOwner, GOAL_JUMP)))
		End If
	End Method
	
End Type

Type TBotGoalFart Extends TGoal
	Method Activate()
		Self.m_iStatus = STATUS_ACTIVE
	End Method
	
	Method Process:Int()
  		'If status is inactive, call Activate()
  		Self.ActivateIfInactive()
		Print "I'm farting!"
		Self.m_iStatus = STATUS_COMPLETED
  		Return Self.m_iStatus
	End Method
	
	Method Terminate()
		
	End Method
End Type

Type TBotGoalSing Extends TGoalComposite
	Method Activate()
		Self.m_iStatus = STATUS_ACTIVE
		Self.RemoveAllSubgoals()
		'Self.AddSubgoal(TBotGoalJump(New TBotGoalJump.Create(Self.m_pOwner, GOAL_JUMP)))
		'Self.AddSubgoal(TBotGoalFart(New TBotGoalFart.Create(Self, GOAL_FART)))
	End Method
	
	Method Process:Int()
  		'If status is inactive, call Activate()
  		Self.ActivateIfInactive()
		Print "I'm singing"
		TActor(Self.m_pOwner).currentSong = "song nr " + Rand(1, 100)
  		Self.m_iStatus = Self.ProcessSubgoals()
		Return Self.m_iStatus
	End Method
	
	Method Terminate()
		TActor(Self.m_pOwner).currentSong = Null
	End Method
End Type

Type TBotSingGoalEvaluate Extends TGoalEvaluator
	Method CalculateDesirability:Double(Owner:Object)
		'Sing a song once
		If TActor(Owner).currentSong <> Null
			Return 0.0
		Else
			Return RndFloat()
		End If
	End Method
	
	Method SetGoal(Owner:Object)
		TActor(Owner).m_pBrain.AddGoal_Sing()
	End Method
End Type

Type TBotGoalJump Extends TGoalComposite
	Method Activate()
		Self.m_iStatus = STATUS_ACTIVE
		Self.RemoveAllSubgoals()
		Self.AddSubgoal(TBotGoalFart(New TBotGoalFart.Create(Self.m_pOwner, GOAL_FART)))
	End Method
	
	Method Process:Int()
  		'If status is inactive, call Activate()
  		Self.ActivateIfInactive()
		Print "I'm jumping"
  		Self.m_iStatus = Self.ProcessSubgoals()
		Return Self.m_iStatus
	End Method
	
	Method Terminate()
		
	End Method
End Type

Type TBotJumpGoalEvaluate Extends TGoalEvaluator
	Method CalculateDesirability:Double(Owner:Object)
		Return RndFloat()
	End Method
	
	Method SetGoal(Owner:Object)
		TActor(Owner).m_pBrain.AddGoal_Jump()
	End Method
End Type


Local actor:TActor = New TActor
Print actor.ToString()

For Local i:Int = 0 To 200
	Print "Count: " + actor.m_pBrain.m_SubGoals.Count()
	actor.Update()
Next
