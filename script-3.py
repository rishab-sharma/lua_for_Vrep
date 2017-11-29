## Task 1.2 - Path Planning in V-REP ##
# Import modules

import sys
import vrep
import math
import time
from collections import deque
from collections import defaultdict

def constructPath(cylinder_handles,start_dummy_handle,goal_dummy_handle):
	returnCode,start_position = vrep.simxGetObjectPosition(clientID, start_dummy_handle, -1, vrep.simx_opmode_buffer)
	returnCode,goal_position = vrep.simxGetObjectPosition(clientID, goal_dummy_handle, -1, vrep.simx_opmode_buffer)
	# Handle 0 cases everywhere	
	final_theta=math.atan( (goal_position[1]-start_position[1])/(goal_position[0]-start_position[0]) )
	if (goal_position[1]-start_position[1]) > 0 and (goal_position[0]-start_position[0]) < 0:
		final_theta = math.pi - final_theta
	elif (goal_position[1]-start_position[1]) < 0 and (goal_position[0]-start_position[0]) < 0:
		final_theta = math.pi + final_theta
	elif (goal_position[1]-start_position[1]) < 0 and (goal_position[0]-start_position[0]) > 0:
		final_theta = (math.pi * 2) - final_theta
	final_r = math.sqrt(((goal_position[1]-start_position[1])**2 + (goal_position[0]-start_position[0])**2 ))
	priority={}
	for cylinder_handle in cylinder_handles:
		returnCode,cylinder_coordinate = vrep.simxGetObjectPosition(clientID, cylinder_handle, -1, vrep.simx_opmode_buffer)
		theta=math.atan((cylinder_coordinate[1]-start_position[1])/(cylinder_coordinate[0]-start_position[0]) )
		if (cylinder_coordinate[1]-start_position[1]) > 0 and (cylinder_coordinate[0]-start_position[0]) < 0:
			theta = math.pi - theta
		elif (cylinder_coordinate[1]-start_position[1]) < 0 and (cylinder_coordinate[0]-start_position[0]) < 0:
			theta = math.pi + theta
		elif (cylinder_coordinate[1]-start_position[1]) < 0 and (cylinder_coordinate[0]-start_position[0]) > 0:
			theta = (math.pi * 2) - theta
		theta = final_theta - theta
		r = math.sqrt(((cylinder_coordinate[1]-start_position[1])**2 + (cylinder_coordinate[0]-start_position[0])**2 ))
		priority[cylinder_handle] = (theta,r)
		cylinder_order=sorted(priority, key = priority.get)
		cylinder_polar=sorted(priority.itervalues())
		cylinder_order.append(goal_dummy_handle)
		cylinder_polar.append((final_theta,final_r))
	return cylinder_order,cylinder_polar

# Write a function here to choose a goal.
def chooseGoal(cylinder_order,cylinder_polar):
	dist=cylinder_polar[0][1]
	for x in range(1,len(cylinder_polar)+1):
			dist += math.sqrt( (cylinder_polar[x][1] - cylinder_polar[x-1][1])**2 + min((cylinder_polar[x][1], cylinder_polar[x-1][1]))*(cylinder_polar[x][0] - cylinder_polar[x-1][0]) )

	# Minimize dist to set entire path, use fn makePath



# Write a function(s) to set/reset goal and other so that you can iterate the process of path planning

def makePath(priority_dict):
	general_path=list(priority_dict.items())
	
	







# Write a function to create a path from Start to Goal










# Write a function to make the robot move in the generated path. 
# Make sure that you give target velocities to the motors here in python script rather than giving in lua.
# Note that the your algorithm should also solve the conditions where partial paths are generated.

def moveOnPath(leftjoint_handle, rightjoint_handle, robot_handle, path_handle, start_dummy_handle, goal_dummy_handle):
	# Partial paths was not allowed in the path object. Need to take care of that.	
	pos_on_path=0
	distance=0
	wheel_sep=(0.208)/(2.0)
	wheel_radius=(0.0701)/(2.0)
	while pos_on_path < 1:
		returnCode, path_pos = vrep.simxCallScriptFunction(clientID,LuaFunctions,sim_scripttype_childscript(1),getPathCoordinates,'PathPlanningTask')
		# task1_cb/scene 1/LuaFunctions
		distance=math.sqrt(path_pos[1]**2 + path_pos[2]**2)
		phi=math.atan(path_pos[2]/path_pos[1])
		
		v_des=0.1
		w_des=0.8 * phi
		
		v_r = v_des + (wheel_sep * w_des)
		v_l = v_des - (wheel_sep * w_des)
		w_r = v_r / wheel_radius
		w_l = v_l / wheel_radius
		returnCode = vrep.simxSetJointTargetVelocity(clientID, leftjoint_handle, w_l, vrep_simx_opmode_streaming)
		returnCode = vrep.simxSetJointTargetVelocity(clientID, rightjoint_handle, w_r, vrep_simx_opmode_streaming)
		if distance < 0.1:
			pos_on_path += 0.01
	returnCode = vrep.simxSetJointTargetVelocity(clientID, leftjoint_handle, 0, vrep_simx_opmode_streaming)
	returnCode = vrep.simxSetJointTargetVelocity(clientID, rightjoint_handle, 0, vrep_simx_opmode_streaming)



################ Initialization of handles. Do not change the following section ###################################

vrep.simxFinish(-1)

clientID=vrep.simxStart('127.0.0.1',19999,True,True,5000,5)

if clientID!=-1:
	print "connected to remote api server"
else:
	print 'connection not successful'
	sys.exit("could not connect")

returnCode,robot_handle=vrep.simxGetObjectHandle(clientID,'CollectorBot',vrep.simx_opmode_oneshot_wait)
returnCode,leftjoint_handle=vrep.simxGetObjectHandle(clientID,'left_joint',vrep.simx_opmode_oneshot_wait)
returnCode,rightjoint_handle=vrep.simxGetObjectHandle(clientID,'right_joint',vrep.simx_opmode_oneshot_wait)
returnCode,start_dummy_handle = vrep.simxGetObjectHandle(clientID,'Start',vrep.simx_opmode_oneshot_wait)
returnCode,goal_dummy_handle = vrep.simxGetObjectHandle(clientID,'Goal',vrep.simx_opmode_oneshot_wait)

returnCode,cylinder_handle1=vrep.simxGetObjectHandle(clientID,'Cylinder1',vrep.simx_opmode_oneshot_wait )
returnCode,cylinder_handle2=vrep.simxGetObjectHandle(clientID,'Cylinder2',vrep.simx_opmode_oneshot_wait )
returnCode,cylinder_handle3=vrep.simxGetObjectHandle(clientID,'Cylinder3',vrep.simx_opmode_oneshot_wait )
returnCode,cylinder_handle4=vrep.simxGetObjectHandle(clientID,'Cylinder4',vrep.simx_opmode_oneshot_wait )
returnCode,cylinder_handle5=vrep.simxGetObjectHandle(clientID,'Cylinder5',vrep.simx_opmode_oneshot_wait )
returnCode,cylinder_handle6=vrep.simxGetObjectHandle(clientID,'Cylinder6',vrep.simx_opmode_oneshot_wait )
returnCode,cylinder_handle7=vrep.simxGetObjectHandle(clientID,'Cylinder7',vrep.simx_opmode_oneshot_wait )
returnCode,cylinder_handle8=vrep.simxGetObjectHandle(clientID,'Cylinder8',vrep.simx_opmode_oneshot_wait )

cylinder_handles=[cylinder_handle1,cylinder_handle2,cylinder_handle3,cylinder_handle4,cylinder_handle5,cylinder_handle6,cylinder_handle7,cylinder_handle8]

#####################################################################################################################

# Write your code here

cylinder_coordinates=[]
for cylinder_handle in cylinder_handles:
	returnCode,position = vrep.simxGetObjectPosition(clientID, cylinder_handle, -1, vrep.simx_opmode_buffer)
	cylinder_coordinates.append(position)
print(cylinder_coordinates)

returnCode,position = vrep.simxGetObjectPosition(clientID, cylinder_handle5, -1, vrep.simx_opmode_buffer)

constructPath(cylinder_handles,start_dummy_handle,goal_dummy_handle)

moveOnPath(leftjoint_handle, rightjoint_handle, robot_handle, path_handle, start_dummy_handle, goal_dummy_handle)

################     Do not change after this #####################

#end of simulation
vrep.simxStopSimulation(clientID,vrep.simx_opmode_oneshot)
