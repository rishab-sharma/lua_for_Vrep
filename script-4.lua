
if (sim_call_type==sim_childscriptcall_initialization) then

    -- Put some initialization code here
    leftMotor=simGetObjectHandle('left_joint')
    rightMotor=simGetObjectHandle('right_joint')
    
    robot_handle=simGetObjectHandle('CollectorBot')
    path_handle=simGetObjectHandle('Path')

    pos_on_path=0
    distance=0
    
    path_plan_handle=simGetPathPlanningHandle('PathPlanningTask')
    planstate=simSearchPath(path_plan_handle,2)
    
    start_dummy_handle=simGetObjectHandle('Start')

    -- Make sure you read the section on "Accessing general-type objects programmatically"
    -- For instance, if you wish to retrieve the handle of a scene object, use following instruction:
    --
    -- handle=simGetObjectHandle('sceneObjectName')
    -- 
    -- Above instruction retrieves the handle of 'sceneObjectName' if this script's name has no '#' in it
    --
    -- If this script's name contains a '#' (e.g. 'someName#4'), then above instruction retrieves the handle of object 'sceneObjectName#4'
    -- This mechanism of handle retrieval is very convenient, since you don't need to adjust any code when a model is duplicated!
    -- So if the script's name (or rather the name of the object associated with this script) is:
    --
    -- 'someName', then the handle of 'sceneObjectName' is retrieved
    -- 'someName#0', then the handle of 'sceneObjectName#0' is retrieved
    -- 'someName#1', then the handle of 'sceneObjectName#1' is retrieved
    -- ...
    --
    -- If you always want to retrieve the same object's handle, no matter what, specify its full name, including a '#':
    --
    -- handle=simGetObjectHandle('sceneObjectName#') always retrieves the handle of object 'sceneObjectName' 
    -- handle=simGetObjectHandle('sceneObjectName#0') always retrieves the handle of object 'sceneObjectName#0' 
    -- handle=simGetObjectHandle('sceneObjectName#1') always retrieves the handle of object 'sceneObjectName#1'
    -- ...
    --
    -- Refer also to simGetCollisionhandle, simGetDistanceHandle, simGetIkGroupHandle, etc.
    --
    -- Following 2 instructions might also be useful: simGetNameSuffix and simSetNameSuffix

end


if (sim_call_type==sim_childscriptcall_actuation) then

    -- Put your main ACTUATION code here
    rob_pos=simGetObjectPosition(robot_handle,-1)
    path_pos=simGetPositionOnPath(path_handle,pos_on_path)
    
    m=simGetObjectMatrix(robot_handle,-1)
    m=simGetInvertedMatrix(m)
    path_pos=simMultiplyVector(m,path_pos)

    distance=math.sqrt(path_pos[1]^2 + path_pos[2]^2)
    phi=math.atan2(path_pos[2],path_pos[1])
    
    if(pos_on_path<1) then
        v_des=0.1
        w_des=0.8*phi
    else
        v_des=0
        w_des=0
    end
    wheel_separation=0.208

    v_r=v_des+(wheel_separation/2)*w_des
    v_l=v_des-(wheel_separation/2)*w_des

    wheel_diameter=0.0701
    wheel_radius=wheel_diameter/2

    w_r=v_r/wheel_radius
    w_l=v_l/wheel_radius
    
    simSetJointTargetVelocity(leftMotor,w_l)
    simSetJointTargetVelocity(rightMotor,w_r)

    if(distance<0.1) then
        pos_on_path=pos_on_path+0.1
    end
    -- For example:
    --
    -- local position=simGetObjectPosition(handle,-1)
    -- position[1]=position[1]+0.001
    -- simSetObjectPosition(handle,-1,position)

end


if (sim_call_type==sim_childscriptcall_sensing) then

    -- Put your main SENSING code here

end


if (sim_call_type==sim_childscriptcall_cleanup) then

    -- Put some restoration code here

end
