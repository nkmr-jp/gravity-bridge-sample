[Run Gravity bridge right now using docker](https://github.com/cosmos/gravity-bridge/tree/v0.1.1#run-gravity-bridge-right-now-using-docker)の`bash tests/all-up-test.sh`で出力されるログから、実行される内容を整理


# 1. Docker Image ビルド・コンテナ起動

```sh
+++ dirname tests/all-up-test.sh
++ cd tests
++ pwd
+ DIR=[PATH]/gravity-bridge/tests
+ bash [PATH]/gravity-bridge/tests/build-container.sh
+++ dirname [PATH]/gravity-bridge/tests/build-container.sh
++ cd [PATH]/gravity-bridge/tests
++ pwd
+ DIR=[PATH]/gravity-bridge/tests
+ DOCKERFOLDER=[PATH]/gravity-bridge/tests/dockerfile
+ REPOFOLDER=[PATH]/gravity-bridge/tests/..
+ pushd [PATH]/gravity-bridge/tests/..
+ git archive --format=tar.gz -o [PATH]/gravity-bridge/tests/dockerfile/peggy.tar.gz --prefix=peggy/ HEAD
+ pushd [PATH]/gravity-bridge/tests/dockerfile
+ docker build -t peggy-base .
[+] Building 596.6s (20/20) FINISHED                                                                                                                                                                                                                                              
 => [internal] load build definition from Dockerfile                                                                                                                                                                                                                         0.0s
 => => transferring dockerfile: 37B                                                                                                                                                                                                                                          0.0s
 => [internal] load .dockerignore                                                                                                                                                                                                                                            0.0s
 => => transferring context: 2B                                                                                                                                                                                                                                              0.0s
 => [internal] load metadata for docker.io/library/fedora:latest                                                                                                                                                                                                             1.0s
 => [internal] load build context                                                                                                                                                                                                                                            0.8s
 => => transferring context: 15.04MB                                                                                                                                                                                                                                         0.7s
 => [ 1/13] FROM docker.io/library/fedora@sha256:d18bc88f640bc3e88bbfacaff698c3e1e83cae649019657a3880881f2549a1d0                                                                                                                                                            0.0s
 => https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.10.1-c2d2f4ed.tar.gz                                                                                                                                                                                 594.6s
 => https://golang.org/dl/go1.15.6.linux-amd64.tar.gz                                                                                                                                                                                                                      262.8s
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
+ set -e
+ NODES=3
+ set +u
+ TEST_TYPE=
+ ALCHEMY_ID=
+ set -u
+ docker run --name peggy_all_up_test_instance --cap-add=NET_ADMIN -t peggy-base /bin/
```

# 2. コンテナ内でスクリプト実行

## 2-1. Setup Solidity

```sh
bash /peggy/tests/container-scripts/all-up-test-internal.sh 3
peggy_all_up_test_instance
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

updated 2 packages and audited 2527 packages in 24.853s

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
   │     New major version of npm available! 6.14.13 -> 7.22.0      │
   │   Changelog: https://github.com/npm/cli/releases/tag/v7.22.0   │
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
{"app_message":{"auth":{"accounts":[],"params":{"max_memo_characters":"256","sig_verify_cost_ed25519":"590","sig_verify_cost_secp256k1":"1000","tx_sig_limit":"7","tx_size_cost_per_byte":"10"}},"bank":{"balances":[],"denom_metadata":[],"params":{"default_send_enabled":true,"send_enabled":[]},"supply":[]},"capability":{"index":"1","owners":[]},"crisis":{"constant_fee":{"amount":"1000","denom":"stake"}},"distribution":{"delegator_starting_infos":[],"delegator_withdraw_infos":[],"fee_pool":{"community_pool":[]},"outstanding_rewards":[],"params":{"base_proposer_reward":"0.010000000000000000","bonus_proposer_reward":"0.040000000000000000","community_tax":"0.020000000000000000","withdraw_addr_enabled":true},"previous_proposer":"","validator_accumulated_commissions":[],"validator_current_rewards":[],"validator_historical_rewards":[],"validator_slash_events":[]},"evidence":{"evidence":[]},"genutil":{"gen_txs":[]},"gov":{"deposit_params":{"max_deposit_period":"172800s","min_deposit":[{"amount":"10000000","denom":"stake"}]},"deposits":[],"proposals":[],"starting_proposal_id":"1","tally_params":{"quorum":"0.334000000000000000","threshold":"0.500000000000000000","veto_threshold":"0.334000000000000000"},"votes":[],"voting_params":{"voting_period":"172800s"}},"ibc":{"channel_genesis":{"ack_sequences":[],"acknowledgements":[],"channels":[],"commitments":[],"next_channel_sequence":"0","receipts":[],"recv_sequences":[],"send_sequences":[]},"client_genesis":{"clients":[],"clients_consensus":[],"clients_metadata":[],"create_localhost":false,"next_client_sequence":"0","params":{"allowed_clients":["06-solomachine","07-tendermint"]}},"connection_genesis":{"client_connection_paths":[],"connections":[],"next_connection_sequence":"0"}},"mint":{"minter":{"annual_provisions":"0.000000000000000000","inflation":"0.130000000000000000"},"params":{"blocks_per_year":"6311520","goal_bonded":"0.670000000000000000","inflation_max":"0.200000000000000000","inflation_min":"0.070000000000000000","inflation_rate_change":"0.130000000000000000","mint_denom":"stake"}},"params":null,"peggy":{"attestations":[],"batch_confirms":[],"batches":[],"delegate_keys":[],"erc20_to_denoms":[],"last_observed_nonce":"0","logic_call_confirms":[],"logic_calls":[],"params":{"average_block_time":"5000","average_ethereum_block_time":"15000","bridge_chain_id":"0","bridge_ethereum_address":"","contract_source_hash":"","peggy_id":"defaultpeggyid","signed_batches_window":"10000","signed_claims_window":"10000","signed_valsets_window":"10000","slash_fraction_batch":"0.001000000000000000","slash_fraction_claim":"0.001000000000000000","slash_fraction_conflicting_claim":"0.001000000000000000","slash_fraction_valset":"0.001000000000000000","target_batch_timeout":"43200000","unbond_slashing_valsets_window":"10000"},"unbatched_transfers":[],"valset_confirms":[],"valsets":[]},"slashing":{"missed_blocks":[],"params":{"downtime_jail_duration":"600s","min_signed_per_window":"0.500000000000000000","signed_blocks_window":"100","slash_fraction_double_sign":"0.050000000000000000","slash_fraction_downtime":"0.010000000000000000"},"signing_infos":[]},"staking":{"delegations":[],"exported":false,"last_total_power":"0","last_validator_powers":[],"params":{"bond_denom":"stake","historical_entries":10000,"max_entries":7,"max_validators":100,"unbonding_time":"1814400s"},"redelegations":[],"unbonding_delegations":[],"validators":[]},"transfer":{"denom_traces":[],"params":{"receive_enabled":true,"send_enabled":true},"port_id":"transfer"},"upgrade":{},"vesting":{}},"chain_id":"peggy-test","gentxs_dir":"","moniker":"validator1","node_id":"3881e8f0d917cd1de98bb2f5d50b70970c8b8f97"}
+ jq '.app_state.bank.denom_metadata += [{"base": "footoken", display: "mfootoken", "description": "A non-staking test token", "denom_units": [{"denom": "footoken", "exponent": 0}, {"denom": "mfootoken", "exponent": 6}]}, {"base": "stake", display: "mstake", "description": "A staking test token", "denom_units": [{"denom": "stake", "exponent": 0}, {"denom": "mstake", "exponent": 6}]}]' /validator1/config/genesis.json
+ mv /edited-genesis.json /genesis.json
+ cp /legacy-api-enable /validator1/config/app.toml
```

### 2-2-2. `peggy keys add`

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
  address: cosmos1lna3043fuv6p8fnskxs2q7jufzpyzemly5y9as
  pubkey: cosmospub1addwnpepqv59y2age75v9jpwkfc3j9xpkdzwclxrtxy44qx2chgzhxw022hp2pls2ff
  mnemonic: ""
  threshold: 0
  pubkeys: []

++ peggy keys show validator1 -a --home /validator1 --keyring-backend test
+ KEY=cosmos1lna3043fuv6p8fnskxs2q7jufzpyzemly5y9as
+ mkdir -p /validator1/config/
+ mv /genesis.json /validator1/config/genesis.json
+ peggy add-genesis-account --home /validator1 --keyring-backend test cosmos1lna3043fuv6p8fnskxs2q7jufzpyzemly5y9as 10000000000stake,10000000000footoken
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
  address: cosmos1vdc2frekew3caavwcvk0pg2uztec4mu8vh9gek
  pubkey: cosmospub1addwnpepqd6vnv95ml29ph4ksga3y22zvehtel76hd9ty73mwr6ftavynms6jx35mth
  mnemonic: ""
  threshold: 0
  pubkeys: []

++ peggy keys show validator2 -a --home /validator2 --keyring-backend test
+ KEY=cosmos1vdc2frekew3caavwcvk0pg2uztec4mu8vh9gek
+ mkdir -p /validator2/config/
+ mv /genesis.json /validator2/config/genesis.json
+ peggy add-genesis-account --home /validator2 --keyring-backend test cosmos1vdc2frekew3caavwcvk0pg2uztec4mu8vh9gek 10000000000stake,10000000000footoken
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
  address: cosmos1nqxw98f0wj2grcvfw9pa2w6307untq5v5xqtyv
  pubkey: cosmospub1addwnpepq2lv9v7njuxwnveplwxl4rww0zatr648xr856y4gmtsyya8d4dmdj30n2c0
  mnemonic: ""
  threshold: 0
  pubkeys: []

++ peggy keys show validator3 -a --home /validator3 --keyring-backend test
+ KEY=cosmos1nqxw98f0wj2grcvfw9pa2w6307untq5v5xqtyv
+ mkdir -p /validator3/config/
+ mv /genesis.json /validator3/config/genesis.json
+ peggy add-genesis-account --home /validator3 --keyring-backend test cosmos1nqxw98f0wj2grcvfw9pa2w6307untq5v5xqtyv 10000000000stake,10000000000footoken
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
Genesis transaction written to "/validator1/config/gentx/gentx-3881e8f0d917cd1de98bb2f5d50b70970c8b8f97.json"
+ '[' 1 -gt 1 ']'
+ for i in $(seq 1 $NODES)
+ cp /genesis.json /validator2/config/genesis.json
+ GAIA_HOME='--home /validator2'
+ ARGS='--home /validator2 --keyring-backend test'
+ peggy gentx --home /validator2 --keyring-backend test --home /validator2 --moniker validator2 --chain-id=peggy-test --ip 7.7.7.2 validator2 500000000stake
Genesis transaction written to "/validator2/config/gentx/gentx-56880a24b86653602831e4f7f00883546bdbc4a9.json"
+ '[' 2 -gt 1 ']'
+ cp /validator2/config/gentx/gentx-56880a24b86653602831e4f7f00883546bdbc4a9.json /validator1/config/gentx/
+ for i in $(seq 1 $NODES)
+ cp /genesis.json /validator3/config/genesis.json
+ GAIA_HOME='--home /validator3'
+ ARGS='--home /validator3 --keyring-backend test'
+ peggy gentx --home /validator3 --keyring-backend test --home /validator3 --moniker validator3 --chain-id=peggy-test --ip 7.7.7.3 validator3 500000000stake
Genesis transaction written to "/validator3/config/gentx/gentx-eff68f5b8de54b31989ed05d714cf12d97a05071.json"
+ '[' 3 -gt 1 ']'
+ cp /validator3/config/gentx/gentx-eff68f5b8de54b31989ed05d714cf12d97a05071.json /validator1/config/gentx/
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
{"app_message":{"auth":{"accounts":[{"@type":"/cosmos.auth.v1beta1.BaseAccount","account_number":"0","address":"cosmos1lna3043fuv6p8fnskxs2q7jufzpyzemly5y9as","pub_key":null,"sequence":"0"},{"@type":"/cosmos.auth.v1beta1.BaseAccount","account_number":"0","address":"cosmos1vdc2frekew3caavwcvk0pg2uztec4mu8vh9gek","pub_key":null,"sequence":"0"},{"@type":"/cosmos.auth.v1beta1.BaseAccount","account_number":"0","address":"cosmos1nqxw98f0wj2grcvfw9pa2w6307untq5v5xqtyv","pub_key":null,"sequence":"0"}],"params":{"max_memo_characters":"256","sig_verify_cost_ed25519":"590","sig_verify_cost_secp256k1":"1000","tx_sig_limit":"7","tx_size_cost_per_byte":"10"}},"bank":{"balances":[{"address":"cosmos1vdc2frekew3caavwcvk0pg2uztec4mu8vh9gek","coins":[{"amount":"10000000000","denom":"footoken"},{"amount":"10000000000","denom":"stake"}]},{"address":"cosmos1nqxw98f0wj2grcvfw9pa2w6307untq5v5xqtyv","coins":[{"amount":"10000000000","denom":"footoken"},{"amount":"10000000000","denom":"stake"}]},{"address":"cosmos1lna3043fuv6p8fnskxs2q7jufzpyzemly5y9as","coins":[{"amount":"10000000000","denom":"footoken"},{"amount":"10000000000","denom":"stake"}]}],"denom_metadata":[{"base":"footoken","denom_units":[{"aliases":[],"denom":"footoken","exponent":0},{"aliases":[],"denom":"mfootoken","exponent":6}],"description":"A non-staking test token","display":"mfootoken"},{"base":"stake","denom_units":[{"aliases":[],"denom":"stake","exponent":0},{"aliases":[],"denom":"mstake","exponent":6}],"description":"A staking test token","display":"mstake"}],"params":{"default_send_enabled":true,"send_enabled":[]},"supply":[]},"capability":{"index":"1","owners":[]},"crisis":{"constant_fee":{"amount":"1000","denom":"stake"}},"distribution":{"delegator_starting_infos":[],"delegator_withdraw_infos":[],"fee_pool":{"community_pool":[]},"outstanding_rewards":[],"params":{"base_proposer_reward":"0.010000000000000000","bonus_proposer_reward":"0.040000000000000000","community_tax":"0.020000000000000000","withdraw_addr_enabled":true},"previous_proposer":"","validator_accumulated_commissions":[],"validator_current_rewards":[],"validator_historical_rewards":[],"validator_slash_events":[]},"evidence":{"evidence":[]},"genutil":{"gen_txs":[{"auth_info":{"fee":{"amount":[],"gas_limit":"200000","granter":"","payer":""},"signer_infos":[{"mode_info":{"single":{"mode":"SIGN_MODE_DIRECT"}},"public_key":{"@type":"/cosmos.crypto.secp256k1.PubKey","key":"AyhSK6jPqMLILrJxGRTBs0TsfMNZiVqAysXQK5nPUq4V"},"sequence":"0"}]},"body":{"extension_options":[],"memo":"3881e8f0d917cd1de98bb2f5d50b70970c8b8f97@7.7.7.1:26656","messages":[{"@type":"/cosmos.staking.v1beta1.MsgCreateValidator","commission":{"max_change_rate":"0.010000000000000000","max_rate":"0.200000000000000000","rate":"0.100000000000000000"},"delegator_address":"cosmos1lna3043fuv6p8fnskxs2q7jufzpyzemly5y9as","description":{"details":"","identity":"","moniker":"validator1","security_contact":"","website":""},"min_self_delegation":"1","pubkey":{"@type":"/cosmos.crypto.ed25519.PubKey","key":"s8mJ/cniwU1cf5Sm9kBffdkDEtl8Em81T5RQeF6H56g="},"validator_address":"cosmosvaloper1lna3043fuv6p8fnskxs2q7jufzpyzemlpqss3r","value":{"amount":"500000000","denom":"stake"}}],"non_critical_extension_options":[],"timeout_height":"0"},"signatures":["QwLvZA/Y+fpiBOZLNbJT4/uw/dlbuJvb2RCIrl3Cx+ETqP6uK9RP3vZgv/Lm7KX+05NybsUtvbgXZJprGjaWfQ=="]},{"auth_info":{"fee":{"amount":[],"gas_limit":"200000","granter":"","payer":""},"signer_infos":[{"mode_info":{"single":{"mode":"SIGN_MODE_DIRECT"}},"public_key":{"@type":"/cosmos.crypto.secp256k1.PubKey","key":"A3TJsLTf1FDetoI7EilCZm68/9q7SrJ6O3D0lfWEnuGp"},"sequence":"0"}]},"body":{"extension_options":[],"memo":"56880a24b86653602831e4f7f00883546bdbc4a9@7.7.7.2:26656","messages":[{"@type":"/cosmos.staking.v1beta1.MsgCreateValidator","commission":{"max_change_rate":"0.010000000000000000","max_rate":"0.200000000000000000","rate":"0.100000000000000000"},"delegator_address":"cosmos1vdc2frekew3caavwcvk0pg2uztec4mu8vh9gek","description":{"details":"","identity":"","moniker":"validator2","security_contact":"","website":""},"min_self_delegation":"1","pubkey":{"@type":"/cosmos.crypto.ed25519.PubKey","key":"coRdo2tQgu6E13rHk3IadrRbjI5rTi+JWZxeSooAomY="},"validator_address":"cosmosvaloper1vdc2frekew3caavwcvk0pg2uztec4mu8fr3a49","value":{"amount":"500000000","denom":"stake"}}],"non_critical_extension_options":[],"timeout_height":"0"},"signatures":["OL2LWiqbJ8m+4scTyoBzbyTxJt73yeK0N0tHz9PQcT8qZ8uxTiHj5AJU8QTWzRSvFJNaMs46716DJrlJKpGYvw=="]},{"auth_info":{"fee":{"amount":[],"gas_limit":"200000","granter":"","payer":""},"signer_infos":[{"mode_info":{"single":{"mode":"SIGN_MODE_DIRECT"}},"public_key":{"@type":"/cosmos.crypto.secp256k1.PubKey","key":"Ar7Cs9OXDOmzIfuN+o3OeLqx6qcwz00SqNrgQnTtq3bZ"},"sequence":"0"}]},"body":{"extension_options":[],"memo":"eff68f5b8de54b31989ed05d714cf12d97a05071@7.7.7.3:26656","messages":[{"@type":"/cosmos.staking.v1beta1.MsgCreateValidator","commission":{"max_change_rate":"0.010000000000000000","max_rate":"0.200000000000000000","rate":"0.100000000000000000"},"delegator_address":"cosmos1nqxw98f0wj2grcvfw9pa2w6307untq5v5xqtyv","description":{"details":"","identity":"","moniker":"validator3","security_contact":"","website":""},"min_self_delegation":"1","pubkey":{"@type":"/cosmos.crypto.ed25519.PubKey","key":"MbzNDmecKZgNvgLSbpKTBNqtKEM5D1YRbu8Rre8shGE="},"validator_address":"cosmosvaloper1nqxw98f0wj2grcvfw9pa2w6307untq5v3j57gl","value":{"amount":"500000000","denom":"stake"}}],"non_critical_extension_options":[],"timeout_height":"0"},"signatures":["x8h+2k21rfNYqR6EAqiD7nSjvHGeg/P/Z8b+nT17o/BCaXB6XCaELYGhhwaOQi2y2lksS6yt9QH1pBhtPNzBIg=="]}]},"gov":{"deposit_params":{"max_deposit_period":"172800s","min_deposit":[{"amount":"10000000","denom":"stake"}]},"deposits":[],"proposals":[],"starting_proposal_id":"1","tally_params":{"quorum":"0.334000000000000000","threshold":"0.500000000000000000","veto_threshold":"0.334000000000000000"},"votes":[],"voting_params":{"voting_period":"172800s"}},"ibc":{"channel_genesis":{"ack_sequences":[],"acknowledgements":[],"channels":[],"commitments":[],"next_channel_sequence":"0","receipts":[],"recv_sequences":[],"send_sequences":[]},"client_genesis":{"clients":[],"clients_consensus":[],"clients_metadata":[],"create_localhost":false,"next_client_sequence":"0","params":{"allowed_clients":["06-solomachine","07-tendermint"]}},"connection_genesis":{"client_connection_paths":[],"connections":[],"next_connection_sequence":"0"}},"mint":{"minter":{"annual_provisions":"0.000000000000000000","inflation":"0.130000000000000000"},"params":{"blocks_per_year":"6311520","goal_bonded":"0.670000000000000000","inflation_max":"0.200000000000000000","inflation_min":"0.070000000000000000","inflation_rate_change":"0.130000000000000000","mint_denom":"stake"}},"params":null,"peggy":{"attestations":[],"batch_confirms":[],"batches":[],"delegate_keys":[],"erc20_to_denoms":[],"last_observed_nonce":"0","logic_call_confirms":[],"logic_calls":[],"params":{"average_block_time":"5000","average_ethereum_block_time":"15000","bridge_chain_id":"0","bridge_ethereum_address":"","contract_source_hash":"","peggy_id":"defaultpeggyid","signed_batches_window":"10000","signed_claims_window":"10000","signed_valsets_window":"10000","slash_fraction_batch":"0.001000000000000000","slash_fraction_claim":"0.001000000000000000","slash_fraction_conflicting_claim":"0.001000000000000000","slash_fraction_valset":"0.001000000000000000","target_batch_timeout":"43200000","unbond_slashing_valsets_window":"10000"},"unbatched_transfers":[],"valset_confirms":[],"valsets":[]},"slashing":{"missed_blocks":[],"params":{"downtime_jail_duration":"600s","min_signed_per_window":"0.500000000000000000","signed_blocks_window":"100","slash_fraction_double_sign":"0.050000000000000000","slash_fraction_downtime":"0.010000000000000000"},"signing_infos":[]},"staking":{"delegations":[],"exported":false,"last_total_power":"0","last_validator_powers":[],"params":{"bond_denom":"stake","historical_entries":10000,"max_entries":7,"max_validators":100,"unbonding_time":"1814400s"},"redelegations":[],"unbonding_delegations":[],"validators":[]},"transfer":{"denom_traces":[],"params":{"receive_enabled":true,"send_enabled":true},"port_id":"transfer"},"upgrade":{},"vesting":{}},"chain_id":"peggy-test","gentxs_dir":"/validator1/config/gentx","moniker":"validator1","node_id":"3881e8f0d917cd1de98bb2f5d50b70970c8b8f97"}
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

```
+ pushd /peggy/orchestrator/test_runner
+ bash /peggy/tests/container-scripts/run-testnet.sh 3
/peggy/orchestrator/test_runner /peggy/solidity /
+ DEPLOY_CONTRACTS=1
+ RUST_BACKTRACE=full
+ RUST_LOG=INFO
+ PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/go/bin:/root/.cargo/bin
+ cargo run --release --bin test-runner
+ BIN=peggy
+ NODES=3
+ set +u
+ TEST_TYPE=
+ ALCHEMY_ID=
+ set -u
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
+ GAIA_HOME='--home /validator3'
+ [[ 3 -eq 1 ]]
+ RPC_ADDRESS='--rpc.laddr tcp://7.7.7.3:26658'
+ GRPC_ADDRESS='--grpc.address 7.7.7.3:9091'
+ LISTEN_ADDRESS='--address tcp://7.7.7.3:26655'
+ P2P_ADDRESS='--p2p.laddr tcp://7.7.7.3:26656'
+ LOG_LEVEL='--log_level error'
+ ARGS='--home /validator3 --address tcp://7.7.7.3:26655 --rpc.laddr tcp://7.7.7.3:26658 --grpc.address 7.7.7.3:9091 --log_level error --p2p.laddr tcp://7.7.7.3:26656'
+ sleep 10
+ peggy --home /validator2 --address tcp://7.7.7.2:26655 --rpc.laddr tcp://7.7.7.2:26658 --grpc.address 7.7.7.2:9091 --log_level error --p2p.laddr tcp://7.7.7.2:26656 start
+ peggy --home /validator3 --address tcp://7.7.7.3:26655 --rpc.laddr tcp://7.7.7.3:26658 --grpc.address 7.7.7.3:9091 --log_level error --p2p.laddr tcp://7.7.7.3:26656 start
3:17AM ERR pprof server error err="listen tcp 127.0.0.1:6060: bind: address already in use"
3:17AM ERR pprof server error err="listen tcp 127.0.0.1:6060: bind: address already in use"
3:17AM ERR dialing failed (attempts: 1): dial tcp 7.7.7.3:26656: connect: connection refused addr={"id":"eff68f5b8de54b31989ed05d714cf12d97a05071","ip":"7.7.7.3","port":26656} module=pex
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

    Finished release [optimized] target(s) in 2.23s
     Running `/peggy/orchestrator/target/release/test-runner`
[2021-09-09T03:17:45Z INFO  test_runner] Staring Peggy test-runner
[2021-09-09T03:17:45Z INFO  test_runner] Waiting for Cosmos chain to come online
+ [[ '' == *\A\R\B\I\T\R\A\R\Y\_\L\O\G\I\C* ]]
+ sleep 10
+ bash /peggy/tests/container-scripts/run-eth.sh
INFO [09-09|03:17:53.218] Maximum peer count                       ETH=50 LES=0 total=50
INFO [09-09|03:17:53.229] Smartcard socket not found, disabling    err="stat /run/pcscd/pcscd.comm: no such file or directory"
INFO [09-09|03:17:53.232] Set global gas cap                       cap=25000000
INFO [09-09|03:17:53.240] Allocated cache and file handles         database=/root/.ethereum/geth/chaindata cache=16.00MiB handles=16
INFO [09-09|03:17:53.299] Writing custom genesis block 
INFO [09-09|03:17:53.304] Persisted trie from memory database      nodes=1 size=150.00B time="349.7µs" gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
INFO [09-09|03:17:53.310] Successfully wrote genesis state         database=chaindata                      hash="1d4e59…faac29"
INFO [09-09|03:17:53.311] Allocated cache and file handles         database=/root/.ethereum/geth/lightchaindata cache=16.00MiB handles=16
INFO [09-09|03:17:53.326] Writing custom genesis block 
INFO [09-09|03:17:53.328] Persisted trie from memory database      nodes=1 size=150.00B time="234.3µs" gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
INFO [09-09|03:17:53.331] Successfully wrote genesis state         database=lightchaindata                      hash="1d4e59…faac29"
[2021-09-09T03:18:06Z INFO  test_runner] test-runner in contract deploying mode, deploying contracts, then exiting
[2021-09-09T03:18:06Z INFO  test_runner::bootstrapping] Signing and submitting Delegate addresses 0x233A784C6FAf3FE8Ce07eC9868B44dFfC5b52089 for validator cosmos1lna3043fuv6p8fnskxs2q7jufzpyzemly5y9as
[2021-09-09T03:18:06Z INFO  test_runner::bootstrapping] Signing and submitting Delegate addresses 0xB8881BFc542611Ae69bb947b8A954dFED0a7D1Dd for validator cosmos1vdc2frekew3caavwcvk0pg2uztec4mu8vh9gek
[2021-09-09T03:18:06Z INFO  test_runner::bootstrapping] Signing and submitting Delegate addresses 0x734C2d60EFCCae1ed0Eb85E2242a2F33F41450E3 for validator cosmos1nqxw98f0wj2grcvfw9pa2w6307untq5v5xqtyv
3:18AM ERR dialing failed (attempts: 1): auth failure: secret conn failed: EOF addr={"id":"eff68f5b8de54b31989ed05d714cf12d97a05071","ip":"7.7.7.3","port":26656} module=pex
3:18AM ERR dialing failed (attempts: 1): auth failure: secret conn failed: EOF addr={"id":"56880a24b86653602831e4f7f00883546bdbc4a9","ip":"7.7.7.2","port":26656} module=pex
3:19AM ERR dialing failed (attempts: 2): auth failure: secret conn failed: EOF addr={"id":"eff68f5b8de54b31989ed05d714cf12d97a05071","ip":"7.7.7.3","port":26656} module=pex
3:19AM ERR dialing failed (attempts: 2): auth failure: secret conn failed: EOF addr={"id":"56880a24b86653602831e4f7f00883546bdbc4a9","ip":"7.7.7.2","port":26656} module=pex
3:19AM ERR dialing failed (attempts: 3): auth failure: secret conn failed: EOF addr={"id":"eff68f5b8de54b31989ed05d714cf12d97a05071","ip":"7.7.7.3","port":26656} module=pex
3:19AM ERR dialing failed (attempts: 3): auth failure: secret conn failed: EOF addr={"id":"56880a24b86653602831e4f7f00883546bdbc4a9","ip":"7.7.7.2","port":26656} module=pex
3:20AM ERR dialing failed (attempts: 4): auth failure: secret conn failed: EOF addr={"id":"eff68f5b8de54b31989ed05d714cf12d97a05071","ip":"7.7.7.3","port":26656} module=pex
3:20AM ERR dialing failed (attempts: 4): auth failure: secret conn failed: EOF addr={"id":"56880a24b86653602831e4f7f00883546bdbc4a9","ip":"7.7.7.2","port":26656} module=pex
3:20AM ERR dialing failed (attempts: 5): auth failure: secret conn failed: read tcp 7.7.7.3:51736->7.7.7.3:26656: read: connection reset by peer addr={"id":"eff68f5b8de54b31989ed05d714cf12d97a05071","ip":"7.7.7.3","port":26656} module=pex
3:20AM ERR dialing failed (attempts: 5): auth failure: secret conn failed: EOF addr={"id":"56880a24b86653602831e4f7f00883546bdbc4a9","ip":"7.7.7.2","port":26656} module=pex
3:21AM ERR dialing failed (attempts: 6): auth failure: secret conn failed: read tcp 7.7.7.3:51860->7.7.7.3:26656: read: connection reset by peer addr={"id":"eff68f5b8de54b31989ed05d714cf12d97a05071","ip":"7.7.7.3","port":26656} module=pex
3:21AM ERR dialing failed (attempts: 6): auth failure: secret conn failed: read tcp 7.7.7.2:35546->7.7.7.2:26656: read: connection reset by peer addr={"id":"56880a24b86653602831e4f7f00883546bdbc4a9","ip":"7.7.7.2","port":26656} module=pex
3:23AM ERR dialing failed (attempts: 7): auth failure: secret conn failed: read tcp 7.7.7.3:52076->7.7.7.3:26656: read: connection reset by peer addr={"id":"eff68f5b8de54b31989ed05d714cf12d97a05071","ip":"7.7.7.3","port":26656} module=pex
3:23AM ERR dialing failed (attempts: 7): auth failure: secret conn failed: EOF addr={"id":"56880a24b86653602831e4f7f00883546bdbc4a9","ip":"7.7.7.2","port":26656} module=pex
[2021-09-09T03:23:59Z INFO  test_runner::bootstrapping] stdout: Test mode, deploying ERC20 contracts
    ERC20 deployed at Address -  0x0412C7c846bb6b7DC462CF6B453f76D8440b2609
    ERC20 deployed at Address -  0x30dA8589BFa1E509A319489E014d384b87815D89
    ERC20 deployed at Address -  0x9676519d99E390A180Ab1445d5d857E3f6869065
    Uniswap Liquidity test deployed at Address -  0xD7600ae27C99988A6CD360234062b540F88ECA43
    Starting Peggy contract deploy
    About to get latest Peggy valset
    {
      "type": "peggy/Valset",
      "value": {
        "nonce": "64",
        "members": [
          {
            "power": "1431655765",
            "ethereum_address": "0x233A784C6FAf3FE8Ce07eC9868B44dFfC5b52089"
          },
          {
            "power": "1431655765",
            "ethereum_address": "0x734C2d60EFCCae1ed0Eb85E2242a2F33F41450E3"
          },
          {
            "power": "1431655765",
            "ethereum_address": "0xB8881BFc542611Ae69bb947b8A954dFED0a7D1Dd"
          }
        ],
        "height": "64"
      }
    }
    Peggy deployed at Address -  0x7580bFE88Dd3d07947908FAE12d95872a260F2D8
    
[2021-09-09T03:23:59Z INFO  test_runner::bootstrapping] stderr: 
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

    Finished release [optimized] target(s) in 1.69s
     Running `/peggy/orchestrator/target/release/test-runner`
[2021-09-09T03:24:02Z INFO  test_runner] Staring Peggy test-runner
[2021-09-09T03:24:02Z INFO  test_runner] Waiting for Cosmos chain to come online
[2021-09-09T03:24:18Z INFO  test_runner::utils] Sending orchestrators 100 eth to pay for fees miner has 23229348 ETH
[2021-09-09T03:24:28Z INFO  test_runner] Starting tests with Ok("")
[2021-09-09T03:24:28Z INFO  test_runner] Starting Happy path test
[2021-09-09T03:24:28Z INFO  test_runner::happy_path] Spawning Orchestrator
[2021-09-09T03:24:28Z INFO  orchestrator::oracle_resync] Oracle is resyncing, looking back into the history to find our last event nonce 1, on block 15
[2021-09-09T03:24:28Z INFO  test_runner::happy_path] Spawning Orchestrator
[2021-09-09T03:24:28Z INFO  test_runner::happy_path] Spawning Orchestrator
[2021-09-09T03:24:28Z INFO  orchestrator::oracle_resync] Oracle is resyncing, looking back into the history to find our last event nonce 1, on block 15
[2021-09-09T03:24:28Z INFO  orchestrator::main_loop] Oracle resync complete, Oracle now operational
[2021-09-09T03:24:29Z INFO  orchestrator::main_loop] Sending 5 valset confirms starting with 5
[2021-09-09T03:24:29Z INFO  orchestrator::oracle_resync] Oracle is resyncing, looking back into the history to find our last event nonce 1, on block 15
[2021-09-09T03:24:29Z INFO  orchestrator::main_loop] Sending 5 valset confirms starting with 5
[2021-09-09T03:24:29Z INFO  orchestrator::main_loop] Oracle resync complete, Oracle now operational
[2021-09-09T03:24:29Z INFO  test_runner::happy_path] Sending in valset request
[2021-09-09T03:24:29Z INFO  test_runner::happy_path] Delegating 125000000stake to cosmosvaloper1vdc2frekew3caavwcvk0pg2uztec4mu8fr3a49 in order to generate a validator set update
[2021-09-09T03:24:30Z INFO  orchestrator::main_loop] Sending 5 valset confirms starting with 5
[2021-09-09T03:24:30Z INFO  orchestrator::main_loop] Oracle resync complete, Oracle now operational
[2021-09-09T03:24:30Z ERROR relayer::valset_relaying] We don't have a latest confirmed valset?
[2021-09-09T03:24:30Z ERROR relayer::valset_relaying] We don't have a latest confirmed valset?
[2021-09-09T03:24:30Z ERROR relayer::valset_relaying] We don't have a latest confirmed valset?
[2021-09-09T03:24:40Z INFO  orchestrator::main_loop] Sending 1 valset confirms starting with 74
[2021-09-09T03:24:40Z INFO  orchestrator::main_loop] Sending 1 valset confirms starting with 74
[2021-09-09T03:24:40Z INFO  orchestrator::main_loop] Sending 1 valset confirms starting with 74
[2021-09-09T03:24:45Z INFO  test_runner::happy_path] stdout: {"height":"74","txhash":"0ADE4D4E34E08CAAB54D84A8BF5EE9DB2C19449DC89E92DB274D326F8372DE1E","codespace":"","code":0,"data":"0A0A0A0864656C6567617465","raw_log":"[{\"events\":[{\"type\":\"delegate\",\"attributes\":[{\"key\":\"validator\",\"value\":\"cosmosvaloper1vdc2frekew3caavwcvk0pg2uztec4mu8fr3a49\"},{\"key\":\"amount\",\"value\":\"125000000\"}]},{\"type\":\"message\",\"attributes\":[{\"key\":\"action\",\"value\":\"delegate\"},{\"key\":\"module\",\"value\":\"staking\"},{\"key\":\"sender\",\"value\":\"cosmos1lna3043fuv6p8fnskxs2q7jufzpyzemly5y9as\"}]}]}]","logs":[{"msg_index":0,"log":"","events":[{"type":"delegate","attributes":[{"key":"validator","value":"cosmosvaloper1vdc2frekew3caavwcvk0pg2uztec4mu8fr3a49"},{"key":"amount","value":"125000000"}]},{"type":"message","attributes":[{"key":"action","value":"delegate"},{"key":"module","value":"staking"},{"key":"sender","value":"cosmos1lna3043fuv6p8fnskxs2q7jufzpyzemly5y9as"}]}]}],"info":"","gas_wanted":"200000","gas_used":"98701","tx":null,"timestamp":""}
    
[2021-09-09T03:24:45Z INFO  test_runner::happy_path] stderr: 
[2021-09-09T03:24:45Z INFO  test_runner::happy_path] Validator set is not yet updated to 0>, waiting
[2021-09-09T03:24:46Z INFO  relayer::valset_relaying] We have detected latest valset 74 but latest on Ethereum is 0 This valset is estimated to cost 1000000000 Gas / 0.0001 ETH to submit
[2021-09-09T03:24:46Z INFO  ethereum_peggy::valset_update] Ordering signatures and submitting validator set 0 -> 74 update to Ethereum
[2021-09-09T03:24:46Z INFO  relayer::valset_relaying] We have detected latest valset 74 but latest on Ethereum is 0 This valset is estimated to cost 1000000000 Gas / 0.0001 ETH to submit
[2021-09-09T03:24:46Z INFO  ethereum_peggy::valset_update] Ordering signatures and submitting validator set 0 -> 74 update to Ethereum
[2021-09-09T03:24:46Z INFO  relayer::valset_relaying] We have detected latest valset 5 but latest on Ethereum is 0 This valset is estimated to cost 1000000000 Gas / 0.0001 ETH to submit
[2021-09-09T03:24:46Z INFO  ethereum_peggy::valset_update] Ordering signatures and submitting validator set 0 -> 5 update to Ethereum
[2021-09-09T03:24:46Z INFO  ethereum_peggy::valset_update] Sent valset update with txid 0x7d014754d148c275e9a6080dcf64b32f187d9984785ce4bdc1e4bb00f021cfba
[2021-09-09T03:24:46Z INFO  ethereum_peggy::valset_update] Sent valset update with txid 0xbb83f4efe22bc3b399b7f83abc8ffcfaee495c9af368900ed326dde887b5bc68
[2021-09-09T03:24:46Z INFO  ethereum_peggy::valset_update] Sent valset update with txid 0xb20eb75c001562195a7db971fe285ab300c2d29dcb0a3fc88e127adb8ea9c817
[2021-09-09T03:24:49Z INFO  test_runner::happy_path] Validator set is not yet updated to 0>, waiting
[2021-09-09T03:24:51Z INFO  ethereum_peggy::valset_update] Successfully updated Valset with new Nonce 74
[2021-09-09T03:24:51Z INFO  ethereum_peggy::valset_update] Successfully updated Valset with new Nonce 74
[2021-09-09T03:24:52Z ERROR ethereum_peggy::valset_update] Current nonce is 74 expected to update to nonce 5
[2021-09-09T03:24:53Z INFO  test_runner::happy_path] Validator set is not yet updated to 0>, waiting
[2021-09-09T03:24:57Z INFO  test_runner::happy_path] Validator set successfully updated!
[2021-09-09T03:24:57Z INFO  test_runner::happy_path] Sending in valset request
[2021-09-09T03:24:57Z INFO  test_runner::happy_path] Delegating 125000000stake to cosmosvaloper1lna3043fuv6p8fnskxs2q7jufzpyzemlpqss3r in order to generate a validator set update
[2021-09-09T03:25:02Z INFO  test_runner::happy_path] stdout: {"height":"78","txhash":"C713C25E015BC27F86631E43CD0EDD1CE7D0E4D6DECB4FE0A657323EAD662FF5","codespace":"","code":0,"data":"0A0A0A0864656C6567617465","raw_log":"[{\"events\":[{\"type\":\"delegate\",\"attributes\":[{\"key\":\"validator\",\"value\":\"cosmosvaloper1lna3043fuv6p8fnskxs2q7jufzpyzemlpqss3r\"},{\"key\":\"amount\",\"value\":\"125000000\"}]},{\"type\":\"message\",\"attributes\":[{\"key\":\"action\",\"value\":\"delegate\"},{\"key\":\"sender\",\"value\":\"cosmos1jv65s3grqf6v6jl3dp4t6c9t9rk99cd88lyufl\"},{\"key\":\"module\",\"value\":\"staking\"},{\"key\":\"sender\",\"value\":\"cosmos1lna3043fuv6p8fnskxs2q7jufzpyzemly5y9as\"}]},{\"type\":\"transfer\",\"attributes\":[{\"key\":\"recipient\",\"value\":\"cosmos1lna3043fuv6p8fnskxs2q7jufzpyzemly5y9as\"},{\"key\":\"sender\",\"value\":\"cosmos1jv65s3grqf6v6jl3dp4t6c9t9rk99cd88lyufl\"},{\"key\":\"amount\",\"value\":\"2footoken,14094stake\"}]}]}]","logs":[{"msg_index":0,"log":"","events":[{"type":"delegate","attributes":[{"key":"validator","value":"cosmosvaloper1lna3043fuv6p8fnskxs2q7jufzpyzemlpqss3r"},{"key":"amount","value":"125000000"}]},{"type":"message","attributes":[{"key":"action","value":"delegate"},{"key":"sender","value":"cosmos1jv65s3grqf6v6jl3dp4t6c9t9rk99cd88lyufl"},{"key":"module","value":"staking"},{"key":"sender","value":"cosmos1lna3043fuv6p8fnskxs2q7jufzpyzemly5y9as"}]},{"type":"transfer","attributes":[{"key":"recipient","value":"cosmos1lna3043fuv6p8fnskxs2q7jufzpyzemly5y9as"},{"key":"sender","value":"cosmos1jv65s3grqf6v6jl3dp4t6c9t9rk99cd88lyufl"},{"key":"amount","value":"2footoken,14094stake"}]}]}],"info":"","gas_wanted":"200000","gas_used":"137119","tx":null,"timestamp":""}
    
[2021-09-09T03:25:02Z INFO  test_runner::happy_path] stderr: 
[2021-09-09T03:25:02Z INFO  orchestrator::main_loop] Sending 1 valset confirms starting with 78
[2021-09-09T03:25:02Z INFO  test_runner::happy_path] Validator set is not yet updated to 74>, waiting
[2021-09-09T03:25:02Z INFO  orchestrator::main_loop] Sending 1 valset confirms starting with 78
[2021-09-09T03:25:02Z INFO  orchestrator::main_loop] Sending 1 valset confirms starting with 78
[2021-09-09T03:25:06Z INFO  test_runner::happy_path] Validator set is not yet updated to 74>, waiting
[2021-09-09T03:25:10Z INFO  test_runner::happy_path] Validator set is not yet updated to 74>, waiting
[2021-09-09T03:25:14Z INFO  test_runner::happy_path] Validator set is not yet updated to 74>, waiting
[2021-09-09T03:25:18Z INFO  test_runner::happy_path] Validator set is not yet updated to 74>, waiting
[2021-09-09T03:25:20Z INFO  relayer::valset_relaying] We have detected latest valset 78 but latest on Ethereum is 74 This valset is estimated to cost 1000000000 Gas / 0.0001 ETH to submit
[2021-09-09T03:25:20Z INFO  ethereum_peggy::valset_update] Ordering signatures and submitting validator set 74 -> 78 update to Ethereum
[2021-09-09T03:25:20Z INFO  relayer::valset_relaying] We have detected latest valset 78 but latest on Ethereum is 74 This valset is estimated to cost 1000000000 Gas / 0.0001 ETH to submit
[2021-09-09T03:25:20Z INFO  ethereum_peggy::valset_update] Ordering signatures and submitting validator set 74 -> 78 update to Ethereum
[2021-09-09T03:25:20Z INFO  relayer::valset_relaying] We have detected latest valset 78 but latest on Ethereum is 74 This valset is estimated to cost 1000000000 Gas / 0.0001 ETH to submit
[2021-09-09T03:25:20Z INFO  ethereum_peggy::valset_update] Ordering signatures and submitting validator set 74 -> 78 update to Ethereum
[2021-09-09T03:25:20Z INFO  ethereum_peggy::valset_update] Sent valset update with txid 0xee5bfb8a1dfd755a08d6793e8d3f6acba51f5d6d802ff588715e572210c5a41a
[2021-09-09T03:25:20Z INFO  ethereum_peggy::valset_update] Sent valset update with txid 0x76eb95fbdebb3eeb5aace17ee9ebad7db7f887bff0f0150112463fb560940dbc
[2021-09-09T03:25:20Z INFO  ethereum_peggy::valset_update] Sent valset update with txid 0x898d4575567002a423325281298fa6d37b326071949d34964d89a0a84ba68791
[2021-09-09T03:25:21Z INFO  ethereum_peggy::valset_update] Successfully updated Valset with new Nonce 78
[2021-09-09T03:25:21Z INFO  ethereum_peggy::valset_update] Successfully updated Valset with new Nonce 78
[2021-09-09T03:25:21Z INFO  ethereum_peggy::valset_update] Successfully updated Valset with new Nonce 78
[2021-09-09T03:25:23Z INFO  test_runner::happy_path] Validator set is not yet updated to 74>, waiting
[2021-09-09T03:25:27Z INFO  test_runner::happy_path] Validator set successfully updated!
[2021-09-09T03:25:27Z INFO  test_runner::happy_path] Sending to Cosmos from 0xBf660843528035a5A4921534E156a27e64B231fE to cosmos1ry437cqvlexdq3mwhv8lnr6mmejx5r5dvhxwy9 with amount 100
3:25AM ERR dialing failed (attempts: 8): auth failure: secret conn failed: EOF addr={"id":"eff68f5b8de54b31989ed05d714cf12d97a05071","ip":"7.7.7.3","port":26656} module=pex
3:25AM ERR dialing failed (attempts: 8): auth failure: secret conn failed: EOF addr={"id":"56880a24b86653602831e4f7f00883546bdbc4a9","ip":"7.7.7.2","port":26656} module=pex
[2021-09-09T03:25:56Z INFO  test_runner::happy_path] Send to Cosmos txid: 0x7bf33f9620d415d13e234526414d2c01ce987c31233d86c7afdbfed6f491f136
[2021-09-09T03:25:56Z INFO  test_runner::happy_path] Waiting for ERC20 deposit
[2021-09-09T03:25:57Z INFO  test_runner::happy_path] Waiting for ERC20 deposit
[2021-09-09T03:26:00Z INFO  orchestrator::ethereum_event_watcher] Oracle observed deposit with sender 0xBf660843528035a5A4921534E156a27e64B231fE, destination cosmos1ry437cqvlexdq3mwhv8lnr6mmejx5r5dvhxwy9, amount 100, and event nonce 1
[2021-09-09T03:26:00Z INFO  orchestrator::ethereum_event_watcher] Oracle observed deposit with sender 0xBf660843528035a5A4921534E156a27e64B231fE, destination cosmos1ry437cqvlexdq3mwhv8lnr6mmejx5r5dvhxwy9, amount 100, and event nonce 1
[2021-09-09T03:26:01Z INFO  orchestrator::ethereum_event_watcher] Oracle observed deposit with sender 0xBf660843528035a5A4921534E156a27e64B231fE, destination cosmos1ry437cqvlexdq3mwhv8lnr6mmejx5r5dvhxwy9, amount 100, and event nonce 1
[2021-09-09T03:26:02Z INFO  test_runner::happy_path] Waiting for ERC20 deposit
[2021-09-09T03:26:02Z INFO  orchestrator::ethereum_event_watcher] Claims processed, new nonce 1
[2021-09-09T03:26:02Z INFO  orchestrator::ethereum_event_watcher] Claims processed, new nonce 1
[2021-09-09T03:26:02Z INFO  orchestrator::ethereum_event_watcher] Claims processed, new nonce 1
[2021-09-09T03:26:08Z INFO  test_runner::happy_path] Successfully bridged ERC20 100peggy0x0412C7c846bb6b7DC462CF6B453f76D8440b2609 to Cosmos! Balance is now 100peggy0x0412C7c846bb6b7DC462CF6B453f76D8440b2609
[2021-09-09T03:26:08Z INFO  test_runner::happy_path] Sending to Cosmos from 0xBf660843528035a5A4921534E156a27e64B231fE to cosmos1ry437cqvlexdq3mwhv8lnr6mmejx5r5dvhxwy9 with amount 100
[2021-09-09T03:26:10Z INFO  test_runner::happy_path] Send to Cosmos txid: 0x9db61541196cda4b7fcff419c5f4072b505991dc13e1f2cc8de0fe61eced5b43
[2021-09-09T03:26:10Z INFO  test_runner::happy_path] Waiting for ERC20 deposit
[2021-09-09T03:26:13Z INFO  orchestrator::ethereum_event_watcher] Oracle observed deposit with sender 0xBf660843528035a5A4921534E156a27e64B231fE, destination cosmos1ry437cqvlexdq3mwhv8lnr6mmejx5r5dvhxwy9, amount 100, and event nonce 2
[2021-09-09T03:26:13Z INFO  orchestrator::ethereum_event_watcher] Oracle observed deposit with sender 0xBf660843528035a5A4921534E156a27e64B231fE, destination cosmos1ry437cqvlexdq3mwhv8lnr6mmejx5r5dvhxwy9, amount 100, and event nonce 2
[2021-09-09T03:26:14Z INFO  test_runner::happy_path] Waiting for ERC20 deposit
[2021-09-09T03:26:14Z INFO  orchestrator::ethereum_event_watcher] Oracle observed deposit with sender 0xBf660843528035a5A4921534E156a27e64B231fE, destination cosmos1ry437cqvlexdq3mwhv8lnr6mmejx5r5dvhxwy9, amount 100, and event nonce 2
[2021-09-09T03:26:18Z INFO  orchestrator::ethereum_event_watcher] Claims processed, new nonce 2
[2021-09-09T03:26:18Z INFO  orchestrator::ethereum_event_watcher] Claims processed, new nonce 2
[2021-09-09T03:26:18Z INFO  orchestrator::ethereum_event_watcher] Claims processed, new nonce 2
[2021-09-09T03:26:19Z INFO  test_runner::happy_path] Successfully bridged ERC20 100peggy0x0412C7c846bb6b7DC462CF6B453f76D8440b2609 to Cosmos! Balance is now 200peggy0x0412C7c846bb6b7DC462CF6B453f76D8440b2609
[2021-09-09T03:26:19Z INFO  test_runner::happy_path] Sending to Cosmos from 0xBf660843528035a5A4921534E156a27e64B231fE to cosmos1ry437cqvlexdq3mwhv8lnr6mmejx5r5dvhxwy9 with amount 100
[2021-09-09T03:26:28Z INFO  test_runner::happy_path] Send to Cosmos txid: 0x033e6b1b3176b9530afd237ccf5ff18c0a58bac9b7e81187accb2ebc71c40b52
[2021-09-09T03:26:28Z INFO  test_runner::happy_path] Waiting for ERC20 deposit
[2021-09-09T03:26:30Z INFO  test_runner::happy_path] Waiting for ERC20 deposit
[2021-09-09T03:26:35Z INFO  test_runner::happy_path] Waiting for ERC20 deposit
[2021-09-09T03:26:39Z INFO  orchestrator::ethereum_event_watcher] Oracle observed deposit with sender 0xBf660843528035a5A4921534E156a27e64B231fE, destination cosmos1ry437cqvlexdq3mwhv8lnr6mmejx5r5dvhxwy9, amount 100, and event nonce 3
[2021-09-09T03:26:39Z INFO  orchestrator::ethereum_event_watcher] Oracle observed deposit with sender 0xBf660843528035a5A4921534E156a27e64B231fE, destination cosmos1ry437cqvlexdq3mwhv8lnr6mmejx5r5dvhxwy9, amount 100, and event nonce 3
[2021-09-09T03:26:40Z INFO  orchestrator::ethereum_event_watcher] Oracle observed deposit with sender 0xBf660843528035a5A4921534E156a27e64B231fE, destination cosmos1ry437cqvlexdq3mwhv8lnr6mmejx5r5dvhxwy9, amount 100, and event nonce 3
[2021-09-09T03:26:40Z INFO  test_runner::happy_path] Waiting for ERC20 deposit
[2021-09-09T03:26:40Z INFO  orchestrator::ethereum_event_watcher] Claims processed, new nonce 3
[2021-09-09T03:26:40Z INFO  orchestrator::ethereum_event_watcher] Claims processed, new nonce 3
[2021-09-09T03:26:46Z INFO  orchestrator::ethereum_event_watcher] Claims processed, new nonce 3
[2021-09-09T03:26:46Z INFO  test_runner::happy_path] Successfully bridged ERC20 100peggy0x0412C7c846bb6b7DC462CF6B453f76D8440b2609 to Cosmos! Balance is now 300peggy0x0412C7c846bb6b7DC462CF6B453f76D8440b2609
[2021-09-09T03:27:02Z INFO  test_runner::happy_path] Successfully failed to duplicate ERC20!
[2021-09-09T03:27:02Z INFO  test_runner::happy_path] Sending 295peggy0x0412C7c846bb6b7DC462CF6B453f76D8440b2609 from cosmos1ry437cqvlexdq3mwhv8lnr6mmejx5r5dvhxwy9 on Cosmos back to Ethereum
[2021-09-09T03:27:07Z INFO  test_runner::happy_path] Sent tokens to Ethereum with TXSendResponse { logs: Some(Array([Object({"events": Array([Object({"attributes": Array([Object({"key": String("action"), "value": String("send_to_eth")}), Object({"key": String("sender"), "value": String("cosmos1ry437cqvlexdq3mwhv8lnr6mmejx5r5dvhxwy9")}), Object({"key": String("module"), "value": String("send_to_eth")}), Object({"key": String("outgoing_tx_id"), "value": String("1")})]), "type": String("message")}), Object({"attributes": Array([Object({"key": String("recipient"), "value": String("cosmos1979qcq0kdz72w0k9rsxcmfmagx2cydrslxhw5s")}), Object({"key": String("sender"), "value": String("cosmos1ry437cqvlexdq3mwhv8lnr6mmejx5r5dvhxwy9")}), Object({"key": String("amount"), "value": String("296peggy0x0412C7c846bb6b7DC462CF6B453f76D8440b2609")})]), "type": String("transfer")}), Object({"attributes": Array([Object({"key": String("module"), "value": String("peggy")}), Object({"key": String("bridge_contract")}), Object({"key": String("bridge_chain_id"), "value": String("0")}), Object({"key": String("outgoing_tx_id"), "value": String("1")}), Object({"key": String("nonce"), "value": String("1")})]), "type": String("withdrawal_received")})])})])), txhash: "45EE2B81A9D11E987A3B35614064C7E975AB509D38EACFB6436FF3443D5C9F15" }
[2021-09-09T03:27:07Z INFO  test_runner::happy_path] Requesting transaction batch
[2021-09-09T03:27:14Z INFO  orchestrator::main_loop] Sending batch confirm for 0x0412C7c846bb6b7DC462CF6B453f76D8440b2609:1 with 1 in fees
[2021-09-09T03:27:14Z INFO  orchestrator::main_loop] Sending batch confirm for 0x0412C7c846bb6b7DC462CF6B453f76D8440b2609:1 with 1 in fees
[2021-09-09T03:27:14Z INFO  orchestrator::main_loop] Sending batch confirm for 0x0412C7c846bb6b7DC462CF6B453f76D8440b2609:1 with 1 in fees
[2021-09-09T03:27:19Z INFO  relayer::batch_relaying] We have detected latest batch 1 but latest on Ethereum is 0 This batch is estimated to cost 1000000000 Gas / 0.0002 ETH to submit
[2021-09-09T03:27:19Z INFO  ethereum_peggy::submit_batch] Ordering signatures and submitting TransactionBatch 0x0412C7c846bb6b7DC462CF6B453f76D8440b2609:1 to Ethereum
[2021-09-09T03:27:19Z INFO  relayer::batch_relaying] We have detected latest batch 1 but latest on Ethereum is 0 This batch is estimated to cost 1000000000 Gas / 0.0002 ETH to submit
[2021-09-09T03:27:19Z INFO  ethereum_peggy::submit_batch] Ordering signatures and submitting TransactionBatch 0x0412C7c846bb6b7DC462CF6B453f76D8440b2609:1 to Ethereum
[2021-09-09T03:27:19Z INFO  relayer::batch_relaying] We have detected latest batch 1 but latest on Ethereum is 0 This batch is estimated to cost 1000000000 Gas / 0.0002 ETH to submit
[2021-09-09T03:27:19Z INFO  ethereum_peggy::submit_batch] Ordering signatures and submitting TransactionBatch 0x0412C7c846bb6b7DC462CF6B453f76D8440b2609:1 to Ethereum
[2021-09-09T03:27:19Z INFO  test_runner::happy_path] Batch is not yet submitted 0>, waiting
[2021-09-09T03:27:19Z INFO  ethereum_peggy::submit_batch] Sent batch update with txid 0x6722bab5eab2a59747617a904b5bfc10278f94ca510ca4c006a001cf8315d275
[2021-09-09T03:27:19Z INFO  ethereum_peggy::submit_batch] Sent batch update with txid 0x7d354c7ca134ba6acc080ae8551824eb987f1666146eaa623842b732fbfa2225
[2021-09-09T03:27:19Z INFO  ethereum_peggy::submit_batch] Sent batch update with txid 0x0c715ddebf2f1e692ae7f2ed6d4d889f8480ea457052a7f7e8b7ace5a9fda1b9
[2021-09-09T03:27:21Z INFO  ethereum_peggy::submit_batch] Successfully updated Batch with new Nonce 1
[2021-09-09T03:27:21Z INFO  ethereum_peggy::submit_batch] Successfully updated Batch with new Nonce 1
[2021-09-09T03:27:21Z INFO  ethereum_peggy::submit_batch] Successfully updated Batch with new Nonce 1
[2021-09-09T03:27:23Z INFO  test_runner::happy_path] Batch is not yet submitted 0>, waiting
[2021-09-09T03:27:30Z INFO  orchestrator::ethereum_event_watcher] Oracle observed batch with nonce 1, contract 0x0412C7c846bb6b7DC462CF6B453f76D8440b2609, and event nonce 4
[2021-09-09T03:27:31Z INFO  orchestrator::ethereum_event_watcher] Oracle observed batch with nonce 1, contract 0x0412C7c846bb6b7DC462CF6B453f76D8440b2609, and event nonce 4
[2021-09-09T03:27:32Z INFO  orchestrator::ethereum_event_watcher] Oracle observed batch with nonce 1, contract 0x0412C7c846bb6b7DC462CF6B453f76D8440b2609, and event nonce 4
[2021-09-09T03:27:35Z INFO  orchestrator::ethereum_event_watcher] Claims processed, new nonce 4
[2021-09-09T03:27:35Z INFO  orchestrator::ethereum_event_watcher] Claims processed, new nonce 4
[2021-09-09T03:27:35Z INFO  orchestrator::ethereum_event_watcher] Claims processed, new nonce 4
[2021-09-09T03:27:40Z INFO  test_runner::happy_path] Successfully updated txbatch nonce to 1 and sent 295peggy0x0412C7c846bb6b7DC462CF6B453f76D8440b2609 tokens to Ethereum!
^C⏎                                                                                                                                                                                                                                                                               
 gravity-bridge-sample master tail -f ./data/log/all-up-test-1631165494.log 
[2021-09-09T05:33:09Z INFO  test_runner::bootstrapping] Signing and submitting Delegate addresses 0xCfDF23e2073FE18E18210c432F6BF715669F5933 for validator cosmos1d87pzm8y6eydlkme8vhf3h2mpz88tec9c8nxsl
[2021-09-09T05:33:09Z INFO  test_runner::bootstrapping] Signing and submitting Delegate addresses 0x79F57399de0B685C6cAE03798437a1e9Df1dF67C for validator cosmos1ehepl35uft5zkt8ns6xqlu3v99k9sqvs62me0u
5:33AM ERR dialing failed (attempts: 1): auth failure: secret conn failed: read tcp 7.7.7.3:53502->7.7.7.3:26656: read: connection reset by peer addr={"id":"1f8029b98d23820775da44da197395bbf08dfac4","ip":"7.7.7.3","port":26656} module=pex
5:33AM ERR dialing failed (attempts: 1): auth failure: secret conn failed: EOF addr={"id":"897178eec4d4ba08b5513cf293c2fc2b366561a9","ip":"7.7.7.2","port":26656} module=pex
5:34AM ERR dialing failed (attempts: 2): auth failure: secret conn failed: EOF addr={"id":"1f8029b98d23820775da44da197395bbf08dfac4","ip":"7.7.7.3","port":26656} module=pex
5:34AM ERR dialing failed (attempts: 2): auth failure: secret conn failed: EOF addr={"id":"897178eec4d4ba08b5513cf293c2fc2b366561a9","ip":"7.7.7.2","port":26656} module=pex
5:34AM ERR dialing failed (attempts: 3): auth failure: secret conn failed: EOF addr={"id":"1f8029b98d23820775da44da197395bbf08dfac4","ip":"7.7.7.3","port":26656} module=pex
5:34AM ERR dialing failed (attempts: 3): auth failure: secret conn failed: EOF addr={"id":"897178eec4d4ba08b5513cf293c2fc2b366561a9","ip":"7.7.7.2","port":26656} module=pex
5:35AM ERR dialing failed (attempts: 4): auth failure: secret conn failed: EOF addr={"id":"1f8029b98d23820775da44da197395bbf08dfac4","ip":"7.7.7.3","port":26656} module=pex
5:35AM ERR dialing failed (attempts: 4): auth failure: secret conn failed: EOF addr={"id":"897178eec4d4ba08b5513cf293c2fc2b366561a9","ip":"7.7.7.2","port":26656} module=pex
5:35AM ERR dialing failed (attempts: 5): auth failure: secret conn failed: EOF addr={"id":"1f8029b98d23820775da44da197395bbf08dfac4","ip":"7.7.7.3","port":26656} module=pex
5:35AM ERR dialing failed (attempts: 5): auth failure: secret conn failed: EOF addr={"id":"897178eec4d4ba08b5513cf293c2fc2b366561a9","ip":"7.7.7.2","port":26656} module=pex
5:36AM ERR dialing failed (attempts: 6): auth failure: secret conn failed: EOF addr={"id":"1f8029b98d23820775da44da197395bbf08dfac4","ip":"7.7.7.3","port":26656} module=pex
5:36AM ERR dialing failed (attempts: 6): auth failure: secret conn failed: EOF addr={"id":"897178eec4d4ba08b5513cf293c2fc2b366561a9","ip":"7.7.7.2","port":26656} module=pex
5:38AM ERR dialing failed (attempts: 7): auth failure: secret conn failed: EOF addr={"id":"1f8029b98d23820775da44da197395bbf08dfac4","ip":"7.7.7.3","port":26656} module=pex
5:38AM ERR dialing failed (attempts: 7): auth failure: secret conn failed: EOF addr={"id":"897178eec4d4ba08b5513cf293c2fc2b366561a9","ip":"7.7.7.2","port":26656} module=pex
[2021-09-09T05:38:51Z INFO  test_runner::bootstrapping] stdout: Test mode, deploying ERC20 contracts
    ERC20 deployed at Address -  0x0412C7c846bb6b7DC462CF6B453f76D8440b2609
    ERC20 deployed at Address -  0x30dA8589BFa1E509A319489E014d384b87815D89
    ERC20 deployed at Address -  0x9676519d99E390A180Ab1445d5d857E3f6869065
    Uniswap Liquidity test deployed at Address -  0xD7600ae27C99988A6CD360234062b540F88ECA43
    Starting Peggy contract deploy
    About to get latest Peggy valset
    {
      "type": "peggy/Valset",
      "value": {
        "nonce": "63",
        "members": [
          {
            "power": "1431655765",
            "ethereum_address": "0x5AF468C92Ba6e6C100A9107A3D1eBE535Af8E3Ef"
          },
          {
            "power": "1431655765",
            "ethereum_address": "0x79F57399de0B685C6cAE03798437a1e9Df1dF67C"
          },
          {
            "power": "1431655765",
            "ethereum_address": "0xCfDF23e2073FE18E18210c432F6BF715669F5933"
          }
        ],
        "height": "63"
      }
    }
    Peggy deployed at Address -  0x7580bFE88Dd3d07947908FAE12d95872a260F2D8
    
[2021-09-09T05:38:51Z INFO  test_runner::bootstrapping] stderr: 
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

    Finished release [optimized] target(s) in 2.22s
     Running `/peggy/orchestrator/target/release/test-runner`
[2021-09-09T05:38:54Z INFO  test_runner] Staring Peggy test-runner
[2021-09-09T05:38:54Z INFO  test_runner] Waiting for Cosmos chain to come online
[2021-09-09T05:39:09Z INFO  test_runner::utils] Sending orchestrators 100 eth to pay for fees miner has 23229340 ETH
[2021-09-09T05:39:15Z INFO  test_runner] Starting tests with Ok("")
[2021-09-09T05:39:15Z INFO  test_runner] Starting Happy path test
[2021-09-09T05:39:15Z INFO  test_runner::happy_path] Spawning Orchestrator
[2021-09-09T05:39:16Z INFO  orchestrator::oracle_resync] Oracle is resyncing, looking back into the history to find our last event nonce 1, on block 12
[2021-09-09T05:39:16Z INFO  test_runner::happy_path] Spawning Orchestrator
[2021-09-09T05:39:16Z INFO  test_runner::happy_path] Spawning Orchestrator
[2021-09-09T05:39:16Z INFO  orchestrator::oracle_resync] Oracle is resyncing, looking back into the history to find our last event nonce 1, on block 12
[2021-09-09T05:39:16Z INFO  orchestrator::main_loop] Sending 5 valset confirms starting with 5
[2021-09-09T05:39:16Z INFO  orchestrator::oracle_resync] Oracle is resyncing, looking back into the history to find our last event nonce 1, on block 12
[2021-09-09T05:39:16Z INFO  orchestrator::main_loop] Oracle resync complete, Oracle now operational
[2021-09-09T05:39:16Z INFO  orchestrator::main_loop] Oracle resync complete, Oracle now operational
[2021-09-09T05:39:16Z INFO  test_runner::happy_path] Sending in valset request
[2021-09-09T05:39:16Z INFO  test_runner::happy_path] Delegating 125000000stake to cosmosvaloper1husmmfe3gq6wn0y7y0q2ed6tsnatrs9nkamp3h in order to generate a validator set update
[2021-09-09T05:39:19Z INFO  test_runner::happy_path] stdout: {"height":"70","txhash":"6E573CAE02F2DCF35CCD994CE658E9518709E74F14CDA793959E30F2EE637A05","codespace":"","code":0,"data":"0A0A0A0864656C6567617465","raw_log":"[{\"events\":[{\"type\":\"delegate\",\"attributes\":[{\"key\":\"validator\",\"value\":\"cosmosvaloper1husmmfe3gq6wn0y7y0q2ed6tsnatrs9nkamp3h\"},{\"key\":\"amount\",\"value\":\"125000000\"}]},{\"type\":\"message\",\"attributes\":[{\"key\":\"action\",\"value\":\"delegate\"},{\"key\":\"sender\",\"value\":\"cosmos1jv65s3grqf6v6jl3dp4t6c9t9rk99cd88lyufl\"},{\"key\":\"module\",\"value\":\"staking\"},{\"key\":\"sender\",\"value\":\"cosmos1husmmfe3gq6wn0y7y0q2ed6tsnatrs9nnf05ay\"}]},{\"type\":\"transfer\",\"attributes\":[{\"key\":\"recipient\",\"value\":\"cosmos1husmmfe3gq6wn0y7y0q2ed6tsnatrs9nnf05ay\"},{\"key\":\"sender\",\"value\":\"cosmos1jv65s3grqf6v6jl3dp4t6c9t9rk99cd88lyufl\"},{\"key\":\"amount\",\"value\":\"12688stake\"}]}]}]","logs":[{"msg_index":0,"log":"","events":[{"type":"delegate","attributes":[{"key":"validator","value":"cosmosvaloper1husmmfe3gq6wn0y7y0q2ed6tsnatrs9nkamp3h"},{"key":"amount","value":"125000000"}]},{"type":"message","attributes":[{"key":"action","value":"delegate"},{"key":"sender","value":"cosmos1jv65s3grqf6v6jl3dp4t6c9t9rk99cd88lyufl"},{"key":"module","value":"staking"},{"key":"sender","value":"cosmos1husmmfe3gq6wn0y7y0q2ed6tsnatrs9nnf05ay"}]},{"type":"transfer","attributes":[{"key":"recipient","value":"cosmos1husmmfe3gq6wn0y7y0q2ed6tsnatrs9nnf05ay"},{"key":"sender","value":"cosmos1jv65s3grqf6v6jl3dp4t6c9t9rk99cd88lyufl"},{"key":"amount","value":"12688stake"}]}]}],"info":"","gas_wanted":"200000","gas_used":"129925","tx":null,"timestamp":""}
    
[2021-09-09T05:39:19Z INFO  test_runner::happy_path] stderr: 
[2021-09-09T05:39:19Z INFO  orchestrator::main_loop] Oracle resync complete, Oracle now operational
[2021-09-09T05:39:19Z INFO  orchestrator::main_loop] Sending 5 valset confirms starting with 5
[2021-09-09T05:39:19Z INFO  orchestrator::main_loop] Sending 5 valset confirms starting with 5
[2021-09-09T05:39:20Z INFO  test_runner::happy_path] Validator set is not yet updated to 0>, waiting
[2021-09-09T05:39:20Z ERROR relayer::valset_relaying] We don't have a latest confirmed valset?
[2021-09-09T05:39:20Z ERROR relayer::valset_relaying] We don't have a latest confirmed valset?
[2021-09-09T05:39:20Z ERROR relayer::valset_relaying] We don't have a latest confirmed valset?
[2021-09-09T05:39:24Z INFO  test_runner::happy_path] Validator set is not yet updated to 0>, waiting
[2021-09-09T05:39:27Z INFO  orchestrator::main_loop] Sending 6 valset confirms starting with 70
[2021-09-09T05:39:27Z INFO  orchestrator::main_loop] Sending 1 valset confirms starting with 70
[2021-09-09T05:39:27Z INFO  orchestrator::main_loop] Sending 1 valset confirms starting with 70
[2021-09-09T05:39:28Z INFO  test_runner::happy_path] Validator set is not yet updated to 0>, waiting
[2021-09-09T05:39:32Z INFO  test_runner::happy_path] Validator set is not yet updated to 0>, waiting
[2021-09-09T05:39:33Z INFO  relayer::valset_relaying] We have detected latest valset 70 but latest on Ethereum is 0 This valset is estimated to cost 1000000000 Gas / 0.0001 ETH to submit
[2021-09-09T05:39:33Z INFO  ethereum_peggy::valset_update] Ordering signatures and submitting validator set 0 -> 70 update to Ethereum
[2021-09-09T05:39:33Z INFO  relayer::valset_relaying] We have detected latest valset 70 but latest on Ethereum is 0 This valset is estimated to cost 1000000000 Gas / 0.0001 ETH to submit
[2021-09-09T05:39:33Z INFO  ethereum_peggy::valset_update] Ordering signatures and submitting validator set 0 -> 70 update to Ethereum
[2021-09-09T05:39:33Z INFO  relayer::valset_relaying] We have detected latest valset 70 but latest on Ethereum is 0 This valset is estimated to cost 1000000000 Gas / 0.0001 ETH to submit
[2021-09-09T05:39:33Z INFO  ethereum_peggy::valset_update] Ordering signatures and submitting validator set 0 -> 70 update to Ethereum
[2021-09-09T05:39:33Z INFO  ethereum_peggy::valset_update] Sent valset update with txid 0xc32d6a27120603899883cc1a17cd803172d1118c6b96ab1ccd8365d18d5fbb35
[2021-09-09T05:39:34Z INFO  ethereum_peggy::valset_update] Sent valset update with txid 0x2e2b931849488a2c1e17e41785bb653d9d3fbcb788ea554cc6411bea4f70da3f
[2021-09-09T05:39:34Z INFO  ethereum_peggy::valset_update] Sent valset update with txid 0xd073017288b278637103639bfdbd0095ce0613015f9044150b7ae3bb813bcec4
[2021-09-09T05:39:36Z INFO  test_runner::happy_path] Validator set is not yet updated to 0>, waiting
[2021-09-09T05:39:40Z INFO  test_runner::happy_path] Validator set is not yet updated to 0>, waiting
[2021-09-09T05:39:41Z INFO  ethereum_peggy::valset_update] Successfully updated Valset with new Nonce 70
[2021-09-09T05:39:41Z INFO  ethereum_peggy::valset_update] Successfully updated Valset with new Nonce 70
[2021-09-09T05:39:41Z INFO  ethereum_peggy::valset_update] Successfully updated Valset with new Nonce 70
[2021-09-09T05:39:44Z INFO  test_runner::happy_path] Validator set is not yet updated to 0>, waiting
[2021-09-09T05:39:48Z INFO  test_runner::happy_path] Validator set successfully updated!
[2021-09-09T05:39:48Z INFO  test_runner::happy_path] Sending in valset request
[2021-09-09T05:39:48Z INFO  test_runner::happy_path] Delegating 125000000stake to cosmosvaloper1ehepl35uft5zkt8ns6xqlu3v99k9sqvsl70vr0 in order to generate a validator set update
[2021-09-09T05:39:52Z INFO  test_runner::happy_path] stdout: {"height":"76","txhash":"2BE846C1ED50C51EA8ED0A7BFE9A218410368EA79671998186811AB9A8C88910","codespace":"","code":0,"data":"0A0A0A0864656C6567617465","raw_log":"[{\"events\":[{\"type\":\"delegate\",\"attributes\":[{\"key\":\"validator\",\"value\":\"cosmosvaloper1ehepl35uft5zkt8ns6xqlu3v99k9sqvsl70vr0\"},{\"key\":\"amount\",\"value\":\"125000000\"}]},{\"type\":\"message\",\"attributes\":[{\"key\":\"action\",\"value\":\"delegate\"},{\"key\":\"module\",\"value\":\"staking\"},{\"key\":\"sender\",\"value\":\"cosmos1husmmfe3gq6wn0y7y0q2ed6tsnatrs9nnf05ay\"}]}]}]","logs":[{"msg_index":0,"log":"","events":[{"type":"delegate","attributes":[{"key":"validator","value":"cosmosvaloper1ehepl35uft5zkt8ns6xqlu3v99k9sqvsl70vr0"},{"key":"amount","value":"125000000"}]},{"type":"message","attributes":[{"key":"action","value":"delegate"},{"key":"module","value":"staking"},{"key":"sender","value":"cosmos1husmmfe3gq6wn0y7y0q2ed6tsnatrs9nnf05ay"}]}]}],"info":"","gas_wanted":"200000","gas_used":"98701","tx":null,"timestamp":""}
    
[2021-09-09T05:39:52Z INFO  test_runner::happy_path] stderr: 
[2021-09-09T05:39:52Z INFO  orchestrator::main_loop] Sending 1 valset confirms starting with 76
[2021-09-09T05:39:52Z INFO  orchestrator::main_loop] Sending 1 valset confirms starting with 76
[2021-09-09T05:39:52Z INFO  orchestrator::main_loop] Sending 1 valset confirms starting with 76
[2021-09-09T05:39:52Z INFO  test_runner::happy_path] Validator set is not yet updated to 70>, waiting
[2021-09-09T05:39:56Z INFO  test_runner::happy_path] Validator set is not yet updated to 70>, waiting
[2021-09-09T05:40:00Z INFO  test_runner::happy_path] Validator set is not yet updated to 70>, waiting
[2021-09-09T05:40:04Z INFO  test_runner::happy_path] Validator set is not yet updated to 70>, waiting
[2021-09-09T05:40:08Z INFO  test_runner::happy_path] Validator set is not yet updated to 70>, waiting
[2021-09-09T05:40:09Z INFO  relayer::valset_relaying] We have detected latest valset 76 but latest on Ethereum is 70 This valset is estimated to cost 1000000000 Gas / 0.0001 ETH to submit
[2021-09-09T05:40:09Z INFO  ethereum_peggy::valset_update] Ordering signatures and submitting validator set 70 -> 76 update to Ethereum
[2021-09-09T05:40:09Z INFO  relayer::valset_relaying] We have detected latest valset 76 but latest on Ethereum is 70 This valset is estimated to cost 1000000000 Gas / 0.0001 ETH to submit
[2021-09-09T05:40:09Z INFO  ethereum_peggy::valset_update] Ordering signatures and submitting validator set 70 -> 76 update to Ethereum
[2021-09-09T05:40:09Z INFO  relayer::valset_relaying] We have detected latest valset 76 but latest on Ethereum is 70 This valset is estimated to cost 1000000000 Gas / 0.0001 ETH to submit
[2021-09-09T05:40:09Z INFO  ethereum_peggy::valset_update] Ordering signatures and submitting validator set 70 -> 76 update to Ethereum
[2021-09-09T05:40:09Z INFO  ethereum_peggy::valset_update] Sent valset update with txid 0xfad5a1e9a11c2baeffee437b9336a9b4cda7b29afa55b9a57e3906b6f1531bbf
[2021-09-09T05:40:10Z INFO  ethereum_peggy::valset_update] Sent valset update with txid 0xb9159eca05eed40303b9b3787883137a49b755b7462f9df05c640e9eeaaec29f
[2021-09-09T05:40:10Z INFO  ethereum_peggy::valset_update] Sent valset update with txid 0x9c5b82dc2c8f23e18711738fb94e7c51f0801323e1dd4d3712aa09e289c53c56
[2021-09-09T05:40:12Z INFO  test_runner::happy_path] Validator set is not yet updated to 70>, waiting
[2021-09-09T05:40:16Z INFO  test_runner::happy_path] Validator set is not yet updated to 70>, waiting
[2021-09-09T05:40:20Z INFO  test_runner::happy_path] Validator set is not yet updated to 70>, waiting
[2021-09-09T05:40:23Z INFO  ethereum_peggy::valset_update] Successfully updated Valset with new Nonce 76
[2021-09-09T05:40:23Z INFO  ethereum_peggy::valset_update] Successfully updated Valset with new Nonce 76
[2021-09-09T05:40:23Z INFO  ethereum_peggy::valset_update] Successfully updated Valset with new Nonce 76
[2021-09-09T05:40:25Z INFO  test_runner::happy_path] Validator set is not yet updated to 70>, waiting
[2021-09-09T05:40:29Z INFO  test_runner::happy_path] Validator set successfully updated!
[2021-09-09T05:40:29Z INFO  test_runner::happy_path] Sending to Cosmos from 0xBf660843528035a5A4921534E156a27e64B231fE to cosmos1fepg4w8h7krvvctk3aakulteurcgxemnavqs2d with amount 100
5:40AM ERR dialing failed (attempts: 8): auth failure: secret conn failed: EOF addr={"id":"1f8029b98d23820775da44da197395bbf08dfac4","ip":"7.7.7.3","port":26656} module=pex
5:40AM ERR dialing failed (attempts: 8): auth failure: secret conn failed: read tcp 7.7.7.2:37964->7.7.7.2:26656: read: connection reset by peer addr={"id":"897178eec4d4ba08b5513cf293c2fc2b366561a9","ip":"7.7.7.2","port":26656} module=pex
[2021-09-09T05:40:52Z INFO  test_runner::happy_path] Send to Cosmos txid: 0xc9bade6bc1a1d4cd50359ffe98bb4a14f0e42cc1982b843e1978b98e1db3454c
[2021-09-09T05:40:52Z INFO  test_runner::happy_path] Waiting for ERC20 deposit
[2021-09-09T05:40:58Z INFO  test_runner::happy_path] Waiting for ERC20 deposit
[2021-09-09T05:41:00Z INFO  orchestrator::ethereum_event_watcher] Oracle observed deposit with sender 0xBf660843528035a5A4921534E156a27e64B231fE, destination cosmos1fepg4w8h7krvvctk3aakulteurcgxemnavqs2d, amount 100, and event nonce 1
[2021-09-09T05:41:00Z INFO  orchestrator::ethereum_event_watcher] Oracle observed deposit with sender 0xBf660843528035a5A4921534E156a27e64B231fE, destination cosmos1fepg4w8h7krvvctk3aakulteurcgxemnavqs2d, amount 100, and event nonce 1
[2021-09-09T05:41:03Z INFO  orchestrator::ethereum_event_watcher] Claims processed, new nonce 1
[2021-09-09T05:41:03Z INFO  orchestrator::ethereum_event_watcher] Claims processed, new nonce 1
[2021-09-09T05:41:03Z INFO  test_runner::happy_path] Waiting for ERC20 deposit
[2021-09-09T05:41:03Z INFO  orchestrator::ethereum_event_watcher] Oracle observed deposit with sender 0xBf660843528035a5A4921534E156a27e64B231fE, destination cosmos1fepg4w8h7krvvctk3aakulteurcgxemnavqs2d, amount 100, and event nonce 1
[2021-09-09T05:41:08Z INFO  orchestrator::ethereum_event_watcher] Claims processed, new nonce 1
[2021-09-09T05:41:09Z INFO  test_runner::happy_path] Successfully bridged ERC20 100peggy0x0412C7c846bb6b7DC462CF6B453f76D8440b2609 to Cosmos! Balance is now 100peggy0x0412C7c846bb6b7DC462CF6B453f76D8440b2609
[2021-09-09T05:41:09Z INFO  test_runner::happy_path] Sending to Cosmos from 0xBf660843528035a5A4921534E156a27e64B231fE to cosmos1fepg4w8h7krvvctk3aakulteurcgxemnavqs2d with amount 100
[2021-09-09T05:41:14Z INFO  test_runner::happy_path] Send to Cosmos txid: 0x66411a544a7d387c34766ccd35af9c9aee4007d5bb54dc660ad29438450686be
[2021-09-09T05:41:14Z INFO  test_runner::happy_path] Waiting for ERC20 deposit
[2021-09-09T05:41:16Z INFO  orchestrator::ethereum_event_watcher] Oracle observed deposit with sender 0xBf660843528035a5A4921534E156a27e64B231fE, destination cosmos1fepg4w8h7krvvctk3aakulteurcgxemnavqs2d, amount 100, and event nonce 2
[2021-09-09T05:41:19Z INFO  orchestrator::ethereum_event_watcher] Claims processed, new nonce 2
[2021-09-09T05:41:19Z INFO  test_runner::happy_path] Waiting for ERC20 deposit
[2021-09-09T05:41:24Z INFO  test_runner::happy_path] Waiting for ERC20 deposit
[2021-09-09T05:41:26Z INFO  orchestrator::ethereum_event_watcher] Oracle observed deposit with sender 0xBf660843528035a5A4921534E156a27e64B231fE, destination cosmos1fepg4w8h7krvvctk3aakulteurcgxemnavqs2d, amount 100, and event nonce 2
[2021-09-09T05:41:26Z INFO  orchestrator::ethereum_event_watcher] Oracle observed deposit with sender 0xBf660843528035a5A4921534E156a27e64B231fE, destination cosmos1fepg4w8h7krvvctk3aakulteurcgxemnavqs2d, amount 100, and event nonce 2
[2021-09-09T05:41:30Z INFO  orchestrator::ethereum_event_watcher] Claims processed, new nonce 2
[2021-09-09T05:41:30Z INFO  orchestrator::ethereum_event_watcher] Claims processed, new nonce 2
[2021-09-09T05:41:30Z INFO  test_runner::happy_path] Successfully bridged ERC20 100peggy0x0412C7c846bb6b7DC462CF6B453f76D8440b2609 to Cosmos! Balance is now 200peggy0x0412C7c846bb6b7DC462CF6B453f76D8440b2609
[2021-09-09T05:41:30Z INFO  test_runner::happy_path] Sending to Cosmos from 0xBf660843528035a5A4921534E156a27e64B231fE to cosmos1fepg4w8h7krvvctk3aakulteurcgxemnavqs2d with amount 100
[2021-09-09T05:41:37Z INFO  test_runner::happy_path] Send to Cosmos txid: 0x4f173ea7eea34279fa95fe871ee42c30aa5fc0ff6267cb2cc35c0dcb869e13d9
[2021-09-09T05:41:37Z INFO  test_runner::happy_path] Waiting for ERC20 deposit
[2021-09-09T05:41:39Z INFO  orchestrator::ethereum_event_watcher] Oracle observed deposit with sender 0xBf660843528035a5A4921534E156a27e64B231fE, destination cosmos1fepg4w8h7krvvctk3aakulteurcgxemnavqs2d, amount 100, and event nonce 3
[2021-09-09T05:41:39Z INFO  orchestrator::ethereum_event_watcher] Oracle observed deposit with sender 0xBf660843528035a5A4921534E156a27e64B231fE, destination cosmos1fepg4w8h7krvvctk3aakulteurcgxemnavqs2d, amount 100, and event nonce 3
[2021-09-09T05:41:41Z INFO  test_runner::happy_path] Waiting for ERC20 deposit
[2021-09-09T05:41:41Z INFO  orchestrator::ethereum_event_watcher] Claims processed, new nonce 3
[2021-09-09T05:41:41Z INFO  orchestrator::ethereum_event_watcher] Claims processed, new nonce 3
[2021-09-09T05:41:43Z INFO  orchestrator::ethereum_event_watcher] Oracle observed deposit with sender 0xBf660843528035a5A4921534E156a27e64B231fE, destination cosmos1fepg4w8h7krvvctk3aakulteurcgxemnavqs2d, amount 100, and event nonce 3
[2021-09-09T05:41:46Z INFO  orchestrator::ethereum_event_watcher] Claims processed, new nonce 3
[2021-09-09T05:41:47Z INFO  test_runner::happy_path] Successfully bridged ERC20 100peggy0x0412C7c846bb6b7DC462CF6B453f76D8440b2609 to Cosmos! Balance is now 300peggy0x0412C7c846bb6b7DC462CF6B453f76D8440b2609
[2021-09-09T05:42:03Z INFO  test_runner::happy_path] Successfully failed to duplicate ERC20!
[2021-09-09T05:42:03Z INFO  test_runner::happy_path] Sending 295peggy0x0412C7c846bb6b7DC462CF6B453f76D8440b2609 from cosmos1fepg4w8h7krvvctk3aakulteurcgxemnavqs2d on Cosmos back to Ethereum
[2021-09-09T05:42:08Z INFO  test_runner::happy_path] Sent tokens to Ethereum with TXSendResponse { logs: Some(Array([Object({"events": Array([Object({"attributes": Array([Object({"key": String("action"), "value": String("send_to_eth")}), Object({"key": String("sender"), "value": String("cosmos1fepg4w8h7krvvctk3aakulteurcgxemnavqs2d")}), Object({"key": String("module"), "value": String("send_to_eth")}), Object({"key": String("outgoing_tx_id"), "value": String("1")})]), "type": String("message")}), Object({"attributes": Array([Object({"key": String("recipient"), "value": String("cosmos1979qcq0kdz72w0k9rsxcmfmagx2cydrslxhw5s")}), Object({"key": String("sender"), "value": String("cosmos1fepg4w8h7krvvctk3aakulteurcgxemnavqs2d")}), Object({"key": String("amount"), "value": String("296peggy0x0412C7c846bb6b7DC462CF6B453f76D8440b2609")})]), "type": String("transfer")}), Object({"attributes": Array([Object({"key": String("module"), "value": String("peggy")}), Object({"key": String("bridge_contract")}), Object({"key": String("bridge_chain_id"), "value": String("0")}), Object({"key": String("outgoing_tx_id"), "value": String("1")}), Object({"key": String("nonce"), "value": String("1")})]), "type": String("withdrawal_received")})])})])), txhash: "089E9F79D93F2520B04D89DC5081C7B13C0AE488672C601CF152B707C106E416" }
[2021-09-09T05:42:08Z INFO  test_runner::happy_path] Requesting transaction batch
[2021-09-09T05:42:15Z INFO  orchestrator::main_loop] Sending batch confirm for 0x0412C7c846bb6b7DC462CF6B453f76D8440b2609:1 with 1 in fees
[2021-09-09T05:42:15Z INFO  orchestrator::main_loop] Sending batch confirm for 0x0412C7c846bb6b7DC462CF6B453f76D8440b2609:1 with 1 in fees
[2021-09-09T05:42:15Z INFO  orchestrator::main_loop] Sending batch confirm for 0x0412C7c846bb6b7DC462CF6B453f76D8440b2609:1 with 1 in fees
[2021-09-09T05:42:20Z INFO  test_runner::happy_path] Batch is not yet submitted 0>, waiting
[2021-09-09T05:42:24Z INFO  test_runner::happy_path] Batch is not yet submitted 0>, waiting
[2021-09-09T05:42:25Z INFO  relayer::batch_relaying] We have detected latest batch 1 but latest on Ethereum is 0 This batch is estimated to cost 1000000000 Gas / 0.0002 ETH to submit
[2021-09-09T05:42:25Z INFO  ethereum_peggy::submit_batch] Ordering signatures and submitting TransactionBatch 0x0412C7c846bb6b7DC462CF6B453f76D8440b2609:1 to Ethereum
[2021-09-09T05:42:25Z INFO  relayer::batch_relaying] We have detected latest batch 1 but latest on Ethereum is 0 This batch is estimated to cost 1000000000 Gas / 0.0002 ETH to submit
[2021-09-09T05:42:25Z INFO  ethereum_peggy::submit_batch] Ordering signatures and submitting TransactionBatch 0x0412C7c846bb6b7DC462CF6B453f76D8440b2609:1 to Ethereum
[2021-09-09T05:42:25Z INFO  relayer::batch_relaying] We have detected latest batch 1 but latest on Ethereum is 0 This batch is estimated to cost 1000000000 Gas / 0.0002 ETH to submit
[2021-09-09T05:42:25Z INFO  ethereum_peggy::submit_batch] Ordering signatures and submitting TransactionBatch 0x0412C7c846bb6b7DC462CF6B453f76D8440b2609:1 to Ethereum
[2021-09-09T05:42:26Z INFO  ethereum_peggy::submit_batch] Sent batch update with txid 0xca58e46e24643b04ed7f299f2496b3568490de99b68f559445217be825e9c174
[2021-09-09T05:42:26Z INFO  ethereum_peggy::submit_batch] Sent batch update with txid 0xff1137139b8c350c8879e99813ea4c5ac2938e21d63878b40676a70e13c238bd
[2021-09-09T05:42:26Z INFO  ethereum_peggy::submit_batch] Sent batch update with txid 0x8835369d8f5930cdbaf7ff1316664480d4f89d0ed0eb94492f8a1c346db26720
[2021-09-09T05:42:28Z INFO  ethereum_peggy::submit_batch] Successfully updated Batch with new Nonce 1
[2021-09-09T05:42:28Z INFO  ethereum_peggy::submit_batch] Successfully updated Batch with new Nonce 1
[2021-09-09T05:42:28Z INFO  ethereum_peggy::submit_batch] Successfully updated Batch with new Nonce 1
[2021-09-09T05:42:28Z INFO  test_runner::happy_path] Batch is not yet submitted 0>, waiting
[2021-09-09T05:42:31Z INFO  orchestrator::ethereum_event_watcher] Oracle observed batch with nonce 1, contract 0x0412C7c846bb6b7DC462CF6B453f76D8440b2609, and event nonce 4
[2021-09-09T05:42:31Z INFO  orchestrator::ethereum_event_watcher] Oracle observed batch with nonce 1, contract 0x0412C7c846bb6b7DC462CF6B453f76D8440b2609, and event nonce 4
[2021-09-09T05:42:34Z INFO  orchestrator::ethereum_event_watcher] Oracle observed batch with nonce 1, contract 0x0412C7c846bb6b7DC462CF6B453f76D8440b2609, and event nonce 4
[2021-09-09T05:42:36Z INFO  orchestrator::ethereum_event_watcher] Claims processed, new nonce 4
[2021-09-09T05:42:36Z INFO  orchestrator::ethereum_event_watcher] Claims processed, new nonce 4
[2021-09-09T05:42:36Z INFO  orchestrator::ethereum_event_watcher] Claims processed, new nonce 4
[2021-09-09T05:42:40Z INFO  test_runner::happy_path] Successfully updated txbatch nonce to 1 and sent 295peggy0x0412C7c846bb6b7DC462CF6B453f76D8440b2609 tokens to Ethereum!
```