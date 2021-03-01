# eth-proxy
Simple proxy for Chainstack ethereum nodes.
The proxy adds Authorization header to all rpc/ws requests.

# CI
Docker image is built automatically on Dockerhub.

# Usage

1. Install docker
1. Spin up eth-proxy docker container:
    ```
    # RPC_ENDPOINT - rpc enpoint of the node deployed on Chainstack
    # WS_ENDPOINT - ws endpoint of the node deployed on Chainstack
    # USERNAME, PASSWORD - basic auth credentials to access the node deployed on Chainstack

    # docker run -d --name eth-proxy -p 8545:8545 -p 8546:8546 -e RPC_ENDPOINT=<rpc-endpoint> -e WS_ENDPOINT=<ws-endpoint> -e USERNAME=<username> -e PASSWORD=<password> chainstack/eth-proxy
    docker run -d --name eth-proxy -p 8545:8545 -p 8546:8546 -e RPC_ENDPOINT=nd-123-456-789.p2pify.chainstack.com -e WS_ENDPOINT=ws-nd-123-456-789.p2pify.chainstack.com -e USERNAME=awesome-username -e PASSWORD=awesome-password chainstack/eth-proxy
    ```
1. Use proxy to send reuqests to the node:
    ```
    curl 'http://localhost:8545' -H 'Content-Type: application/json' -d '{"jsonrpc": "2.0","method": "eth_blockNumber","params": [],"id": 83}'
    ```




