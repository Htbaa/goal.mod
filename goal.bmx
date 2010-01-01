SuperStrict

Rem
	bbdoc: htbaapub.goal
	about: Goals with hierarchy support
EndRem
Module htbaapub.goal
ModuleInfo "Name: htbaapub.goal"
ModuleInfo "Version: 1.00"
ModuleInfo "Author: Christiaan Kras"
ModuleInfo "Author of C++ code: Mat Buckland <a href='http://www.ai-junkie.com'>http://www.ai-junkie.com</a>"
ModuleInfo "Git repository: <a href='http://github.com/Htbaa/goal.mod/'>http://github.com/Htbaa/goal.mod/</a>"

Import brl.linkedlist
Import brl.max2d
Import brl.reflection

Include "goal_atomic.bmx"
Include "goal_composite.bmx"
Include "goal_evaluator.bmx"