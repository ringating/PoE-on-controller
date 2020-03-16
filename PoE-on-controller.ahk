    ; created by Ringating (https://github.com/ringating)
    
    #Persistent
    #MaxHotkeysPerInterval 10000

    sendmode input
    SetDefaultMouseSpeed, 0
    CoordMode, Mouse, Screen

    ; constants
    leftRadius := 100
    rightRadius := 200
    mouseOriginX := 960
    mouseOriginY := 480
    deadzoneRadiusL := 0.2
    deadzoneRadiusR := 0.15
    perspectiveScalar := 1.25 ; x/this=y or y*this=x
    buttonScalarDefault := 6 ;multiplier when pressing corresponding button
    cursorSpeedSlow := 10
    cursorSpeedFast := 40
    
    ; variables
    leftX := 0
    leftY := 0
    rightX := 0
    rightY := 0
    moving := false
    abilityActive := false
    leftMoved := false
    buttonScalar := 1
    cursorSpeed := 1
    fToggled := false
    leftClickDown := false
    rightClickDown := false
    dpadNDown := false
    dpadSDown := false
    dpadEDown := false
    dpadWDown := false

    ; this section toggles the looping analog-to-cursor stuff
    scriptEnabled := false
    SetTimer, Update, 10
    SetTimer, Update, Off
    ,::
        scriptEnabled := !scriptEnabled
        if(scriptEnabled)
        {
            SetTimer, Update, On
        }
        else
        {
            SetTimer, Update, Off
        }
    return
    
    *2Joy1::
        abilityActive := true
        Send {q down}
        KeyWait 2Joy1
        Send {q up}
        abilityActive := false
    return
    
    *2Joy2::
        abilityActive := true
        Send {w down}
        KeyWait 2Joy2
        Send {w up}
        abilityActive := false
    return
    
    *2Joy3::
        abilityActive := true
        Send {e down}
        KeyWait 2Joy3
        Send {e up}
        abilityActive := false
    return
    
    *2Joy4::
        abilityActive := true
        Send {r down}
        KeyWait 2Joy4
        Send {r up}
        abilityActive := false
    return
    
    *2Joy8::
        abilityActive := true
        Send {i down}
        KeyWait 2Joy8
        Send {i up}
        abilityActive := false
    return
    
    *2Joy10::
        if(fToggled)
        {
            Send {f up}
            fToggled := false
        }
        else
        {
            Send {f down}
            fToggled := true
        }
    return
    
    *2Joy5::1
    
    *2Joy7::escape

return


Update:
    leftX := -(50 - GetKeyState("2JoyX"))/50
    leftY := (-(50 - GetKeyState("2JoyY"))/50) / perspectiveScalar
    
    rightX := -(50 - GetKeyState("2JoyU"))/50
    rightY := -(50 - GetKeyState("2JoyR"))/50
    
    if(GetKeyState("2Joy6") == 1)
    {
        buttonScalar := buttonScalarDefault
        cursorSpeed := cursorSpeedFast
    }
    else
    {
        buttonScalar := 1
        cursorSpeed := cursorSpeedSlow
    }
    
    if(GetKeyState("2JoyZ") < 0.2)
    {
        if(!leftClickDown)
        {
            Click, down
            leftClickDown := true
        }
    }
    else
    {
        if(leftClickDown)
        {
            Click, up
            leftClickDown := false
        }
    }
    
    if(GetKeyState("2JoyZ") > 95)
    {
        if(!rightClickDown)
        {
            Click, down, right
            rightClickDown := true
        }
    }
    else
    {
        if(rightClickDown)
        {
            Click, up, right
            rightClickDown := false
        }
    }
    
    if(GetKeyState("2JoyPOV") == 0)
    {
        if(!dpadNDown)
        {
            Send {2 down}
            dpadNDown := true
        }
    }
    else
    {
        if(dpadNDown)
        {
            Send {2 up}
            dpadNDown := false
        }
    }
    
    if(GetKeyState("2JoyPOV") == 27000)
    {
        if(!dpadWDown)
        {
            Send {3 down}
            dpadWDown := true
        }
    }
    else
    {
        if(dpadWDown)
        {
            Send {3 up}
            dpadWDown := false
        }
    }
    
    if(GetKeyState("2JoyPOV") == 18000)
    {
        if(!dpadSDown)
        {
            Send {4 down}
            dpadSDown := true
        }
    }
    else
    {
        if(dpadSDown)
        {
            Send {4 up}
            dpadSDown := false
        }
    }
    
    if(GetKeyState("2JoyPOV") == 9000)
    {
        if(!dpadEDown)
        {
            Send {5 down}
            dpadEDown := true
        }
    }
    else
    {
        if(dpadEDown)
        {
            Send {5 up}
            dpadEDown := false
        }
    }
    
    
    
    Gosub, MoveCursor
    
    if(!abilityActive)
    {
        if(leftMoved && !rightMoved)
        {
            if(!moving)
            {
                Click, down
                moving := true
            }
        }
        else
        {
            if(moving)
            {
                Click, up
                moving := false
                
                MouseMove, mouseOriginX, mouseOriginY
                Click ;this should stop the character in place
            }
        }
    }
    
return


MoveCursor:

    leftMoved := (Sqrt(leftX*leftX + leftY*leftY) > deadzoneRadiusL)
    rightMoved := (Sqrt(rightX*rightX + rightY*rightY) > deadzoneRadiusR)
    
    if(rightMoved)
    {
        MouseMove, rightX * cursorSpeed, rightY * cursorSpeed, , R
    }
    else
    {
        if(leftMoved)
        {
            MouseMove, (mouseOriginX + leftX * leftRadius * buttonScalar), (mouseOriginY + leftY * leftRadius * buttonScalar)
        }
    }
return