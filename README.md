# Logtalk + CPLINT container

## DISCLAIMER ##

The is a first cut a providing a Docker container with CPLINT layered
on top of Logtalk, all of which will be running under SWI Prolog on a
minimal Debian system.  It is still quite raw.

Running the images requires connecting to a Docker volume which will
provide storage for persistent saved states.

# Instructions (on a Linux or macOS system):

## building the images

Requirements: a Posix environment with Docker.

### prolog, logtalk and cplint images

Doing "make TARGET", where TARGET may be one of "prolog", "logtalk" or
"cplint" will build a Docker image with the name of the target. The
resulting image will be based on a minimal Debian (bullseye) system.

### running the images

#### starting Prolog

To start a container based on one of the images, one may use the Make
target: "run-XXX", where XXX is the name of an image to start.  This
will launch a container based on that image, with the directory
$(PWD)/data connected to /root/data in the container.  This directory
(volume) will be used to store Prolog saved states, which will contain
all the relevant bits from the previous session.

Running an image in this way is equivalent to doing (e.g. for cplint):

	docker run -ti -v $LOCALDATADIR:/root/data cplint

where $LOCALDATADIR is the path to the volume in the host,
e.g. $PWD/data on a macOS or Linux machine to indicate the
subdirectory "data" in the current directory.

#### saving the state

When running the Prolog session, one may give the goal:

	?- save.

which will save the state of the program to a file in the data volume
(see above).  The effect of this is that whatever was loaded into the
Prolog workspace (including foreign libraries and operator
definitions) at the time save/0 is called as above, will be used for
the next activation of the container (or another container based on
the same image.)

There is a variant: the save/1 predicate may be used to indicate a
name for the (versioned and restartable) saved state.  For example:

	?- [library(clpfd)], save(clpfd).

Will save the current workspace, after having consulted the CLP(FD)
Prolog library.

To use the newly saved "clpfd" state, one may run the container as
follows:

	docker run -ti -v $PWD/data:/root/data cplint clpfd

Calling save/0 after having called save/1 will default to using the
same name as previously used with save/1.

# Example session

These are run from a shell.  ^D is "Control-D" and stands for the
end-of-file char.

1. Make the cplint image:

		15:52:37$ make cplint
		[ -e logtalk_3.39.0-1_all.deb ] || wget -q https://logtalk.org/files/logtalk_3.39.0-1_all.deb
		ln -sf logtalk_3.39.0-1_all.deb logtalk.deb
		docker build prolog --tag prolog:latest
		Sending build context to Docker daemon  2.048kB
		Step 1/3 : FROM debian:bullseye-slim
		bullseye-slim: Pulling from library/debian
		bbd74bee8c69: Pull complete 
			...
		Removing intermediate container 95a37fe946d3
		---> 9faebe81644c
		Successfully built 9faebe81644c
		Successfully tagged cplint:latest
		docker tag cplint:latest rodalvas/cplint:latest
		15:53:53$ 

2. Run it and do something:

		15:55:45$ docker run -ti -v $PWD/data:/root/data cplint 
		docker.cplint version 0.1 (cplint-2020.07.18-145351)
		?- p(X).
		ERROR: Unknown procedure: p/1 (DWIM could not correct goal)
		?- [user].
		|: p(1).
		|: p(2).
		|: ^D
		% user://1 compiled 0.00 sec, 2 clauses
		true.

		?- p(X).
		X = 1 ;
		X = 2.

		?- save.
		% Disabled autoloading (loaded 0 files)
		saved docker.cplint version 0.1 (cplint-2020.07.18-145623)
		true.

		?- ^D

		15:56:26$ 

3. Resume the session, from we left off:

		15:58:13$ docker run -ti -v $PWD/data:/root/data cplint 
		docker.cplint version 0.1 (cplint-2020.07.18-145623)
		?- p(X).
		X = 1 ;
		X = 2.

		?- ^D

		15:58:21$ 

4. Starting from cplint, make a version which extends it with CLP(FD):

		15:58:21$ docker run -ti -v $PWD/data:/root/data cplint 
		docker.cplint version 0.1 (cplint-2020.07.18-145623)
		?- [library(clpfd)].
		true.

		?- X #< 10.
		X in inf..9.

		?- save(clpfd).
		% Disabled autoloading (loaded 0 files)
		saved docker.clpfd version 0.1 (clpfd-2020.07.18-145935)
		true.

		?- ^D

		15:59:41$ 
		15:59:43$ docker run -ti -v $PWD/data:/root/data cplint clpfd
		docker.clpfd version 0.1 (clpfd-2020.07.18-145935)
		?- X #> 8.
		X in 9..sup.

		?- ^D

		15:59:54$ 


# Notes

At present, there is an unresolved interference between CPLINT and
Logtalk which may cause some occasional glitches.
