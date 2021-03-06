icegrid replication problem
===========================

When adding a service to an icebox configuration using
icegridadmin, the updated replication definition won't propagate properly
until the icegridnode restarts.

This has been tested on ice 3.6.3.

How to test
-----------

Run:

```
make run
```

Note that this will kill all registries and nodes running
under your user.

Example output
--------------

```
Kill all registries and nodes
Building...
Starting master registry
Starting replicant registry
Starting node
Remove app (in case it exists)
Installing app
Starting app
Updating app - succeeds and stops it
Starting and stopping app until it uses replicant registry and fails
Start...
Stop...
Start...
Stop...
Start...
!! 09/06/17 11:35:25.930 DemoBox: error: ServiceManager: exception while starting service ServiceB:
   ObjectAdapterI.cpp:1274: Ice::NotRegisteredException:
    no object adapter with id `ServiceB' is registered
error: the server didn't start successfully:
The server terminated unexpectedly with exit code 1.
*** Error code 1

Stop.
make: stopped in /tmp/gridfail
```
