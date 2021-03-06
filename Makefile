VENDOR_DIR=./vendor
TS=$(shell date +%s)

clone:
	@cd $(VENDOR_DIR); git clone https://github.com/nkmr-jp/gravity-bridge.git
	@cd $(VENDOR_DIR)/gravity-bridge; git checkout mylog

# See: https://github.com/cosmos/gravity-bridge/tree/v0.1.1#run-gravity-bridge-right-now-using-docker
all-up-test:
	@cd $(VENDOR_DIR)/gravity-bridge; bash tests/all-up-test.sh
	@#cd $(VENDOR_DIR)/gravity-bridge; bash tests/all-up-test.sh >& ../../data/log/all-up-test-$(TS).log

build-cmd:
	cd $(VENDOR_DIR)/gravity-bridge/module; make

rust-doc:
	cd $(VENDOR_DIR)/gravity-bridge/orchestrator; cargo doc --open

rust-test:
	cd $(VENDOR_DIR)/gravity-bridge/orchestrator; cargo test --all
log:
	@cat $(shell ls -1t $(VENDOR_DIR)/gravity-bridge/data/container/json_log/* | sed q)
