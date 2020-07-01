# Notes on cplint image #

- image includes cplint and logtalk, based on swi-prolog running on
  debian bullseye
  
- must run with an attached local directory to provide persistence,
  which must be mounted at /root/data. e.g.:
  
	  docker run -tiv /home/spa/xdir:/root/data rodalvas/cplint 

- (?) has an operator definition as per logtalk (200, fy), and is thus
  problematic for cplint, hence the workaround in cplint/Dockerfile
  
