# logz

## Server

### installation

On Ubuntu bionic:

```
curl -L https://toolbelt.treasuredata.com/sh/install-ubuntu-bionic-td-agent3.sh | sh
```

(<https://docs.fluentd.org/v1.0/articles/python#installing-fluentd>)

### Configuration

```
sudo cp server/td-agent.conf /etc/td-agent/td-agent.conf
```

### Running

sudo service td-agent start

## Client

The configuration below sends nginx logs from a service, such as
ATST to the logz server.

### Installation

Same as server installation above.

### Configuration

The configuration is currently based on running
ssh tunnels from the services to the log server.

```
sudo cp client/td-agent.conf /etc/td-agent/td-agent.conf
# Set up .ssh/config to allow ssh to logz-dev
```

### Running

For development we run an SSH tunnel in a screen session
to logz.  The configuration file included sends logs
to localhost, which get tunneled to the logz.

```
script/start-tunnel.sh
# ^A:detach<CR>
sudo service td-agent start
```
