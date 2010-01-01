Rem
	bbdoc: Composite goal type
End Rem
Type TGoalComposite Extends TGoal
	Field m_SubGoals:TList = New TList
	
	Rem
		bbdoc: when this Object is destroyed make sure any subgoals are terminated and destroyed
	End Rem
	Method Destroy()
		Self.RemoveAllSubgoals()
		Super.Destroy()
	End Method
	
	Rem
		bbdoc: processes any subgoals that may be present this method first removes any completed goals from the front of the subgoal list. It then processes the next goal in the list (if there is one)
	End Rem
	Method ProcessSubgoals:Int()
		'remove all completed and failed goals from the front of the subgoal list
		While(Not Self.m_SubGoals.IsEmpty() And (TGoal(Self.m_SubGoals.First()).IsComplete() Or TGoal(Self.m_SubGoals.First()).HasFailed()))
			TGoal(Self.m_SubGoals.First()).Terminate()
			Self.m_SubGoals.RemoveFirst()
		Wend
		
		'if any subgoals remain, process the one at the front of the list
		If Not Self.m_SubGoals.IsEmpty()
			'grab the status of the front-most subgoal
			Local StatusOfSubGoals:Int = TGoal(Self.m_SubGoals.First()).Process()
		    'we have to test for the special case where the front-most subgoal
		    'reports 'completed' *and* the subgoal list contains additional goals.When
		    'this is the case, to ensure the parent keeps processing its subgoal list
		    'we must return the 'active' status.
			If StatusOfSubGoals = STATUS_COMPLETED And Self.m_SubGoals.Count() > 1
				Return STATUS_ACTIVE
			End If
			Return StatusOfSubGoals
		'no more subgoals to process - return 'completed'
		Else
			Return STATUS_COMPLETED
		End If
	End Method
	
	Rem
		bbdoc: passes the message To the front - most subgoal
	End Rem
	Method ForwardMessageToFrontMostSubgoal:Int(Message:Object)
		If Not Self.m_SubGoals.IsEmpty()
			Return TGoal(Self.m_SubGoals.First()).HandleMessage(Message)
		End If
		Return False
	End Method
	
	Rem
		bbdoc: logic to run when the goal is activated.
	End Rem
	Method Activate() Abstract
	
	Rem
		bbdoc: logic to run each update-step
	End Rem
	Method Process:Int() Abstract
	
	Rem
		bbdoc: logic to run when the goal is satisfied. (typically used to switch off, for example, any active steering behaviors)
	End Rem
	Method Terminate() Abstract
	
	Rem
		bbdoc: if a child class of TGoalComposite does not define a message handler the default behavior is to forward the message to the front-most goal
	End Rem
	Method HandleMessage:Int(message:Object)
		Return Self.ForwardMessageToFrontMostSubgoal(message)
	End Method

	Rem
		bbdoc: adds a subgoal to the front of the subgoal list
	End Rem
	Method AddSubgoal(goal:TGoal)
		'add the new goal to the front of the list	
		Self.m_SubGoals.AddFirst(goal)
	End Method
	
	Rem
		bbdoc: this method iterates through the subgoals and calls each one's Terminate method before deleting the subgoal and removing it from the subgoal list
	End Rem
	Method RemoveAllSubgoals()
		For Local goal:TGoal = EachIn Self.m_SubGoals
			goal.Terminate()
			goal.Destroy()
		Next
		
		Self.m_SubGoals.Clear()
	End Method
	
	Rem
		bbdoc: Display information about goal. For debugging purposes
	End Rem
	Method RenderAtPos(x:Double Var, y:Double Var)
		Super.RenderAtPos(x, y)

		If Not Self.m_SubGoals.IsEmpty()
			x:+10
			
			For Local goal:TGoal = EachIn Self.m_SubGoals
				goal.RenderAtPos(x, y)
			Next
			
			x:-10
		End If
	End Method
End Type