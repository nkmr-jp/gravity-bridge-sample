[Run Gravity bridge right now using docker](https://github.com/cosmos/gravity-bridge/tree/v0.1.1#run-gravity-bridge-right-now-using-docker)の`bash tests/all-up-test.sh`で出力されるログから、実行される内容を整理


# 1. Docker Image ビルド・コンテナ起動

```sh
+++ dirname tests/all-up-test.sh
++ cd tests
++ pwd
+ DIR=[path]/gravity-bridge/tests
+ bash [path]/gravity-bridge/tests/build-container.sh
+++ dirname [path]/gravity-bridge/tests/build-container.sh
++ cd [path]/gravity-bridge/tests
++ pwd
+ DIR=[path]/gravity-bridge/tests
+ DOCKERFOLDER=[path]/gravity-bridge/tests/dockerfile
+ REPOFOLDER=[path]/gravity-bridge/tests/..
+ pushd [path]/gravity-bridge/tests/..
~/[path]/gravity-bridge ~/[path]/gravity-bridge
+ git archive --format=tar.gz -o [path]/gravity-bridge/tests/dockerfile/peggy.tar.gz --prefix=peggy/ HEAD
+ pushd [path]/gravity-bridge/tests/dockerfile
~/[path]/gravity-bridge/tests/dockerfile ~/[path]/gravity-bridge ~/[path]/gravity-bridge
+ docker build -t peggy-base .
[+] Building 4.5s (20/20) FINISHED
 => [internal] load build definition from Dockerfile                                                                                                                                                                                                                         0.0s
 => => transferring dockerfile: 37B                                                                                                                                                                                                                                          0.0s
 => [internal] load .dockerignore                                                                                                                                                                                                                                            0.0s
 => => transferring context: 2B                                                                                                                                                                                                                                              0.0s
 => [internal] load metadata for docker.io/library/fedora:latest                                                                                                                                                                                                             2.8s
 => [ 1/13] FROM docker.io/library/fedora@sha256:d18bc88f640bc3e88bbfacaff698c3e1e83cae649019657a3880881f2549a1d0                                                                                                                                                            0.0s
 => [internal] load build context                                                                                                                                                                                                                                            0.5s
 => => transferring context: 15.04MB                                                                                                                                                                                                                                         0.5s
 => https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.10.1-c2d2f4ed.tar.gz                                                                                                                                                                                   1.1s
 => https://golang.org/dl/go1.15.6.linux-amd64.tar.gz                                                                                                                                                                                                                        0.5s
 => CACHED [ 2/13] RUN dnf install -y git make gcc gcc-c++ which iproute iputils procps-ng vim-minimal tmux net-tools htop tar jq npm openssl-devel perl                                                                                                                     0.0s
 => CACHED [ 3/13] ADD https://golang.org/dl/go1.15.6.linux-amd64.tar.gz /go/                                                                                                                                                                                                0.0s
 => CACHED [ 4/13] RUN cd /go && tar -xvf * && mv /go/**/ /usr/local/                                                                                                                                                                                                        0.0s
 => CACHED [ 5/13] RUN npm install -g ts-node && npm install -g typescript                                                                                                                                                                                                   0.0s
 => CACHED [ 6/13] ADD https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.10.1-c2d2f4ed.tar.gz /geth/                                                                                                                                                         0.0s
 => CACHED [ 7/13] RUN cd /geth && tar -xvf * && mv /geth/**/geth /usr/bin/geth                                                                                                                                                                                              0.0s
 => CACHED [ 8/13] RUN curl https://sh.rustup.rs -sSf | sh -s -- -y                                                                                                                                                                                                          0.0s
 => CACHED [ 9/13] ADD peggy.tar.gz /                                                                                                                                                                                                                                        0.0s
 => CACHED [10/13] ADD legacy-api-enable /                                                                                                                                                                                                                                   0.0s
 => CACHED [11/13] RUN pushd /peggy/orchestrator/ && PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/go/bin:$HOME/.cargo/bin cargo build --all --release                                                                                                  0.0s
 => CACHED [12/13] RUN pushd /peggy/module/ && PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/go/bin:/usr/local/go/bin GOPROXY=https://proxy.golang.org make && PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/go/bin:/usr/local/go  0.0s
 => CACHED [13/13] RUN pushd /peggy/solidity/ && npm ci                                                                                                                                                                                                                      0.0s
 => exporting to image                                                                                                                                                                                                                                                       0.0s
 => => exporting layers                                                                                                                                                                                                                                                      0.0s
 => => writing image sha256:13085ef437b2da04ea45cb71b23c6b5559e733a53df31457bf20cb7906f85b09                                                                                                                                                                                 0.0s
 => => naming to docker.io/library/peggy-base                                                                                                                                                                                                                                0.0s
+ set +e
+ docker rm -f peggy_all_up_test_instance
peggy_all_up_test_instance
+ set -e
+ NODES=3
+ set +u
+ TEST_TYPE=
+ ALCHEMY_ID=
+ set -u
+ docker run --name peggy_all_up_test_instance --cap-add=NET_ADMIN -t peggy-base /bin/bash /peggy/tests/container-scripts/all-up-test-internal.sh 3
```

# 2. コンテナ内でスクリプト実行

## 2-1. Setup Solidity

```sh
+ pushd /peggy/solidity/
/peggy/solidity /
+ HUSKY_SKIP_INSTALL=1
+ npm install
npm WARN read-shrinkwrap This version of npm is compatible with lockfileVersion@1, but npm-shrinkwrap.json was generated for lockfileVersion@2. I'll try to do my best with it!

> keccak@3.0.1 install /peggy/solidity/node_modules/ganache-core/node_modules/keccak
> node-gyp-build || exit 0

npm WARN eth-gas-reporter@0.2.22 requires a peer of @codechecks/client@^0.1.0 but none is installed. You must install peer dependencies yourself.
npm WARN gravity-contracts@1.0.0 No description
npm WARN gravity-contracts@1.0.0 No repository field.
npm WARN gravity-contracts@1.0.0 license should be a valid SPDX license expression

updated 2 packages and audited 2527 packages in 23.478s

152 packages are looking for funding
  run `npm fund` for details

found 4276 vulnerabilities (12 low, 1003 moderate, 3261 high)
  run `npm audit fix` to fix them, or `npm audit` for details
+ npm run typechain

> gravity-contracts@1.0.0 typechain /peggy/solidity
> npx hardhat typechain

Downloading compiler 0.6.6
Compiling 26 files with 0.6.6
contracts/ReentrantERC20.sol:15:23: Warning: Unused function parameter. Remove or comment out the variable name to silence this warning.
    function transfer(address recipient, uint256 amount) public returns (bool) {
                      ^---------------^

contracts/ReentrantERC20.sol:15:42: Warning: Unused function parameter. Remove or comment out the variable name to silence this warning.
    function transfer(address recipient, uint256 amount) public returns (bool) {
                                         ^------------^

Compilation finished successfully
Creating Typechain artifacts in directory typechain for target ethers-v5
Successfully generated Typechain artifacts!


   ╭────────────────────────────────────────────────────────────────╮
   │                                                                │
   │     New major version of npm available! 6.14.13 -> 7.23.0      │
   │   Changelog: https://github.com/npm/cli/releases/tag/v7.23.0   │
   │               Run npm install -g npm to update!                │
   │                                                                │
   ╰────────────────────────────────────────────────────────────────╯
```

## 2-2. Setup Validators


### 2-2-1. `peggy init`

<details>

<summary>peggy help init</summary>

```sh
peggy help init
Initialize validators's and node's configuration files.

Usage:
  peggy init [moniker] [flags]

Flags:
      --chain-id string   genesis file chain-id, if left blank will be randomly created
  -h, --help              help for init
  -o, --overwrite         overwrite the genesis.json file
      --recover           provide seed phrase to recover existing key instead of creating

Global Flags:
      --home string        directory for config and data (default "$HOME/.peggy")
      --log_level string   The logging level in the format of <module>:<level>,... (default "info")
      --trace              print out full stack trace on errors
```

</details>


```sh
+ bash /peggy/tests/container-scripts/setup-validators.sh 3
+ BIN=peggy
+ CHAIN_ID=peggy-test
+ NODES=3
+ ALLOCATION=10000000000stake,10000000000footoken
+ STARTING_VALIDATOR=1
+ STARTING_VALIDATOR_HOME='--home /validator1'
+ peggy init --home /validator1 --chain-id=peggy-test validator1
{"app_message":{"auth":{"accounts":[],"params":{"max_memo_characters":"256","sig_verify_cost_ed25519":"590","sig_verify_cost_secp256k1":"1000","tx_sig_limit":"7","tx_size_cost_per_byte":"10"}},"bank":{"balances":[],"denom_metadata":[],"params":{"default_send_enabled":true,"send_enabled":[]},"supply":[]},"capability":{"index":"1","owners":[]},"crisis":{"constant_fee":{"amount":"1000","denom":"stake"}},"distribution":{"delegator_starting_infos":[],"delegator_withdraw_infos":[],"fee_pool":{"community_pool":[]},"outstanding_rewards":[],"params":{"base_proposer_reward":"0.010000000000000000","bonus_proposer_reward":"0.040000000000000000","community_tax":"0.020000000000000000","withdraw_addr_enabled":true},"previous_proposer":"","validator_accumulated_commissions":[],"validator_current_rewards":[],"validator_historical_rewards":[],"validator_slash_events":[]},"evidence":{"evidence":[]},"genutil":{"gen_txs":[]},"gov":{"deposit_params":{"max_deposit_period":"172800s","min_deposit":[{"amount":"10000000","denom":"stake"}]},"deposits":[],"proposals":[],"starting_proposal_id":"1","tally_params":{"quorum":"0.334000000000000000","threshold":"0.500000000000000000","veto_threshold":"0.334000000000000000"},"votes":[],"voting_params":{"voting_period":"172800s"}},"ibc":{"channel_genesis":{"ack_sequences":[],"acknowledgements":[],"channels":[],"commitments":[],"next_channel_sequence":"0","receipts":[],"recv_sequences":[],"send_sequences":[]},"client_genesis":{"clients":[],"clients_consensus":[],"clients_metadata":[],"create_localhost":false,"next_client_sequence":"0","params":{"allowed_clients":["06-solomachine","07-tendermint"]}},"connection_genesis":{"client_connection_paths":[],"connections":[],"next_connection_sequence":"0"}},"mint":{"minter":{"annual_provisions":"0.000000000000000000","inflation":"0.130000000000000000"},"params":{"blocks_per_year":"6311520","goal_bonded":"0.670000000000000000","inflation_max":"0.200000000000000000","inflation_min":"0.070000000000000000","inflation_rate_change":"0.130000000000000000","mint_denom":"stake"}},"params":null,"peggy":{"attestations":[],"batch_confirms":[],"batches":[],"delegate_keys":[],"erc20_to_denoms":[],"last_observed_nonce":"0","logic_call_confirms":[],"logic_calls":[],"params":{"average_block_time":"5000","average_ethereum_block_time":"15000","bridge_chain_id":"0","bridge_ethereum_address":"","contract_source_hash":"","peggy_id":"defaultpeggyid","signed_batches_window":"10000","signed_claims_window":"10000","signed_valsets_window":"10000","slash_fraction_batch":"0.001000000000000000","slash_fraction_claim":"0.001000000000000000","slash_fraction_conflicting_claim":"0.001000000000000000","slash_fraction_valset":"0.001000000000000000","target_batch_timeout":"43200000","unbond_slashing_valsets_window":"10000"},"unbatched_transfers":[],"valset_confirms":[],"valsets":[]},"slashing":{"missed_blocks":[],"params":{"downtime_jail_duration":"600s","min_signed_per_window":"0.500000000000000000","signed_blocks_window":"100","slash_fraction_double_sign":"0.050000000000000000","slash_fraction_downtime":"0.010000000000000000"},"signing_infos":[]},"staking":{"delegations":[],"exported":false,"last_total_power":"0","last_validator_powers":[],"params":{"bond_denom":"stake","historical_entries":10000,"max_entries":7,"max_validators":100,"unbonding_time":"1814400s"},"redelegations":[],"unbonding_delegations":[],"validators":[]},"transfer":{"denom_traces":[],"params":{"receive_enabled":true,"send_enabled":true},"port_id":"transfer"},"upgrade":{},"vesting":{}},"chain_id":"peggy-test","gentxs_dir":"","moniker":"validator1","node_id":"05724dc60452794d5337c8fd5a1692480217f127"}
+ jq '.app_state.bank.denom_metadata += [{"base": "footoken", display: "mfootoken", "description": "A non-staking test token", "denom_units": [{"denom": "footoken", "exponent": 0}, {"denom": "mfootoken", "exponent": 6}]}, {"base": "stake", display: "mstake", "description": "A staking test token", "denom_units": [{"denom": "stake", "exponent": 0}, {"denom": "mstake", "exponent": 6}]}]' /validator1/config/genesis.json
+ mv /edited-genesis.json /genesis.json
+ cp /legacy-api-enable /validator1/config/app.toml
```

### 2-2-2. `peggy keys add` `keys show` `add-genesis-account`

<details>

<summary>peggy help keys add</summary>

```sh
peggy help keys add
Derive a new private key and encrypt to disk.
Optionally specify a BIP39 mnemonic, a BIP39 passphrase to further secure the mnemonic,
and a bip32 HD path to derive a specific account. The key will be stored under the given name
and encrypted with the given password. The only input that is required is the encryption password.

If run with -i, it will prompt the user for BIP44 path, BIP39 mnemonic, and passphrase.
The flag --recover allows one to recover a key from a seed passphrase.
If run with --dry-run, a key would be generated (or recovered) but not stored to the
local keystore.
Use the --pubkey flag to add arbitrary public keys to the keystore for constructing
multisig transactions.

You can add a multisig key by passing the list of key names you want the public
key to be composed of to the --multisig flag and the minimum number of signatures
required through --multisig-threshold. The keys are sorted by address, unless
the flag --nosort is set.

Usage:
  peggy keys add <name> [flags]

Flags:
      --account uint32           Account number for HD derivation
      --algo string              Key signing algorithm to generate keys for (default "secp256k1")
      --coin-type uint32         coin type number for HD derivation (default 118)
      --dry-run                  Perform action, but don't add key to local keystore
      --hd-path string           Manual HD Path derivation (overrides BIP44 config)
  -h, --help                     help for add
      --index uint32             Address index number for HD derivation
  -i, --interactive              Interactively prompt user for BIP39 passphrase and mnemonic
      --ledger                   Store a local reference to a private key on a Ledger device
      --multisig strings         Construct and store a multisig public key (implies --pubkey)
      --multisig-threshold int   K out of N required signatures. For use in conjunction with --multisig (default 1)
      --no-backup                Don't print out seed phrase (if others are watching the terminal)
      --nosort                   Keys passed to --multisig are taken in the order they're supplied
      --pubkey string            Parse a public key in bech32 format and save it to disk
      --recover                  Provide seed phrase to recover existing key instead of creating

Global Flags:
      --home string              The application home directory (default "$HOME/.peggy")
      --keyring-backend string   Select keyring's backend (os|file|test) (default "os")
      --keyring-dir string       The client Keyring directory; if omitted, the default 'home' directory will be used
      --log_level string         The logging level in the format of <module>:<level>,... (default "info")
      --output string            Output format (text|json) (default "text")
      --trace                    print out full stack trace on errors
```

</details>

<details>

<summary>peggy help keys show</summary>

```sh
peggy help keys show
Display keys details. If multiple names or addresses are provided,
then an ephemeral multisig key will be created under the name "multi"
consisting of all the keys provided by name and multisig threshold.

Usage:
  peggy keys show [name_or_address [name_or_address...]] [flags]

Flags:
  -a, --address                  Output the address only (overrides --output)
      --bech string              The Bech32 prefix encoding for a key (acc|val|cons) (default "acc")
  -d, --device                   Output the address in a ledger device
  -h, --help                     help for show
      --multisig-threshold int   K out of N required signatures (default 1)
  -p, --pubkey                   Output the public key only (overrides --output)

Global Flags:
      --home string              The application home directory (default "$HOME/.peggy")
      --keyring-backend string   Select keyring's backend (os|file|test) (default "os")
      --keyring-dir string       The client Keyring directory; if omitted, the default 'home' directory will be used
      --log_level string         The logging level in the format of <module>:<level>,... (default "info")
      --output string            Output format (text|json) (default "text")
      --trace                    print out full stack trace on errors
```

</details>

<details>

<summary>peggy help add-genesis-account</summary>

```sh
peggy help add-genesis-account
Add a genesis account to genesis.json. The provided account must specify
the account address or key name and a list of initial coins. If a key name is given,
the address will be looked up in the local Keybase. The list of initial tokens must
contain valid denominations. Accounts may optionally be supplied with vesting parameters.

Usage:
  peggy add-genesis-account [address_or_key_name] [coin][,[coin]] [flags]

Flags:
      --height int               Use a specific height to query state at (this can error if the node is pruning state)
  -h, --help                     help for add-genesis-account
      --keyring-backend string   Select keyring's backend (os|file|kwallet|pass|test) (default "os")
      --node string              <host>:<port> to Tendermint RPC interface for this chain (default "tcp://localhost:26657")
  -o, --output string            Output format (text|json) (default "text")
      --vesting-amount string    amount of coins for vesting accounts
      --vesting-end-time int     schedule end time (unix epoch) for vesting accounts
      --vesting-start-time int   schedule start time (unix epoch) for vesting accounts

Global Flags:
      --home string        directory for config and data (default "$HOME/.peggy")
      --log_level string   The logging level in the format of <module>:<level>,... (default "info")
      --trace              print out full stack trace on errors
```


</details>

#### validator1
```sh
++ seq 1 3
+ for i in $(seq 1 $NODES)
+ GAIA_HOME='--home /validator1'
+ GENTX_HOME='--home-client /validator1'
+ ARGS='--home /validator1 --keyring-backend test'
+ peggy keys add --home /validator1 --keyring-backend test validator1
- name: validator1
  type: local
  address: cosmos1a42emzmx2e8c2668u2taq8d3cwdvr5nc086y6u
  pubkey: cosmospub1addwnpepqt5ec92nvt2vz0n9pndwftq2slsecm5t4z2fxs8fh9q9rh78at26skayq8x
  mnemonic: ""
  threshold: 0
  pubkeys: []

++ peggy keys show validator1 -a --home /validator1 --keyring-backend test
+ KEY=cosmos1a42emzmx2e8c2668u2taq8d3cwdvr5nc086y6u
+ mkdir -p /validator1/config/
+ mv /genesis.json /validator1/config/genesis.json
+ peggy add-genesis-account --home /validator1 --keyring-backend test cosmos1a42emzmx2e8c2668u2taq8d3cwdvr5nc086y6u 10000000000stake,10000000000footoken
+ mv /validator1/config/genesis.json /genesis.json
```

#### validator2
```sh
+ for i in $(seq 1 $NODES)
+ GAIA_HOME='--home /validator2'
+ GENTX_HOME='--home-client /validator2'
+ ARGS='--home /validator2 --keyring-backend test'
+ peggy keys add --home /validator2 --keyring-backend test validator2
- name: validator2
  type: local
  address: cosmos1g440atgq8ln6fdaghpt6frwxtve8kaguhxg27l
  pubkey: cosmospub1addwnpepq28ky6258et5t7waznghfgr7h5cupgz8j6pxc2uty3zpzcwxulg66ajj0rs
  mnemonic: ""
  threshold: 0
  pubkeys: []

++ peggy keys show validator2 -a --home /validator2 --keyring-backend test
+ KEY=cosmos1g440atgq8ln6fdaghpt6frwxtve8kaguhxg27l
+ mkdir -p /validator2/config/
+ mv /genesis.json /validator2/config/genesis.json
+ peggy add-genesis-account --home /validator2 --keyring-backend test cosmos1g440atgq8ln6fdaghpt6frwxtve8kaguhxg27l 10000000000stake,10000000000footoken
+ mv /validator2/config/genesis.json /genesis.json
```

#### validator3

```sh
+ for i in $(seq 1 $NODES)
+ GAIA_HOME='--home /validator3'
+ GENTX_HOME='--home-client /validator3'
+ ARGS='--home /validator3 --keyring-backend test'
+ peggy keys add --home /validator3 --keyring-backend test validator3
- name: validator3
  type: local
  address: cosmos19a6z7v4hc62t267e4de74ayty05v30rv9z6xv2
  pubkey: cosmospub1addwnpepqgemt6s06cgpx7eys5389wx78cpmhk8h2z4ksfffhzlmj94ema4fzx27203
  mnemonic: ""
  threshold: 0
  pubkeys: []

++ peggy keys show validator3 -a --home /validator3 --keyring-backend test
+ KEY=cosmos19a6z7v4hc62t267e4de74ayty05v30rv9z6xv2
+ mkdir -p /validator3/config/
+ mv /genesis.json /validator3/config/genesis.json
+ peggy add-genesis-account --home /validator3 --keyring-backend test cosmos19a6z7v4hc62t267e4de74ayty05v30rv9z6xv2 10000000000stake,10000000000footoken
+ mv /validator3/config/genesis.json /genesis.json
```

### 2-2-3. `peggy gentx`
<details>

<summary>peggy help gentx</summary>

```sh
peggy help gentx
Generate a genesis transaction that creates a validator with a self-delegation,
that is signed by the key in the Keyring referenced by a given name. A node ID and Bech32 consensus
pubkey may optionally be provided. If they are omitted, they will be retrieved from the priv_validator.json
file. The following default parameters are included:
    
        delegation amount:           100000000stake
        commission rate:             0.1
        commission max rate:         0.2
        commission max change rate:  0.01
        minimum self delegation:     1


Example:
$ peggy gentx my-key-name 1000000stake --home=/path/to/home/dir --keyring-backend=os --chain-id=test-chain-1 \
    --moniker="myvalidator" \
    --commission-max-change-rate=0.01 \
    --commission-max-rate=1.0 \
    --commission-rate=0.07 \
    --details="..." \
    --security-contact="..." \
    --website="..."

Usage:
  peggy gentx [key_name] [amount] [flags]

Flags:
  -a, --account-number uint                 The account number of the signing account (offline mode only)
      --amount string                       Amount of coins to bond
  -b, --broadcast-mode string               Transaction broadcasting mode (sync|async|block) (default "sync")
      --chain-id string                     The network chain ID
      --commission-max-change-rate string   The maximum commission change rate percentage (per day)
      --commission-max-rate string          The maximum commission rate percentage
      --commission-rate string              The initial commission rate percentage
      --details string                      The validator's (optional) details
      --dry-run                             ignore the --gas flag and perform a simulation of a transaction, but don't broadcast it
      --fees string                         Fees to pay along with transaction; eg: 10uatom
      --from string                         Name or address of private key with which to sign
      --gas string                          gas limit to set per-transaction; set to "auto" to calculate sufficient gas automatically (default 200000)
      --gas-adjustment float                adjustment factor to be multiplied against the estimate returned by the tx simulation; if the gas limit is set manually this flag is ignored  (default 1)
      --gas-prices string                   Gas prices in decimal format to determine the transaction fee (e.g. 0.1uatom)
      --generate-only                       Build an unsigned transaction and write it to STDOUT (when enabled, the local Keybase is not accessible)
  -h, --help                                help for gentx
      --identity string                     The (optional) identity signature (ex. UPort or Keybase)
      --ip string                           The node's public IP (default "192.168.3.17")
      --keyring-backend string              Select keyring's backend (os|file|kwallet|pass|test) (default "os")
      --keyring-dir string                  The client Keyring directory; if omitted, the default 'home' directory will be used
      --ledger                              Use a connected Ledger device
      --memo string                         Memo to send along with transaction
      --min-self-delegation string          The minimum self delegation required on the validator
      --moniker string                      The validator's (optional) moniker
      --node string                         <host>:<port> to tendermint rpc interface for this chain (default "tcp://localhost:26657")
      --node-id string                      The node's NodeID
      --offline                             Offline mode (does not allow any online functionality
      --output-document string              Write the genesis transaction JSON document to the given file instead of the default location
      --pubkey string                       The Bech32 encoded PubKey of the validator
      --security-contact string             The validator's (optional) security contact email
  -s, --sequence uint                       The sequence number of the signing account (offline mode only)
      --sign-mode string                    Choose sign mode (direct|amino-json), this is an advanced feature
      --timeout-height uint                 Set a block timeout height to prevent the tx from being committed past a certain height
      --website string                      The validator's (optional) website
  -y, --yes                                 Skip tx broadcasting prompt confirmation

Global Flags:
      --home string        directory for config and data (default "$HOME/.peggy")
      --log_level string   The logging level in the format of <module>:<level>,... (default "info")
      --trace              print out full stack trace on errors
```

</details>

```sh
++ seq 1 3
+ for i in $(seq 1 $NODES)
+ cp /genesis.json /validator1/config/genesis.json
+ GAIA_HOME='--home /validator1'
+ ARGS='--home /validator1 --keyring-backend test'
+ peggy gentx --home /validator1 --keyring-backend test --home /validator1 --moniker validator1 --chain-id=peggy-test --ip 7.7.7.1 validator1 500000000stake
Genesis transaction written to "/validator1/config/gentx/gentx-05724dc60452794d5337c8fd5a1692480217f127.json"
+ '[' 1 -gt 1 ']'
+ for i in $(seq 1 $NODES)
+ cp /genesis.json /validator2/config/genesis.json
+ GAIA_HOME='--home /validator2'
+ ARGS='--home /validator2 --keyring-backend test'
+ peggy gentx --home /validator2 --keyring-backend test --home /validator2 --moniker validator2 --chain-id=peggy-test --ip 7.7.7.2 validator2 500000000stake
Genesis transaction written to "/validator2/config/gentx/gentx-47f6c6c8798fb47e3368364bc348b0ae04a89e8a.json"
+ '[' 2 -gt 1 ']'
+ cp /validator2/config/gentx/gentx-47f6c6c8798fb47e3368364bc348b0ae04a89e8a.json /validator1/config/gentx/
+ for i in $(seq 1 $NODES)
+ cp /genesis.json /validator3/config/genesis.json
+ GAIA_HOME='--home /validator3'
+ ARGS='--home /validator3 --keyring-backend test'
+ peggy gentx --home /validator3 --keyring-backend test --home /validator3 --moniker validator3 --chain-id=peggy-test --ip 7.7.7.3 validator3 500000000stake
Genesis transaction written to "/validator3/config/gentx/gentx-634cd4a67b879be0a83c3e0375cd5a3d539d9d02.json"
+ '[' 3 -gt 1 ']'
+ cp /validator3/config/gentx/gentx-634cd4a67b879be0a83c3e0375cd5a3d539d9d02.json /validator1/config/gentx/
```

### 2-2-4. `peggy collect-gentxs`

<details>

<summary>peggy help collect-gentxs</summary>

```sh
peggy help collect-gentxs
Collect genesis txs and output a genesis.json file

Usage:
  peggy collect-gentxs [flags]

Flags:
      --gentx-dir string   override default "gentx" directory from which collect and execute genesis transactions; default [--home]/config/gentx/
  -h, --help               help for collect-gentxs

Global Flags:
      --home string        directory for config and data (default "$HOME/.peggy")
      --log_level string   The logging level in the format of <module>:<level>,... (default "info")
      --trace              print out full stack trace on errors
```

</details>


```sh
+ peggy collect-gentxs --home /validator1 test
{"app_message":{"auth":{"accounts":[{"@type":"/cosmos.auth.v1beta1.BaseAccount","account_number":"0","address":"cosmos1a42emzmx2e8c2668u2taq8d3cwdvr5nc086y6u","pub_key":null,"sequence":"0"},{"@type":"/cosmos.auth.v1beta1.BaseAccount","account_number":"0","address":"cosmos1g440atgq8ln6fdaghpt6frwxtve8kaguhxg27l","pub_key":null,"sequence":"0"},{"@type":"/cosmos.auth.v1beta1.BaseAccount","account_number":"0","address":"cosmos19a6z7v4hc62t267e4de74ayty05v30rv9z6xv2","pub_key":null,"sequence":"0"}],"params":{"max_memo_characters":"256","sig_verify_cost_ed25519":"590","sig_verify_cost_secp256k1":"1000","tx_sig_limit":"7","tx_size_cost_per_byte":"10"}},"bank":{"balances":[{"address":"cosmos19a6z7v4hc62t267e4de74ayty05v30rv9z6xv2","coins":[{"amount":"10000000000","denom":"footoken"},{"amount":"10000000000","denom":"stake"}]},{"address":"cosmos1g440atgq8ln6fdaghpt6frwxtve8kaguhxg27l","coins":[{"amount":"10000000000","denom":"footoken"},{"amount":"10000000000","denom":"stake"}]},{"address":"cosmos1a42emzmx2e8c2668u2taq8d3cwdvr5nc086y6u","coins":[{"amount":"10000000000","denom":"footoken"},{"amount":"10000000000","denom":"stake"}]}],"denom_metadata":[{"base":"footoken","denom_units":[{"aliases":[],"denom":"footoken","exponent":0},{"aliases":[],"denom":"mfootoken","exponent":6}],"description":"A non-staking test token","display":"mfootoken"},{"base":"stake","denom_units":[{"aliases":[],"denom":"stake","exponent":0},{"aliases":[],"denom":"mstake","exponent":6}],"description":"A staking test token","display":"mstake"}],"params":{"default_send_enabled":true,"send_enabled":[]},"supply":[]},"capability":{"index":"1","owners":[]},"crisis":{"constant_fee":{"amount":"1000","denom":"stake"}},"distribution":{"delegator_starting_infos":[],"delegator_withdraw_infos":[],"fee_pool":{"community_pool":[]},"outstanding_rewards":[],"params":{"base_proposer_reward":"0.010000000000000000","bonus_proposer_reward":"0.040000000000000000","community_tax":"0.020000000000000000","withdraw_addr_enabled":true},"previous_proposer":"","validator_accumulated_commissions":[],"validator_current_rewards":[],"validator_historical_rewards":[],"validator_slash_events":[]},"evidence":{"evidence":[]},"genutil":{"gen_txs":[{"auth_info":{"fee":{"amount":[],"gas_limit":"200000","granter":"","payer":""},"signer_infos":[{"mode_info":{"single":{"mode":"SIGN_MODE_DIRECT"}},"public_key":{"@type":"/cosmos.crypto.secp256k1.PubKey","key":"AumcFVNi1ME+ZQza5KwKh+GcbouolJNA6blAUd/H6tWo"},"sequence":"0"}]},"body":{"extension_options":[],"memo":"05724dc60452794d5337c8fd5a1692480217f127@7.7.7.1:26656","messages":[{"@type":"/cosmos.staking.v1beta1.MsgCreateValidator","commission":{"max_change_rate":"0.010000000000000000","max_rate":"0.200000000000000000","rate":"0.100000000000000000"},"delegator_address":"cosmos1a42emzmx2e8c2668u2taq8d3cwdvr5nc086y6u","description":{"details":"","identity":"","moniker":"validator1","security_contact":"","website":""},"min_self_delegation":"1","pubkey":{"@type":"/cosmos.crypto.ed25519.PubKey","key":"NAB9He/QmnebpD0/dN4zlzFT1SmqwI3/ptW8pYeBo4Q="},"validator_address":"cosmosvaloper1a42emzmx2e8c2668u2taq8d3cwdvr5nc2nw3k0","value":{"amount":"500000000","denom":"stake"}}],"non_critical_extension_options":[],"timeout_height":"0"},"signatures":["kPw/XEGpi4GC7Ag3t1VZ/O1th/GoPQ4sSfYeySHKDDN78rilBcTJrcDL8ly1WDyCn04ZOVSjSbFC605e9eyF+w=="]},{"auth_info":{"fee":{"amount":[],"gas_limit":"200000","granter":"","payer":""},"signer_infos":[{"mode_info":{"single":{"mode":"SIGN_MODE_DIRECT"}},"public_key":{"@type":"/cosmos.crypto.secp256k1.PubKey","key":"Ao9iaVQ+V0X53RTRdKB+vTHAoEeWgmwriyREEWHG59Gt"},"sequence":"0"}]},"body":{"extension_options":[],"memo":"47f6c6c8798fb47e3368364bc348b0ae04a89e8a@7.7.7.2:26656","messages":[{"@type":"/cosmos.staking.v1beta1.MsgCreateValidator","commission":{"max_change_rate":"0.010000000000000000","max_rate":"0.200000000000000000","rate":"0.100000000000000000"},"delegator_address":"cosmos1g440atgq8ln6fdaghpt6frwxtve8kaguhxg27l","description":{"details":"","identity":"","moniker":"validator2","security_contact":"","website":""},"min_self_delegation":"1","pubkey":{"@type":"/cosmos.crypto.ed25519.PubKey","key":"s1SppDCZiL/SUKC4plidT6ULtOoLufg+vI6slIqdz20="},"validator_address":"cosmosvaloper1g440atgq8ln6fdaghpt6frwxtve8kagujjuljv","value":{"amount":"500000000","denom":"stake"}}],"non_critical_extension_options":[],"timeout_height":"0"},"signatures":["lZknuelwcrMTbo2DZGOdksFB49m0oZ/GiWhKP1j2QiA6aPhNxCXSoytx7Pqsnzh6h+HybniuTd/KN9isIlQ21Q=="]},{"auth_info":{"fee":{"amount":[],"gas_limit":"200000","granter":"","payer":""},"signer_infos":[{"mode_info":{"single":{"mode":"SIGN_MODE_DIRECT"}},"public_key":{"@type":"/cosmos.crypto.secp256k1.PubKey","key":"AjO16g/WEBN7JIUicrjePgO72PdQq2glKbi/uRa532qR"},"sequence":"0"}]},"body":{"extension_options":[],"memo":"634cd4a67b879be0a83c3e0375cd5a3d539d9d02@7.7.7.3:26656","messages":[{"@type":"/cosmos.staking.v1beta1.MsgCreateValidator","commission":{"max_change_rate":"0.010000000000000000","max_rate":"0.200000000000000000","rate":"0.100000000000000000"},"delegator_address":"cosmos19a6z7v4hc62t267e4de74ayty05v30rv9z6xv2","description":{"details":"","identity":"","moniker":"validator3","security_contact":"","website":""},"min_self_delegation":"1","pubkey":{"@type":"/cosmos.crypto.ed25519.PubKey","key":"4H/9PySKWXSFe/FgZ+X4JZ5I67skWyzcXyAYhJ0AvrM="},"validator_address":"cosmosvaloper19a6z7v4hc62t267e4de74ayty05v30rvqkwnqe","value":{"amount":"500000000","denom":"stake"}}],"non_critical_extension_options":[],"timeout_height":"0"},"signatures":["jnKKwM7xD22q7Ri5ydsGRoQ05Rx/oB9/UMm3bXGdSyBGW7XnesChrXaPRe3vCQ6fbcCHBJAesUajNzGI4g61LQ=="]}]},"gov":{"deposit_params":{"max_deposit_period":"172800s","min_deposit":[{"amount":"10000000","denom":"stake"}]},"deposits":[],"proposals":[],"starting_proposal_id":"1","tally_params":{"quorum":"0.334000000000000000","threshold":"0.500000000000000000","veto_threshold":"0.334000000000000000"},"votes":[],"voting_params":{"voting_period":"172800s"}},"ibc":{"channel_genesis":{"ack_sequences":[],"acknowledgements":[],"channels":[],"commitments":[],"next_channel_sequence":"0","receipts":[],"recv_sequences":[],"send_sequences":[]},"client_genesis":{"clients":[],"clients_consensus":[],"clients_metadata":[],"create_localhost":false,"next_client_sequence":"0","params":{"allowed_clients":["06-solomachine","07-tendermint"]}},"connection_genesis":{"client_connection_paths":[],"connections":[],"next_connection_sequence":"0"}},"mint":{"minter":{"annual_provisions":"0.000000000000000000","inflation":"0.130000000000000000"},"params":{"blocks_per_year":"6311520","goal_bonded":"0.670000000000000000","inflation_max":"0.200000000000000000","inflation_min":"0.070000000000000000","inflation_rate_change":"0.130000000000000000","mint_denom":"stake"}},"params":null,"peggy":{"attestations":[],"batch_confirms":[],"batches":[],"delegate_keys":[],"erc20_to_denoms":[],"last_observed_nonce":"0","logic_call_confirms":[],"logic_calls":[],"params":{"average_block_time":"5000","average_ethereum_block_time":"15000","bridge_chain_id":"0","bridge_ethereum_address":"","contract_source_hash":"","peggy_id":"defaultpeggyid","signed_batches_window":"10000","signed_claims_window":"10000","signed_valsets_window":"10000","slash_fraction_batch":"0.001000000000000000","slash_fraction_claim":"0.001000000000000000","slash_fraction_conflicting_claim":"0.001000000000000000","slash_fraction_valset":"0.001000000000000000","target_batch_timeout":"43200000","unbond_slashing_valsets_window":"10000"},"unbatched_transfers":[],"valset_confirms":[],"valsets":[]},"slashing":{"missed_blocks":[],"params":{"downtime_jail_duration":"600s","min_signed_per_window":"0.500000000000000000","signed_blocks_window":"100","slash_fraction_double_sign":"0.050000000000000000","slash_fraction_downtime":"0.010000000000000000"},"signing_infos":[]},"staking":{"delegations":[],"exported":false,"last_total_power":"0","last_validator_powers":[],"params":{"bond_denom":"stake","historical_entries":10000,"max_entries":7,"max_validators":100,"unbonding_time":"1814400s"},"redelegations":[],"unbonding_delegations":[],"validators":[]},"transfer":{"denom_traces":[],"params":{"receive_enabled":true,"send_enabled":true},"port_id":"transfer"},"upgrade":{},"vesting":{}},"chain_id":"peggy-test","gentxs_dir":"/validator1/config/gentx","moniker":"validator1","node_id":"05724dc60452794d5337c8fd5a1692480217f127"}
++ ls /validator1/config/gentx
++ wc -l
+ GENTXS=3
+ cp /validator1/config/genesis.json /genesis.json
+ echo 'Collected 3 gentx'
Collected 3 gentx
++ seq 1 3
+ for i in $(seq 1 $NODES)
+ cp /genesis.json /validator1/config/genesis.json
+ for i in $(seq 1 $NODES)
+ cp /genesis.json /validator2/config/genesis.json
+ for i in $(seq 1 $NODES)
+ cp /genesis.json /validator3/config/genesis.json
```


## 2-3.　Test Runner 起動

### ログの見方
- `INFO [09-10|03:04:10.481] ...` Gethのログ
- `[2021-09-10T03:04:23Z INFO  ...] ...` Rustのログ(test-runnerなど)
- `3:04AM ERR ...` Peggyのログ


```sh
+ pushd /peggy/orchestrator/test_runner
+ bash /peggy/tests/container-scripts/run-testnet.sh 3
/peggy/orchestrator/test_runner /peggy/solidity /
+ DEPLOY_CONTRACTS=1
+ RUST_BACKTRACE=full
+ BIN=peggy
+ NODES=3
+ set +u
+ TEST_TYPE=
+ ALCHEMY_ID=
+ set -u
+ RUST_LOG=INFO
+ PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/go/bin:/root/.cargo/bin
+ cargo run --release --bin test-runner
```

### 2-3-1. `peggy start`

<details>

<summary>peggy help start</summary>

```sh
peggy help start
Run the full node application with Tendermint in or out of process. By
default, the application will run with Tendermint in process.

Pruning options can be provided via the '--pruning' flag or alternatively with '--pruning-keep-recent',
'pruning-keep-every', and 'pruning-interval' together.

For '--pruning' the options are as follows:

default: the last 100 states are kept in addition to every 500th state; pruning at 10 block intervals
nothing: all historic states will be saved, nothing will be deleted (i.e. archiving node)
everything: all saved states will be deleted, storing only the current state; pruning at 10 block intervals
custom: allow pruning options to be manually specified through 'pruning-keep-recent', 'pruning-keep-every', and 'pruning-interval'

Node halting configurations exist in the form of two flags: '--halt-height' and '--halt-time'. During
the ABCI Commit phase, the node will check if the current block height is greater than or equal to
the halt-height or if the current block time is greater than or equal to the halt-time. If so, the
node will attempt to gracefully shutdown and the block will not be committed. In addition, the node
will not be able to commit subsequent blocks.

For profiling and benchmarking purposes, CPU profiling can be enabled via the '--cpu-profile' flag
which accepts a path for the resulting pprof file.

Usage:
  peggy start [flags]

Flags:
      --abci string                                     specify abci transport (socket | grpc) (default "socket")
      --address string                                  Listen address (default "tcp://0.0.0.0:26658")
      --consensus.create_empty_blocks                   set this to false to only produce blocks when there are txs or when the AppHash changes (default true)
      --consensus.create_empty_blocks_interval string   the possible interval between empty blocks (default "0s")
      --consensus.double_sign_check_height int          how many blocks to look back to check existence of the node's consensus votes before joining consensus
      --cpu-profile string                              Enable CPU profiling and write to the provided file
      --db_backend string                               database backend: goleveldb | cleveldb | boltdb | rocksdb | badgerdb (default "goleveldb")
      --db_dir string                                   database directory (default "data")
      --fast_sync                                       fast blockchain syncing (default true)
      --genesis_hash bytesHex                           optional SHA-256 hash of the genesis file
      --grpc.address string                             the gRPC server address to listen on (default "0.0.0.0:9090")
      --grpc.enable                                     Define if the gRPC server should be enabled (default true)
      --halt-height uint                                Block height at which to gracefully halt the chain and shutdown the node
      --halt-time uint                                  Minimum block time (in Unix seconds) at which to gracefully halt the chain and shutdown the node
  -h, --help                                            help for start
      --inter-block-cache                               Enable inter-block caching (default true)
      --inv-check-period uint                           Assert registered invariants every N blocks
      --min-retain-blocks uint                          Minimum block height offset during ABCI commit to prune Tendermint blocks
      --minimum-gas-prices string                       Minimum gas prices to accept for transactions; Any fee in a tx must meet this minimum (e.g. 0.01photino;0.0001stake)
      --moniker string                                  node name (default "Apple365")
      --p2p.laddr string                                node listen address. (0.0.0.0:0 means any interface, any port) (default "tcp://0.0.0.0:26656")
      --p2p.persistent_peers string                     comma-delimited ID@host:port persistent peers
      --p2p.pex                                         enable/disable Peer-Exchange (default true)
      --p2p.private_peer_ids string                     comma-delimited private peer IDs
      --p2p.seed_mode                                   enable/disable seed mode
      --p2p.seeds string                                comma-delimited ID@host:port seed nodes
      --p2p.unconditional_peer_ids string               comma-delimited IDs of unconditional peers
      --p2p.upnp                                        enable/disable UPNP port forwarding
      --priv_validator_laddr string                     socket address to listen on for connections from external priv_validator process
      --proxy_app string                                proxy app address, or one of: 'kvstore', 'persistent_kvstore', 'counter', 'counter_serial' or 'noop' for local testing. (default "tcp://127.0.0.1:26658")
      --pruning string                                  Pruning strategy (default|nothing|everything|custom) (default "default")
      --pruning-interval uint                           Height interval at which pruned heights are removed from disk (ignored if pruning is not 'custom')
      --pruning-keep-every uint                         Offset heights to keep on disk after 'keep-every' (ignored if pruning is not 'custom')
      --pruning-keep-recent uint                        Number of recent heights to keep on disk (ignored if pruning is not 'custom')
      --rpc.grpc_laddr string                           GRPC listen address (BroadcastTx only). Port required
      --rpc.laddr string                                RPC listen address. Port required (default "tcp://127.0.0.1:26657")
      --rpc.pprof_laddr string                          pprof listen address (https://golang.org/pkg/net/http/pprof)
      --rpc.unsafe                                      enabled unsafe rpc methods
      --state-sync.snapshot-interval uint               State sync snapshot interval
      --state-sync.snapshot-keep-recent uint32          State sync snapshot to keep (default 2)
      --trace-store string                              Enable KVStore tracing to an output file
      --transport string                                Transport protocol: socket, grpc (default "socket")
      --unsafe-skip-upgrades ints                       Skip a set of upgrade heights to continue the old binary
      --with-tendermint                                 Run abci app embedded in-process with tendermint (default true)
      --x-crisis-skip-assert-invariants                 Skip x/crisis invariants check on startup

Global Flags:
      --home string        directory for config and data (default "$HOME/.peggy")
      --log_level string   The logging level in the format of <module>:<level>,... (default "info")
      --trace              print out full stack trace on errors
```

</details>

```sh
++ seq 1 3
+ for i in $(seq 1 $NODES)
+ ip addr add 7.7.7.1/32 dev eth0

+ GAIA_HOME='--home /validator1'
+ [[ 1 -eq 1 ]]
+ RPC_ADDRESS='--rpc.laddr tcp://0.0.0.0:26657'
+ GRPC_ADDRESS='--grpc.address 0.0.0.0:9090'
+ LISTEN_ADDRESS='--address tcp://7.7.7.1:26655'
+ P2P_ADDRESS='--p2p.laddr tcp://7.7.7.1:26656'
+ LOG_LEVEL='--log_level error'
+ ARGS='--home /validator1 --address tcp://7.7.7.1:26655 --rpc.laddr tcp://0.0.0.0:26657 --grpc.address 0.0.0.0:9090 --log_level error --p2p.laddr tcp://7.7.7.1:26656'
+ for i in $(seq 1 $NODES)
+ ip addr add 7.7.7.2/32 dev eth0
+ peggy --home /validator1 --address tcp://7.7.7.1:26655 --rpc.laddr tcp://0.0.0.0:26657 --grpc.address 0.0.0.0:9090 --log_level error --p2p.laddr tcp://7.7.7.1:26656 start

+ GAIA_HOME='--home /validator2'
+ [[ 2 -eq 1 ]]
+ RPC_ADDRESS='--rpc.laddr tcp://7.7.7.2:26658'
+ GRPC_ADDRESS='--grpc.address 7.7.7.2:9091'
+ LISTEN_ADDRESS='--address tcp://7.7.7.2:26655'
+ P2P_ADDRESS='--p2p.laddr tcp://7.7.7.2:26656'
+ LOG_LEVEL='--log_level error'
+ ARGS='--home /validator2 --address tcp://7.7.7.2:26655 --rpc.laddr tcp://7.7.7.2:26658 --grpc.address 7.7.7.2:9091 --log_level error --p2p.laddr tcp://7.7.7.2:26656'
+ for i in $(seq 1 $NODES)
+ ip addr add 7.7.7.3/32 dev eth0
+ peggy --home /validator2 --address tcp://7.7.7.2:26655 --rpc.laddr tcp://7.7.7.2:26658 --grpc.address 7.7.7.2:9091 --log_level error --p2p.laddr tcp://7.7.7.2:26656 start

+ GAIA_HOME='--home /validator3'
+ [[ 3 -eq 1 ]]
+ RPC_ADDRESS='--rpc.laddr tcp://7.7.7.3:26658'
+ GRPC_ADDRESS='--grpc.address 7.7.7.3:9091'
+ LISTEN_ADDRESS='--address tcp://7.7.7.3:26655'
+ P2P_ADDRESS='--p2p.laddr tcp://7.7.7.3:26656'
+ LOG_LEVEL='--log_level error'
+ ARGS='--home /validator3 --address tcp://7.7.7.3:26655 --rpc.laddr tcp://7.7.7.3:26658 --grpc.address 7.7.7.3:9091 --log_level error --p2p.laddr tcp://7.7.7.3:26656'
+ sleep 10
+ peggy --home /validator3 --address tcp://7.7.7.3:26655 --rpc.laddr tcp://7.7.7.3:26658 --grpc.address 7.7.7.3:9091 --log_level error --p2p.laddr tcp://7.7.7.3:26656 start

3:04AM ERR pprof server error err="listen tcp 127.0.0.1:6060: bind: address already in use"
3:04AM ERR pprof server error err="listen tcp 127.0.0.1:6060: bind: address already in use"
warning: unused variable: `input`
   --> peggy_utils/src/types/ethereum_events.rs:442:21
    |
442 |     pub fn from_log(input: &Log) -> Result<LogicCallExecutedEvent, PeggyError> {
    |                     ^^^^^ help: if this is intentional, prefix it with an underscore: `_input`
    |
    = note: `#[warn(unused_variables)]` on by default

warning: 1 warning emitted

warning: unused variable: `grpc_client`
  --> test_runner/src/arbitrary_logic.rs:19:5
   |
19 |     grpc_client: PeggyQueryClient<Channel>,
   |     ^^^^^^^^^^^ help: if this is intentional, prefix it with an underscore: `_grpc_client`
   |
   = note: `#[warn(unused_variables)]` on by default

warning: 1 warning emitted

    Finished release [optimized] target(s) in 1.82s
     Running `/peggy/orchestrator/target/release/test-runner`
[2021-09-10T03:04:02Z INFO  test_runner] Staring Peggy test-runner
[2021-09-10T03:04:02Z INFO  test_runner] Waiting for Cosmos chain to come online
+ [[ '' == *\A\R\B\I\T\R\A\R\Y\_\L\O\G\I\C* ]]
+ sleep 10
```

## 2-4. Geth 起動

```sh
+ bash /peggy/tests/container-scripts/run-eth.sh
INFO [09-10|03:04:10.481] Maximum peer count                       ETH=50 LES=0 total=50
INFO [09-10|03:04:10.481] Smartcard socket not found, disabling    err="stat /run/pcscd/pcscd.comm: no such file or directory"
INFO [09-10|03:04:10.484] Set global gas cap                       cap=25000000
INFO [09-10|03:04:10.491] Allocated cache and file handles         database=/root/.ethereum/geth/chaindata cache=16.00MiB handles=16
INFO [09-10|03:04:10.527] Writing custom genesis block
INFO [09-10|03:04:10.528] Persisted trie from memory database      nodes=1 size=150.00B time="112.078µs" gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
INFO [09-10|03:04:10.530] Successfully wrote genesis state         database=chaindata                      hash="1d4e59…faac29"
INFO [09-10|03:04:10.531] Allocated cache and file handles         database=/root/.ethereum/geth/lightchaindata cache=16.00MiB handles=16
INFO [09-10|03:04:10.539] Writing custom genesis block
INFO [09-10|03:04:10.540] Persisted trie from memory database      nodes=1 size=150.00B time="85.29µs"   gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
INFO [09-10|03:04:10.541] Successfully wrote genesis state         database=lightchaindata                      hash="1d4e59…faac29"
```

## 2-5. Bootstrapping
```
[2021-09-10T03:04:23Z INFO  test_runner] test-runner in contract deploying mode, deploying contracts, then exiting
[2021-09-10T03:04:23Z INFO  test_runner::bootstrapping] Signing and submitting Delegate addresses 0x8Cc75e50CC0c9Dd190389e8aBEe80Dd60e38cE43 for validator cosmos1a42emzmx2e8c2668u2taq8d3cwdvr5nc086y6u
[2021-09-10T03:04:23Z INFO  test_runner::bootstrapping] Signing and submitting Delegate addresses 0xC233c8461f1ae3c7019bd3F90feD64c729d4a987 for validator cosmos1g440atgq8ln6fdaghpt6frwxtve8kaguhxg27l
[2021-09-10T03:04:23Z INFO  test_runner::bootstrapping] Signing and submitting Delegate addresses 0x6148DDC228Ed6Ea07fEaFE6414016f774D4fa849 for validator cosmos19a6z7v4hc62t267e4de74ayty05v30rv9z6xv2
3:05AM ERR dialing failed (attempts: 1): auth failure: secret conn failed: EOF addr={"id":"634cd4a67b879be0a83c3e0375cd5a3d539d9d02","ip":"7.7.7.3","port":26656} module=pex
3:05AM ERR dialing failed (attempts: 1): auth failure: secret conn failed: EOF addr={"id":"47f6c6c8798fb47e3368364bc348b0ae04a89e8a","ip":"7.7.7.2","port":26656} module=pex
3:05AM ERR dialing failed (attempts: 2): auth failure: secret conn failed: EOF addr={"id":"634cd4a67b879be0a83c3e0375cd5a3d539d9d02","ip":"7.7.7.3","port":26656} module=pex
3:05AM ERR dialing failed (attempts: 2): auth failure: secret conn failed: read tcp 7.7.7.2:37714->7.7.7.2:26656: read: connection reset by peer addr={"id":"47f6c6c8798fb47e3368364bc348b0ae04a89e8a","ip":"7.7.7.2","port":26656} module=pex
3:06AM ERR dialing failed (attempts: 3): auth failure: secret conn failed: EOF addr={"id":"634cd4a67b879be0a83c3e0375cd5a3d539d9d02","ip":"7.7.7.3","port":26656} module=pex
3:06AM ERR dialing failed (attempts: 3): auth failure: secret conn failed: EOF addr={"id":"47f6c6c8798fb47e3368364bc348b0ae04a89e8a","ip":"7.7.7.2","port":26656} module=pex
3:06AM ERR dialing failed (attempts: 4): auth failure: secret conn failed: EOF addr={"id":"634cd4a67b879be0a83c3e0375cd5a3d539d9d02","ip":"7.7.7.3","port":26656} module=pex
3:06AM ERR dialing failed (attempts: 4): auth failure: secret conn failed: read tcp 7.7.7.2:37834->7.7.7.2:26656: read: connection reset by peer addr={"id":"47f6c6c8798fb47e3368364bc348b0ae04a89e8a","ip":"7.7.7.2","port":26656} module=pex
3:07AM ERR dialing failed (attempts: 5): auth failure: secret conn failed: EOF addr={"id":"634cd4a67b879be0a83c3e0375cd5a3d539d9d02","ip":"7.7.7.3","port":26656} module=pex
3:07AM ERR dialing failed (attempts: 5): auth failure: secret conn failed: EOF addr={"id":"47f6c6c8798fb47e3368364bc348b0ae04a89e8a","ip":"7.7.7.2","port":26656} module=pex
3:08AM ERR dialing failed (attempts: 6): auth failure: secret conn failed: EOF addr={"id":"634cd4a67b879be0a83c3e0375cd5a3d539d9d02","ip":"7.7.7.3","port":26656} module=pex
3:08AM ERR dialing failed (attempts: 6): auth failure: secret conn failed: read tcp 7.7.7.2:38024->7.7.7.2:26656: read: connection reset by peer addr={"id":"47f6c6c8798fb47e3368364bc348b0ae04a89e8a","ip":"7.7.7.2","port":26656} module=pex
3:09AM ERR dialing failed (attempts: 7): auth failure: secret conn failed: EOF addr={"id":"634cd4a67b879be0a83c3e0375cd5a3d539d9d02","ip":"7.7.7.3","port":26656} module=pex
3:09AM ERR dialing failed (attempts: 7): auth failure: secret conn failed: EOF addr={"id":"47f6c6c8798fb47e3368364bc348b0ae04a89e8a","ip":"7.7.7.2","port":26656} module=pex
[2021-09-10T03:11:01Z INFO  test_runner::bootstrapping] stdout: Test mode, deploying ERC20 contracts
    ERC20 deployed at Address -  0x0412C7c846bb6b7DC462CF6B453f76D8440b2609
    ERC20 deployed at Address -  0x30dA8589BFa1E509A319489E014d384b87815D89
    ERC20 deployed at Address -  0x9676519d99E390A180Ab1445d5d857E3f6869065
    Uniswap Liquidity test deployed at Address -  0xD7600ae27C99988A6CD360234062b540F88ECA43
    Starting Peggy contract deploy
    About to get latest Peggy valset
    {
      "type": "peggy/Valset",
      "value": {
        "nonce": "74",
        "members": [
          {
            "power": "1431655765",
            "ethereum_address": "0x6148DDC228Ed6Ea07fEaFE6414016f774D4fa849"
          },
          {
            "power": "1431655765",
            "ethereum_address": "0x8Cc75e50CC0c9Dd190389e8aBEe80Dd60e38cE43"
          },
          {
            "power": "1431655765",
            "ethereum_address": "0xC233c8461f1ae3c7019bd3F90feD64c729d4a987"
          }
        ],
        "height": "74"
      }
    }
    Peggy deployed at Address -  0x7580bFE88Dd3d07947908FAE12d95872a260F2D8

[2021-09-10T03:11:02Z INFO  test_runner::bootstrapping] stderr:
```

## 2-6. Integration Tests
```
+ bash /peggy/tests/container-scripts/integration-tests.sh 3
Contracts already deployed, running tests
test-runner: no process found
/peggy/orchestrator/test_runner /peggy/orchestrator/test_runner
warning: unused variable: `input`
   --> peggy_utils/src/types/ethereum_events.rs:442:21
    |
442 |     pub fn from_log(input: &Log) -> Result<LogicCallExecutedEvent, PeggyError> {
    |                     ^^^^^ help: if this is intentional, prefix it with an underscore: `_input`
    |
    = note: `#[warn(unused_variables)]` on by default

warning: 1 warning emitted

warning: unused variable: `grpc_client`
  --> test_runner/src/arbitrary_logic.rs:19:5
   |
19 |     grpc_client: PeggyQueryClient<Channel>,
   |     ^^^^^^^^^^^ help: if this is intentional, prefix it with an underscore: `_grpc_client`
   |
   = note: `#[warn(unused_variables)]` on by default

warning: 1 warning emitted

    Finished release [optimized] target(s) in 2.11s
     Running `/peggy/orchestrator/target/release/test-runner`
[2021-09-10T03:11:05Z INFO  test_runner] Staring Peggy test-runner
[2021-09-10T03:11:05Z INFO  test_runner] Waiting for Cosmos chain to come online
[2021-09-10T03:11:22Z INFO  test_runner::utils] Sending orchestrators 100 eth to pay for fees miner has 23229340 ETH
[2021-09-10T03:11:27Z INFO  test_runner] Starting tests with Ok("")
[2021-09-10T03:11:27Z INFO  test_runner] Starting Happy path test
[2021-09-10T03:11:27Z INFO  test_runner::happy_path] Spawning Orchestrator
[2021-09-10T03:11:28Z INFO  orchestrator::oracle_resync] Oracle is resyncing, looking back into the history to find our last event nonce 1, on block 11
[2021-09-10T03:11:28Z INFO  test_runner::happy_path] Spawning Orchestrator
[2021-09-10T03:11:28Z INFO  orchestrator::main_loop] Sending 5 valset confirms starting with 5
[2021-09-10T03:11:28Z INFO  test_runner::happy_path] Spawning Orchestrator
[2021-09-10T03:11:28Z INFO  orchestrator::oracle_resync] Oracle is resyncing, looking back into the history to find our last event nonce 1, on block 11
[2021-09-10T03:11:28Z INFO  orchestrator::oracle_resync] Oracle is resyncing, looking back into the history to find our last event nonce 1, on block 11
[2021-09-10T03:11:28Z INFO  orchestrator::main_loop] Sending 5 valset confirms starting with 5
[2021-09-10T03:11:28Z INFO  orchestrator::main_loop] Sending 5 valset confirms starting with 5
[2021-09-10T03:11:28Z INFO  orchestrator::main_loop] Oracle resync complete, Oracle now operational
[2021-09-10T03:11:28Z INFO  test_runner::happy_path] Sending in valset request
[2021-09-10T03:11:28Z INFO  test_runner::happy_path] Delegating 125000000stake to cosmosvaloper1a42emzmx2e8c2668u2taq8d3cwdvr5nc2nw3k0 in order to generate a validator set update
[2021-09-10T03:11:30Z ERROR relayer::valset_relaying] We don't have a latest confirmed valset?
[2021-09-10T03:11:30Z INFO  orchestrator::main_loop] Oracle resync complete, Oracle now operational
[2021-09-10T03:11:30Z INFO  orchestrator::main_loop] Oracle resync complete, Oracle now operational
[2021-09-10T03:11:30Z ERROR relayer::valset_relaying] We don't have a latest confirmed valset?
[2021-09-10T03:11:30Z ERROR relayer::valset_relaying] We don't have a latest confirmed valset?
[2021-09-10T03:11:39Z INFO  orchestrator::main_loop] Sending 1 valset confirms starting with 82
[2021-09-10T03:11:39Z INFO  orchestrator::main_loop] Sending 1 valset confirms starting with 82
[2021-09-10T03:11:39Z INFO  orchestrator::main_loop] Sending 1 valset confirms starting with 82
[2021-09-10T03:11:44Z INFO  test_runner::happy_path] stdout: {"height":"82","txhash":"5B9FCDB3756745019396C10E61FD547D8C6D5ED84A211364274B35CB7D9B749C","codespace":"","code":0,"data":"0A0A0A0864656C6567617465","raw_log":"[{\"events\":[{\"type\":\"delegate\",\"attributes\":[{\"key\":\"validator\",\"value\":\"cosmosvaloper1a42emzmx2e8c2668u2taq8d3cwdvr5nc2nw3k0\"},{\"key\":\"amount\",\"value\":\"125000000\"}]},{\"type\":\"message\",\"attributes\":[{\"key\":\"action\",\"value\":\"delegate\"},{\"key\":\"sender\",\"value\":\"cosmos1jv65s3grqf6v6jl3dp4t6c9t9rk99cd88lyufl\"},{\"key\":\"module\",\"value\":\"staking\"},{\"key\":\"sender\",\"value\":\"cosmos1a42emzmx2e8c2668u2taq8d3cwdvr5nc086y6u\"}]},{\"type\":\"transfer\",\"attributes\":[{\"key\":\"recipient\",\"value\":\"cosmos1a42emzmx2e8c2668u2taq8d3cwdvr5nc086y6u\"},{\"key\":\"sender\",\"value\":\"cosmos1jv65s3grqf6v6jl3dp4t6c9t9rk99cd88lyufl\"},{\"key\":\"amount\",\"value\":\"1footoken,14865stake\"}]}]}]","logs":[{"msg_index":0,"log":"","events":[{"type":"delegate","attributes":[{"key":"validator","value":"cosmosvaloper1a42emzmx2e8c2668u2taq8d3cwdvr5nc2nw3k0"},{"key":"amount","value":"125000000"}]},{"type":"message","attributes":[{"key":"action","value":"delegate"},{"key":"sender","value":"cosmos1jv65s3grqf6v6jl3dp4t6c9t9rk99cd88lyufl"},{"key":"module","value":"staking"},{"key":"sender","value":"cosmos1a42emzmx2e8c2668u2taq8d3cwdvr5nc086y6u"}]},{"type":"transfer","attributes":[{"key":"recipient","value":"cosmos1a42emzmx2e8c2668u2taq8d3cwdvr5nc086y6u"},{"key":"sender","value":"cosmos1jv65s3grqf6v6jl3dp4t6c9t9rk99cd88lyufl"},{"key":"amount","value":"1footoken,14865stake"}]}]}],"info":"","gas_wanted":"200000","gas_used":"137113","tx":null,"timestamp":""}

[2021-09-10T03:11:44Z INFO  test_runner::happy_path] stderr:
[2021-09-10T03:11:44Z INFO  test_runner::happy_path] Validator set is not yet updated to 0>, waiting
[2021-09-10T03:11:45Z INFO  relayer::valset_relaying] We have detected latest valset 82 but latest on Ethereum is 0 This valset is estimated to cost 1000000000 Gas / 0.0001 ETH to submit
[2021-09-10T03:11:45Z INFO  ethereum_peggy::valset_update] Ordering signatures and submitting validator set 0 -> 82 update to Ethereum
[2021-09-10T03:11:45Z INFO  relayer::valset_relaying] We have detected latest valset 82 but latest on Ethereum is 0 This valset is estimated to cost 1000000000 Gas / 0.0001 ETH to submit
[2021-09-10T03:11:45Z INFO  ethereum_peggy::valset_update] Ordering signatures and submitting validator set 0 -> 82 update to Ethereum
[2021-09-10T03:11:45Z INFO  relayer::valset_relaying] We have detected latest valset 5 but latest on Ethereum is 0 This valset is estimated to cost 1000000000 Gas / 0.0001 ETH to submit
[2021-09-10T03:11:45Z INFO  ethereum_peggy::valset_update] Ordering signatures and submitting validator set 0 -> 5 update to Ethereum
[2021-09-10T03:11:46Z INFO  ethereum_peggy::valset_update] Sent valset update with txid 0xaabab42ae4ef1e905fa528ffad07ef6845774007fad0e7f375c3795a0c2e7d2b
[2021-09-10T03:11:46Z INFO  ethereum_peggy::valset_update] Sent valset update with txid 0xf3787a970fa84ccff2a4ae41a4a9e2ac37a024e4ef4b3427cb20c723f12938ba
[2021-09-10T03:11:46Z INFO  ethereum_peggy::valset_update] Sent valset update with txid 0xd1ae080267f0dbb3d3cfa09aebdb55e6565925f521612e336948210a00daa0d9
[2021-09-10T03:11:48Z INFO  ethereum_peggy::valset_update] Successfully updated Valset with new Nonce 82
[2021-09-10T03:11:48Z ERROR ethereum_peggy::valset_update] Current nonce is 82 expected to update to nonce 5
[2021-09-10T03:11:48Z INFO  ethereum_peggy::valset_update] Successfully updated Valset with new Nonce 82
[2021-09-10T03:11:48Z INFO  test_runner::happy_path] Validator set is not yet updated to 0>, waiting
[2021-09-10T03:11:52Z INFO  test_runner::happy_path] Validator set successfully updated!
[2021-09-10T03:11:52Z INFO  test_runner::happy_path] Sending in valset request
[2021-09-10T03:11:52Z INFO  test_runner::happy_path] Delegating 125000000stake to cosmosvaloper19a6z7v4hc62t267e4de74ayty05v30rvqkwnqe in order to generate a validator set update
[2021-09-10T03:11:55Z INFO  test_runner::happy_path] stdout: {"height":"85","txhash":"B964E64EA4AE00B2E1DBCE4BEFB7B8DF64066B4672C91ABAA15C781354B5752C","codespace":"","code":0,"data":"0A0A0A0864656C6567617465","raw_log":"[{\"events\":[{\"type\":\"delegate\",\"attributes\":[{\"key\":\"validator\",\"value\":\"cosmosvaloper19a6z7v4hc62t267e4de74ayty05v30rvqkwnqe\"},{\"key\":\"amount\",\"value\":\"125000000\"}]},{\"type\":\"message\",\"attributes\":[{\"key\":\"action\",\"value\":\"delegate\"},{\"key\":\"module\",\"value\":\"staking\"},{\"key\":\"sender\",\"value\":\"cosmos1a42emzmx2e8c2668u2taq8d3cwdvr5nc086y6u\"}]}]}]","logs":[{"msg_index":0,"log":"","events":[{"type":"delegate","attributes":[{"key":"validator","value":"cosmosvaloper19a6z7v4hc62t267e4de74ayty05v30rvqkwnqe"},{"key":"amount","value":"125000000"}]},{"type":"message","attributes":[{"key":"action","value":"delegate"},{"key":"module","value":"staking"},{"key":"sender","value":"cosmos1a42emzmx2e8c2668u2taq8d3cwdvr5nc086y6u"}]}]}],"info":"","gas_wanted":"200000","gas_used":"98662","tx":null,"timestamp":""}

[2021-09-10T03:11:55Z INFO  test_runner::happy_path] stderr:
[2021-09-10T03:11:56Z INFO  test_runner::happy_path] Validator set is not yet updated to 82>, waiting
3:11AM ERR dialing failed (attempts: 8): auth failure: secret conn failed: EOF addr={"id":"634cd4a67b879be0a83c3e0375cd5a3d539d9d02","ip":"7.7.7.3","port":26656} module=pex
3:11AM ERR dialing failed (attempts: 8): auth failure: secret conn failed: read tcp 7.7.7.2:38522->7.7.7.2:26656: read: connection reset by peer addr={"id":"47f6c6c8798fb47e3368364bc348b0ae04a89e8a","ip":"7.7.7.2","port":26656} module=pex
[2021-09-10T03:12:00Z INFO  test_runner::happy_path] Validator set is not yet updated to 82>, waiting
[2021-09-10T03:12:01Z INFO  orchestrator::main_loop] Sending 1 valset confirms starting with 85
[2021-09-10T03:12:01Z INFO  orchestrator::main_loop] Sending 1 valset confirms starting with 85
[2021-09-10T03:12:01Z INFO  orchestrator::main_loop] Sending 1 valset confirms starting with 85
[2021-09-10T03:12:04Z INFO  test_runner::happy_path] Validator set is not yet updated to 82>, waiting
[2021-09-10T03:12:08Z INFO  test_runner::happy_path] Validator set is not yet updated to 82>, waiting
[2021-09-10T03:12:12Z INFO  test_runner::happy_path] Validator set is not yet updated to 82>, waiting
[2021-09-10T03:12:16Z INFO  test_runner::happy_path] Validator set is not yet updated to 82>, waiting
[2021-09-10T03:12:19Z INFO  relayer::valset_relaying] We have detected latest valset 85 but latest on Ethereum is 82 This valset is estimated to cost 1000000000 Gas / 0.0001 ETH to submit
[2021-09-10T03:12:19Z INFO  ethereum_peggy::valset_update] Ordering signatures and submitting validator set 82 -> 85 update to Ethereum
[2021-09-10T03:12:19Z INFO  relayer::valset_relaying] We have detected latest valset 85 but latest on Ethereum is 82 This valset is estimated to cost 1000000000 Gas / 0.0001 ETH to submit
[2021-09-10T03:12:19Z INFO  ethereum_peggy::valset_update] Ordering signatures and submitting validator set 82 -> 85 update to Ethereum
[2021-09-10T03:12:20Z INFO  relayer::valset_relaying] We have detected latest valset 85 but latest on Ethereum is 82 This valset is estimated to cost 1000000000 Gas / 0.0001 ETH to submit
[2021-09-10T03:12:20Z INFO  ethereum_peggy::valset_update] Ordering signatures and submitting validator set 82 -> 85 update to Ethereum
[2021-09-10T03:12:20Z INFO  ethereum_peggy::valset_update] Sent valset update with txid 0x61a4427a9d6c6f10c9c89990985ffe23b62a58364c8fb8954d54e7c711d34ad9
[2021-09-10T03:12:20Z INFO  ethereum_peggy::valset_update] Sent valset update with txid 0x4d268e4d3ff95b11b05b1c707d69488d4f90281482626db1ebdfa6837c131185
[2021-09-10T03:12:20Z INFO  ethereum_peggy::valset_update] Sent valset update with txid 0x75cb37c35f06e110eb99c93d60ab88d841c50b370f8e76b894f64dbabd224e85
[2021-09-10T03:12:20Z INFO  test_runner::happy_path] Validator set is not yet updated to 82>, waiting
[2021-09-10T03:12:24Z INFO  test_runner::happy_path] Validator set is not yet updated to 82>, waiting
[2021-09-10T03:12:28Z INFO  test_runner::happy_path] Validator set is not yet updated to 82>, waiting
[2021-09-10T03:12:31Z INFO  ethereum_peggy::valset_update] Successfully updated Valset with new Nonce 85
[2021-09-10T03:12:31Z INFO  ethereum_peggy::valset_update] Successfully updated Valset with new Nonce 85
[2021-09-10T03:12:31Z INFO  ethereum_peggy::valset_update] Successfully updated Valset with new Nonce 85
[2021-09-10T03:12:32Z INFO  test_runner::happy_path] Validator set is not yet updated to 82>, waiting
[2021-09-10T03:12:36Z INFO  test_runner::happy_path] Validator set successfully updated!
[2021-09-10T03:12:36Z INFO  test_runner::happy_path] Sending to Cosmos from 0xBf660843528035a5A4921534E156a27e64B231fE to cosmos1ak4ukur2kyz6vwec54wy4fj5n7glwknhvfqhh2 with amount 100
[2021-09-10T03:12:51Z INFO  test_runner::happy_path] Send to Cosmos txid: 0x541ae4a90a6747a9d79536ad77db19da539c51a2130fa6980c5917082ff330c5
[2021-09-10T03:12:51Z INFO  test_runner::happy_path] Waiting for ERC20 deposit
[2021-09-10T03:12:55Z INFO  test_runner::happy_path] Waiting for ERC20 deposit
[2021-09-10T03:13:01Z INFO  test_runner::happy_path] Waiting for ERC20 deposit
[2021-09-10T03:13:01Z INFO  orchestrator::ethereum_event_watcher] Oracle observed deposit with sender 0xBf660843528035a5A4921534E156a27e64B231fE, destination cosmos1ak4ukur2kyz6vwec54wy4fj5n7glwknhvfqhh2, amount 100, and event nonce 1
[2021-09-10T03:13:01Z INFO  orchestrator::ethereum_event_watcher] Oracle observed deposit with sender 0xBf660843528035a5A4921534E156a27e64B231fE, destination cosmos1ak4ukur2kyz6vwec54wy4fj5n7glwknhvfqhh2, amount 100, and event nonce 1
[2021-09-10T03:13:01Z INFO  orchestrator::ethereum_event_watcher] Oracle observed deposit with sender 0xBf660843528035a5A4921534E156a27e64B231fE, destination cosmos1ak4ukur2kyz6vwec54wy4fj5n7glwknhvfqhh2, amount 100, and event nonce 1
[2021-09-10T03:13:06Z INFO  orchestrator::ethereum_event_watcher] Claims processed, new nonce 1
[2021-09-10T03:13:06Z INFO  orchestrator::ethereum_event_watcher] Claims processed, new nonce 1
[2021-09-10T03:13:06Z INFO  orchestrator::ethereum_event_watcher] Claims processed, new nonce 1
[2021-09-10T03:13:07Z INFO  test_runner::happy_path] Successfully bridged ERC20 100peggy0x0412C7c846bb6b7DC462CF6B453f76D8440b2609 to Cosmos! Balance is now 100peggy0x0412C7c846bb6b7DC462CF6B453f76D8440b2609
[2021-09-10T03:13:07Z INFO  test_runner::happy_path] Sending to Cosmos from 0xBf660843528035a5A4921534E156a27e64B231fE to cosmos1ak4ukur2kyz6vwec54wy4fj5n7glwknhvfqhh2 with amount 100
[2021-09-10T03:13:14Z INFO  orchestrator::ethereum_event_watcher] Oracle observed deposit with sender 0xBf660843528035a5A4921534E156a27e64B231fE, destination cosmos1ak4ukur2kyz6vwec54wy4fj5n7glwknhvfqhh2, amount 100, and event nonce 2
[2021-09-10T03:13:14Z INFO  test_runner::happy_path] Send to Cosmos txid: 0xe07820c41e8f3da77c4151c4e2d892ef53a6748d37b611ba70eb1d9aa6101f67
[2021-09-10T03:13:14Z INFO  test_runner::happy_path] Waiting for ERC20 deposit
[2021-09-10T03:13:14Z INFO  orchestrator::ethereum_event_watcher] Oracle observed deposit with sender 0xBf660843528035a5A4921534E156a27e64B231fE, destination cosmos1ak4ukur2kyz6vwec54wy4fj5n7glwknhvfqhh2, amount 100, and event nonce 2
[2021-09-10T03:13:17Z INFO  orchestrator::ethereum_event_watcher] Claims processed, new nonce 2
[2021-09-10T03:13:17Z INFO  orchestrator::ethereum_event_watcher] Claims processed, new nonce 2
[2021-09-10T03:13:17Z INFO  test_runner::happy_path] Waiting for ERC20 deposit
[2021-09-10T03:13:23Z INFO  test_runner::happy_path] Waiting for ERC20 deposit
[2021-09-10T03:13:27Z INFO  orchestrator::ethereum_event_watcher] Oracle observed deposit with sender 0xBf660843528035a5A4921534E156a27e64B231fE, destination cosmos1ak4ukur2kyz6vwec54wy4fj5n7glwknhvfqhh2, amount 100, and event nonce 2
[2021-09-10T03:13:28Z INFO  orchestrator::ethereum_event_watcher] Claims processed, new nonce 2
[2021-09-10T03:13:28Z INFO  test_runner::happy_path] Successfully bridged ERC20 100peggy0x0412C7c846bb6b7DC462CF6B453f76D8440b2609 to Cosmos! Balance is now 200peggy0x0412C7c846bb6b7DC462CF6B453f76D8440b2609
[2021-09-10T03:13:28Z INFO  test_runner::happy_path] Sending to Cosmos from 0xBf660843528035a5A4921534E156a27e64B231fE to cosmos1ak4ukur2kyz6vwec54wy4fj5n7glwknhvfqhh2 with amount 100
[2021-09-10T03:13:34Z INFO  test_runner::happy_path] Send to Cosmos txid: 0xb83e3a303355b092d38b78a57fee3420fccc62c855714a02bda6f501622211ea
[2021-09-10T03:13:34Z INFO  test_runner::happy_path] Waiting for ERC20 deposit
[2021-09-10T03:13:39Z INFO  test_runner::happy_path] Waiting for ERC20 deposit
[2021-09-10T03:13:40Z INFO  orchestrator::ethereum_event_watcher] Oracle observed deposit with sender 0xBf660843528035a5A4921534E156a27e64B231fE, destination cosmos1ak4ukur2kyz6vwec54wy4fj5n7glwknhvfqhh2, amount 100, and event nonce 3
[2021-09-10T03:13:40Z INFO  orchestrator::ethereum_event_watcher] Oracle observed deposit with sender 0xBf660843528035a5A4921534E156a27e64B231fE, destination cosmos1ak4ukur2kyz6vwec54wy4fj5n7glwknhvfqhh2, amount 100, and event nonce 3
[2021-09-10T03:13:40Z INFO  orchestrator::ethereum_event_watcher] Oracle observed deposit with sender 0xBf660843528035a5A4921534E156a27e64B231fE, destination cosmos1ak4ukur2kyz6vwec54wy4fj5n7glwknhvfqhh2, amount 100, and event nonce 3
[2021-09-10T03:13:44Z INFO  orchestrator::ethereum_event_watcher] Claims processed, new nonce 3
[2021-09-10T03:13:44Z INFO  orchestrator::ethereum_event_watcher] Claims processed, new nonce 3
[2021-09-10T03:13:44Z INFO  orchestrator::ethereum_event_watcher] Claims processed, new nonce 3
[2021-09-10T03:13:44Z INFO  test_runner::happy_path] Successfully bridged ERC20 100peggy0x0412C7c846bb6b7DC462CF6B453f76D8440b2609 to Cosmos! Balance is now 300peggy0x0412C7c846bb6b7DC462CF6B453f76D8440b2609
[2021-09-10T03:14:00Z INFO  test_runner::happy_path] Successfully failed to duplicate ERC20!
[2021-09-10T03:14:00Z INFO  test_runner::happy_path] Sending 295peggy0x0412C7c846bb6b7DC462CF6B453f76D8440b2609 from cosmos1ak4ukur2kyz6vwec54wy4fj5n7glwknhvfqhh2 on Cosmos back to Ethereum
[2021-09-10T03:14:05Z INFO  test_runner::happy_path] Sent tokens to Ethereum with TXSendResponse { logs: Some(Array([Object({"events": Array([Object({"attributes": Array([Object({"key": String("action"), "value": String("send_to_eth")}), Object({"key": String("sender"), "value": String("cosmos1ak4ukur2kyz6vwec54wy4fj5n7glwknhvfqhh2")}), Object({"key": String("module"), "value": String("send_to_eth")}), Object({"key": String("outgoing_tx_id"), "value": String("1")})]), "type": String("message")}), Object({"attributes": Array([Object({"key": String("recipient"), "value": String("cosmos1979qcq0kdz72w0k9rsxcmfmagx2cydrslxhw5s")}), Object({"key": String("sender"), "value": String("cosmos1ak4ukur2kyz6vwec54wy4fj5n7glwknhvfqhh2")}), Object({"key": String("amount"), "value": String("296peggy0x0412C7c846bb6b7DC462CF6B453f76D8440b2609")})]), "type": String("transfer")}), Object({"attributes": Array([Object({"key": String("module"), "value": String("peggy")}), Object({"key": String("bridge_contract")}), Object({"key": String("bridge_chain_id"), "value": String("0")}), Object({"key": String("outgoing_tx_id"), "value": String("1")}), Object({"key": String("nonce"), "value": String("1")})]), "type": String("withdrawal_received")})])})])), txhash: "9B7A6DEBF4E801C58FB15FA868139867A36D569252D08964C053AA6FC73C97FF" }
[2021-09-10T03:14:05Z INFO  test_runner::happy_path] Requesting transaction batch
[2021-09-10T03:14:13Z INFO  orchestrator::main_loop] Sending batch confirm for 0x0412C7c846bb6b7DC462CF6B453f76D8440b2609:1 with 1 in fees
[2021-09-10T03:14:13Z INFO  orchestrator::main_loop] Sending batch confirm for 0x0412C7c846bb6b7DC462CF6B453f76D8440b2609:1 with 1 in fees
[2021-09-10T03:14:13Z INFO  orchestrator::main_loop] Sending batch confirm for 0x0412C7c846bb6b7DC462CF6B453f76D8440b2609:1 with 1 in fees
[2021-09-10T03:14:17Z INFO  test_runner::happy_path] Batch is not yet submitted 0>, waiting
[2021-09-10T03:14:18Z INFO  relayer::batch_relaying] We have detected latest batch 1 but latest on Ethereum is 0 This batch is estimated to cost 1000000000 Gas / 0.0002 ETH to submit
[2021-09-10T03:14:18Z INFO  ethereum_peggy::submit_batch] Ordering signatures and submitting TransactionBatch 0x0412C7c846bb6b7DC462CF6B453f76D8440b2609:1 to Ethereum
[2021-09-10T03:14:18Z INFO  ethereum_peggy::submit_batch] Sent batch update with txid 0xd2a43aa4fbe1f6d0ed12b55297b8f402e1abe933edb61125532d1cadc10bfd87
[2021-09-10T03:14:18Z INFO  relayer::batch_relaying] We have detected latest batch 1 but latest on Ethereum is 0 This batch is estimated to cost 1000000000 Gas / 0.0002 ETH to submit
[2021-09-10T03:14:18Z INFO  ethereum_peggy::submit_batch] Ordering signatures and submitting TransactionBatch 0x0412C7c846bb6b7DC462CF6B453f76D8440b2609:1 to Ethereum
[2021-09-10T03:14:18Z INFO  relayer::batch_relaying] We have detected latest batch 1 but latest on Ethereum is 0 This batch is estimated to cost 1000000000 Gas / 0.0002 ETH to submit
[2021-09-10T03:14:18Z INFO  ethereum_peggy::submit_batch] Ordering signatures and submitting TransactionBatch 0x0412C7c846bb6b7DC462CF6B453f76D8440b2609:1 to Ethereum
[2021-09-10T03:14:18Z INFO  ethereum_peggy::submit_batch] Sent batch update with txid 0x8b23b7928f82d4dc70505453eda2928133a4ead9b6c71bdff7d934ab5115ccc3
[2021-09-10T03:14:18Z INFO  ethereum_peggy::submit_batch] Sent batch update with txid 0x16c69db19938e1f243caad9c1c5651d23331fa3a1836c9760c6b60ccf51ff6fe
[2021-09-10T03:14:21Z INFO  test_runner::happy_path] Batch is not yet submitted 0>, waiting
[2021-09-10T03:14:22Z INFO  ethereum_peggy::submit_batch] Successfully updated Batch with new Nonce 1
[2021-09-10T03:14:22Z INFO  ethereum_peggy::submit_batch] Successfully updated Batch with new Nonce 1
[2021-09-10T03:14:22Z INFO  ethereum_peggy::submit_batch] Successfully updated Batch with new Nonce 1
[2021-09-10T03:14:31Z INFO  orchestrator::ethereum_event_watcher] Oracle observed batch with nonce 1, contract 0x0412C7c846bb6b7DC462CF6B453f76D8440b2609, and event nonce 4
[2021-09-10T03:14:32Z INFO  orchestrator::ethereum_event_watcher] Oracle observed batch with nonce 1, contract 0x0412C7c846bb6b7DC462CF6B453f76D8440b2609, and event nonce 4
[2021-09-10T03:14:32Z INFO  orchestrator::ethereum_event_watcher] Oracle observed batch with nonce 1, contract 0x0412C7c846bb6b7DC462CF6B453f76D8440b2609, and event nonce 4
[2021-09-10T03:14:32Z INFO  orchestrator::ethereum_event_watcher] Claims processed, new nonce 4
[2021-09-10T03:14:34Z INFO  test_runner::happy_path] Successfully updated txbatch nonce to 1 and sent 295peggy0x0412C7c846bb6b7DC462CF6B453f76D8440b2609 tokens to Ethereum!
```