if (sim_call_type==sim_childscriptcall_initialization) then
    -- Make sure that you comply with the initializations of handles below
    -- Do not change anything below


    simExtRemoteApiStart(19999)
    robot_handle = simGetObjectHandle('CollectorBot')
    cylinder_handle1 = simGetObjectHandle('Cylinder1')
    cylinder_handle2 = simGetObjectHandle('Cylinder2')
    cylinder_handle3 = simGetObjectHandle('Cylinder3')
    cylinder_handle4 = simGetObjectHandle('Cylinder4')
    cylinder_handle5 = simGetObjectHandle('Cylinder5')
    cylinder_handle6 = simGetObjectHandle('Cylinder6')
    cylinder_handle7 = simGetObjectHandle('Cylinder7')
    cylinder_handle8 = simGetObjectHandle('Cylinder8')

    leftmotor = simGetObjectHandle('left_joint')
    rightmotor= simGetObjectHandle('right_joint')

    path_handle = simGetObjectHandle('Path')  
    path_plan_handle = simGetPathPlanningHandle('PathPlanningTask')

    collection_handle=simGetCollectionHandle('Collection')

    fruits = {cylinder_handle1,cylinder_handle2,cylinder_handle3,cylinder_handle4,cylinder_handle5,cylinder_handle6,cylinder_handle7,cylinder_handle8}

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
