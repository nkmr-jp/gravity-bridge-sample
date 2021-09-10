# gravity-bridge-sample

See: https://github.com/cosmos/gravity-bridge/tree/v0.1.1

リポジトリ取得
```sh
make clone 
```

Dockerで各種サービスを起動してテスト実行
```sh
make all-up-test 

# トラブルシューティング
## Error HH502: Couldn't download compiler versions list. Please check your connection.
## VPNを無効にして実行する。
```

ログの確認
```sh
tail -f ./data/log/all-up-test-[timestamp].log 
cat  ./data/log/all-up-test-[timestamp].log
```

peggy(gravity)コマンドのビルド
```sh
make build-cmd
```

peggy(gravity)コマンドの動作確認
```sh
peggy version
#> 0.1.1

peggy help
#> Stargate Peggy App

#> Usage:
#>   peggy [command]
#> 
#> Available Commands:
#>               
#>               
#>   add-genesis-account Add a genesis account to genesis.json
#>   collect-gentxs      Collect genesis txs and output a genesis.json file
#>   debug               Tool for helping with debugging your application
#>   eth_keys            Manage your application's ethereum keys
#>   export              Export state to JSON
#>   gentx               Generate a genesis tx carrying a self delegation
#>   help                Help about any command
#>   init                Initialize private validator, p2p, genesis, and application configuration files
#>   keys                Manage your application's keys
#>   migrate             Migrate genesis to a specified target version
#>   query               Querying subcommands
#>   start               Run the full node
#>   status              Query remote node for status
#>   tendermint          Tendermint subcommands
#>   testnet             Initialize files for a simapp testnet
#>   tx                  Transactions subcommands
#>   unsafe-reset-all    Resets the blockchain database, removes address book files, and resets data/priv_validator_state.json to the genesis state
#>   validate-genesis    validates the genesis file at the default location or at the location passed as an arg
#>   version             Print the application binary version information
#> 
#> Flags:
#>   -h, --help               help for peggy
#>       --home string        directory for config and data (default "$HOME/.peggy")
#>       --log_level string   The logging level in the format of <module>:<level>,... (default "info")
#>       --trace              print out full stack trace on errors
#> 
#> Use "peggy [command] --help" for more information about a command.
#> 
```