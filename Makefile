VENDOR_DIR=./vendor

clone:
	@cd $(VENDOR_DIR); git clone https://github.com/nkmr-jp/gravity-bridge.git
	@cd $(VENDOR_DIR)/gravity-bridge; git checkout v0.1.1

# See: https://github.com/cosmos/gravity-bridge/tree/v0.1.1#run-gravity-bridge-right-now-using-docker
test:
	@cd $(VENDOR_DIR)/gravity-bridge; bash tests/all-up-test.sh > ../../data/log/all-up-test-$(shell date +%s).log