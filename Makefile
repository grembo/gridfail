CXX=c++
CXXFLAGS=-I/usr/local/include -I. -fPIC -pthread
LDFLAGS=-shared -L/usr/local/lib -lIce -lIceBox -lIceUtil


all:
	@echo "Building..."
	@slice2cpp Demo.ice
	@$(CXX) $(CXXFLAGS) $(LDFLAGS) Demo.cpp DemoServiceI.cpp -o libDemoService.so

run: kill all
	@mkdir -p dbregistry1 dbregistry2 dbnode
	@echo "Starting master registry"
	@icegridregistry --Ice.Config=config.registry1 &
	@sleep 2
	@echo "Starting replicant registry"
	@icegridregistry --Ice.Config=config.registry2 &
	@sleep 2
	@echo "Starting node"
	@icegridnode --Ice.Config=config.node &
	@sleep 2
	@echo "Remove app (in case it exists)"
	@-icegridadmin --Ice.Config=config.admin -e "application remove DemoApp" 2>/dev/null
	@sleep 2
	@echo "Installing app"
	@icegridadmin --Ice.Config=config.admin -e "application add app.xml"
	@sleep 2
	@echo "Starting app"
	@icegridadmin --Ice.Config=config.admin -e "server start DemoBox"
	@sleep 2
	@echo "Updating app - succeeds and stops it"
	@icegridadmin --Ice.Config=config.admin -e "application update app2.xml"
	@sleep 2
	@echo "Starting and stopping app until it uses replicant registry and fails"
	@while true; do \
		sleep 1; \
		echo "Start..."; \
		icegridadmin --Ice.Config=config.admin -e "server start DemoBox"; \
		echo "Stop..."; \
		icegridadmin --Ice.Config=config.admin -e "server stop DemoBox"; \
		sleep 1; \
	done

kill:
	@echo "Kill all registries and nodes"
	@-killall icegridregistry icegridnode
	@sleep 2

clean: kill
	@echo "Remove all generated files and registry/node data"
	@rm -f Demo.h Demo.cpp libDemoService.so *~ *.log
	@rm -rf dbregistry1 dbregistry2 dbnode
