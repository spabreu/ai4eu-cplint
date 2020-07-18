# Logtalk + CPLINT container

## DISCLAIMER ##

The is a first cut a providing a Docker container with CPLINT layered
on top of Logtalk, all of which will be running under SWI Prolog on a
minimal Debian system.  It is still quite raw.

Running the images requires connecting to a Docker volume which will
provide storage for persistent saved states.

# Instructions (on a Linux or macOS system):

## building the images

Requirements: a Posix environment with Docker and Makefile.

### prolog, logtalk and cplint images

Doing "make TARGET", where TARGET may be one of "prolog", "logtalk" or
"cplint" will build a Docker image with the name of the target. The
resulting will be based on a simple Debian (bullseye) image.

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

# Notes

At present, there is an unresolved interference between CPLINT and
Logtalk which may cause some occasional glitches.
