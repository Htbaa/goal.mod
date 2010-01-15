Rem
	Copyright (c) 2010 Christiaan Kras
	
	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
End Rem

Rem
	bbdoc: Atomic Goal type
End Rem
Type TGoal Abstract
	Const STATUS_ACTIVE:Int = 0
	Const STATUS_INACTIVE:Int = 1
	Const STATUS_COMPLETED:Int = 2
	Const STATUS_FAILED:Int = 3

	Field m_iType:Int
	Field m_pOwner:Object
	Field m_iStatus:Int

	Rem
		bbdoc: note how goals start off in the inactive state
	End Rem
	Method Create:Object(pOwner:Object, iType:Int)
		Self.m_iStatus = STATUS_INACTIVE
		Self.m_pOwner = pOwner
		Self.m_iType = iType
		Return Self
	End Method
	
	Rem
		bbdoc: if m_iStatus = inactive this method sets it to active and calls Activate()
	End Rem
	Method ActivateIfInactive()
		If Self.IsInActive()
			Self.Activate()
		End If
	End Method
	Rem
		bbdoc: If m_iStatus is failed this Method sets it To inactive so that the goal will be reactivated (And therefore re - planned) on the Next update - Step
	End Rem
	Method ReactivateIfFailed()
		If Self.hasFailed()
			Self.m_iStatus = STATUS_INACTIVE
		End If
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
		bbdoc: goals can handle messages. Many don't though, so this defines a default behavior
	End Rem
	Method HandleMessage:Int(message:Object)
		Return False
	End Method

	Rem
		bbdoc: a Goal is atomic and cannot aggregate subgoals yet we must implement this method to provide the uniform interface required for the goal hierarchy.
	End Rem
	Method AddSubgoal(goal:TGoal)
		Throw "Cannot add goals to atomic goals"
	End Method

	Rem
		bbdoc: Check if goal has been completed
	End Rem
	Method IsComplete:Int()
		Return Self.m_iStatus = STATUS_COMPLETED
	End Method

	Rem
		bbdoc: Check if goal is still active
	End Rem
	Method IsActive:Int()
		Return Self.m_iStatus = STATUS_ACTIVE
	End Method

	Rem
		bbdoc: Check if goal is inactive
	End Rem
	Method IsInactive:Int()
		Return Self.m_iStatus = STATUS_INACTIVE
	End Method

	Rem
		bbdoc: Check if goal failed to perform its tasks
	End Rem
	Method HasFailed:Int()
		Return Self.m_iStatus = STATUS_FAILED
	End Method

	Rem
		bbdoc: Returns m_iType:Int
	End Rem
	Method GetType:Int()
		Return Self.m_iType
	End Method

	Rem
		bbdoc: when this Object is destroyed make sure any subgoals are terminated and destroyed
	End Rem
	Method Destroy()
		Self.m_pOwner = Null
	End Method

	Rem
		bbdoc: Display information about goal. For debugging purposes
	End Rem
	Method RenderAtPos(x:Double Var, y:Double Var)
		SetTransform(0, 1, 1)
		SetBlend(MASKBLEND)
		SetAlpha(1.0)
		
		Select Self.m_iStatus
			Case STATUS_ACTIVE
				SetColor(0, 0, 255)
			Case STATUS_INACTIVE
				SetColor(100, 0, 0)
			Case STATUS_FAILED
				SetColor(255, 0, 0)
			Case STATUS_COMPLETED
				SetColor(0, 255, 0)
		End Select
		
		y:+10
		
		DrawText(TTypeId.ForObject(Self).Name(), x, y)
	End Method
	
End Type