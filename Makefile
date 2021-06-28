# Dapp Build Config.
export DAPP_BUILD_OPTIMIZE=1
export DAPP_BUILD_OPTIMIZE_RUNS=1000000000
export DAPP_LINK_TEST_LIBRARIES=0
export DAPP_TEST_SOLVER=z3
ifeq ($(CI), true)
  export DAPP_TEST_FUZZ_RUNS=500000 # In CI we want to fuzz for a long time.
else
  export DAPP_TEST_FUZZ_RUNS=1000 # When developing we only want to fuzz briefly. 
endif

# Install, update, build and test everything.
all: solc install update build test
# Install proper solc version.
solc:; nix-env -f https://github.com/dapphub/dapptools/archive/master.tar.gz -iA solc-static-versions.solc_0_8_6
# Install npm dependencies.
install:; npm install
# Install dapp dependencies.
update:; dapp update

# Compiles the project.
build:; dapp build
# Test the project and only log verbose info for failed tests.
test:; dapp test --verbosity 1
# Test the project and show ds-test logs for everything.
vtest:; dapp test --verbosity 2
# Test the project and log full verbose info for everything.
vvtest:; dapp test --verbosity 3
# Run a test using the HEVM interactive debugger.
debug:; dapp debug
# Replay a failing property based test in the debugger.
replay:; dapp debug --replay '$(TARGET)'