#!/usr/bin/env python3
import tf
import math
import numpy as np
import rospy
from nav_msgs.msg import Odometry
from geometry_msgs.msg import Twist
current_y = 0.0
current_x = 0.0
twist_angle = 0.0
cmd_vel_pub = None
cumulative_transform = np.eye(4)
def counter_callback(msg):
	# Print out the x position from the odometry message
	#rate = rospy.Rate(1) 
	global current_x
	global current_y
	global twist_angle
	orientation_q = msg.pose.pose.orientation
	euler = tf.transformations.euler_from_quaternion([orientation_q.x, orientation_q.y, orientation_q.z, orientation_q.w])
	
	twist_angle = euler[2]
	current_y = msg.pose.pose.position.y
	current_x = msg.pose.pose.position.x

def cartesian2polar(x,y,theta): 
	rho = math.sqrt((x)**2 + (y)**2)

	alpha = -theta + math.atan2(y,x)

	beta = -(theta+alpha) 

	#rospy.loginfo("\n rho = %f alpha = %f beta= %f\n", rho, alpha , beta);
	#rospy.loginfo("\n*x = %fy= %f theta= %f\n", current_x, current_y, twist_angle);

	a = [rho , alpha , beta ] 
	return a 

def transformcoordinates(destination_x, destination_y, destination_theta):
	global current_x, current_y, twist_angle, start_x,start_y,start_angle
	dx=current_x-start_x
	dy=current_y-start_y
	dtheta=twist_angle-start_angle
	RitoR0 = np.array([[math.cos(dtheta),-math.sin(dtheta), 0, dx],
					   [math.sin(dtheta), math.cos(dtheta), 0, dy],
					   [0, 0, 1, 0],
					   [0, 0, 0, 1]])
	ItoR0 = np.array([[math.cos(destination_theta),-math.sin(destination_theta), 0, destination_x],
						[math.sin(destination_theta), math.cos(destination_theta), 0, destination_y],
						[0, 0, 1, 0],
						[0, 0, 0, 1]])


	RitoI=np.matmul(np.linalg.inv(RitoR0),ItoR0)
	delta_x = RitoI[0][3]
	delta_y = RitoI[1][3]
	theta = math.atan2(RitoI[1][0],RitoI[0][0])
	a = [delta_x, delta_y, theta]
	#rospy.loginfo("\ntransform** error-> x  = %f y  = %f theta= %f\n", delta_x, delta_y ,math.degrees( theta));

	return a


def compute_vw( pitch, roll , beta , Kpitch, Kroll, Kbeta): 
    K=np.array([[Kpitch, 0, 0],
                [0 , Kroll , Kbeta]]) 
    X=np.array([[pitch],
                [roll],
                [beta]])
    vw = np.matmul(K,X)

    return vw


def velocity_publisher(v , w):
    
    move_cmd  = Twist()

    rospy.loginfo("v = %f u = %f " , v, w )
     
    move_cmd.linear.x = v
    move_cmd.angular.z = w
   
    cmd_vel_pub.publish(move_cmd) 
    

def reachPoint(destination_x, destination_y, destination_angle):
	rospy.sleep(1)
	global current_x, current_y, twist_angle, start_x,start_y,start_angle
	start_x=current_x
	start_y=current_y
	start_angle=twist_angle
	global cumulative_transform
	# cumulative_transform is the transformation for the new destination with respect to the last current
	destination_theta = np.radians(destination_angle)
	cumuative_transfom=np.array([[math.cos(start_angle),-math.sin(start_angle), 0, start_x],
					   [math.sin(start_angle), math.cos(start_angle), 0, start_y],
					   [0, 0, 1, 0],
					   [0, 0, 0, 1]])
	destination_transform = np.array([
		[math.cos(destination_theta), -math.sin(destination_theta), 0, destination_x],
		[math.sin(destination_theta), math.cos(destination_theta), 0, destination_y],
		[0, 0, 1, 0],
		[0, 0, 0, 1]
	])

	cumulative_transform = np.matmul(cumulative_transform, destination_transform)

	# Extract the current position from the cumulative transform
	transformed_x = cumulative_transform[0, 3]
	transformed_y = cumulative_transform[1, 3]
	transformed_theta = math.atan2(cumulative_transform[1, 0], cumulative_transform[0, 0])

	# Compute error from the current position to the transformed destination
	xythetaArray = transformcoordinates(transformed_x, transformed_y,transformed_theta)

	errorArray = cartesian2polar(xythetaArray[0], xythetaArray[1], xythetaArray[2])
	vw = compute_vw(errorArray[0], errorArray[1], errorArray[2], .15, 0.2, -0.3)
	velocity_publisher(vw[0], vw[1]) 

	while abs(errorArray[0])> .01 :
		xythetaArray = transformcoordinates(transformed_x,transformed_y,transformed_theta)
		errorArray = cartesian2polar(xythetaArray[0], xythetaArray[1] , xythetaArray[2])
		vw = compute_vw(errorArray[0],errorArray[1],errorArray[2],.15,0.2,-.3)
		velocity_publisher( vw[0],vw[1] )
		rate.sleep()
		
	velocity_publisher(0,0)



	while abs(xythetaArray[2]) > np.radians(5): 
		xythetaArray = transformcoordinates(transformed_x,transformed_y,transformed_theta)
		velocity_publisher(0,.5)
		#rospy.loginfo(" theta = %f " , xythetaArray[2])
		rate.sleep()		

		
	rospy.loginfo(" got out!!!!!!!!")
	# Keep the node running until manually stopped
	velocity_publisher(0,0)
	rospy.loginfo("\ncurrent_x  = %f current_y= %f twist_angle = %f\n", current_x, current_y ,np.degrees(twist_angle));

def main():
	rospy.sleep(1)
	global cmd_vel_pub
	# Initialize the ROS node
	rospy.init_node('odom_sub_node', anonymous=False)
	global rate
	rate = rospy.Rate(10) 
	# Create a subscriber to the "/odom" topic
	rospy.Subscriber("odom", Odometry, counter_callback)
	cmd_vel_pub = rospy.Publisher('/cmd_vel' , Twist , queue_size = 100) 

	reachPoint(1,-1,90)
	rospy.spin()



if __name__ == '__main__':
    main()
