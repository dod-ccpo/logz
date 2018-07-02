# logz

## Server

### Installation

On Ubuntu bionic, there is a script to add a repo and install td-agent:

```
curl -L https://toolbelt.treasuredata.com/sh/install-ubuntu-bionic-td-agent3.sh | sh
```

(<https://docs.fluentd.org/v1.0/articles/python#installing-fluentd>)

### Configuration

THe steps below are based on this documentation: https://docs.fluentd.org/v1.0/articles/in_forward#how-to-enable-tls-encryption

## Steps to configure the server (logz).

1. Generate an SSL certificate.
2. Add the passphrase for the cert to the configuration file.
3. Generate a shared key, and put it in the configuration file.
4. Put the configuration file into place.
5. Put the cert in place.
6. Done!  You can now start the server.

## Details:

1. Generate an SSL certificate.  Save the passphrase.

     openssl req -new -x509 -sha256 -days 1095 -newkey rsa:2048 \
                -keyout fluentd.key -out fluentd.crt

2. Add the passphrase for the cert to the configuration file.

     sed -e 's/PASSPHRASE_HERE/passphrase_from_above/' server/td-agent.conf

3. Generate a shared key, and put it in the configuration file.

     KEY=`head -n 1024 /dev/urandom | base64 | head -1 | tr -cd '[:alnum:]'`
     # or your favorite random key generator
     sed -e "s/SHARED_KEY_HERE/$KEY/" server/td-agent.conf

4. Put the configuration file into place.

     sudo cp server/td-agent.conf /etc/td-agent/td-agent.conf

5. Put the cert in place.

     sudo mkdir /var/run/td-agent
     sudo mkdir /etc/td-agent/certs
     sudo mv fluentd.* /etc/td-agent/certs/
     sudo chmod 700 /etc/td-agent/certs/
     sudo chmod 400 /etc/td-agent/certs/*
     sudo chown -R td-agent:td-agent /etc/td-agent/certs /var/run/td-agent

6. Done!  You can now start the server (scroll down).

```

### Starting the server

    sudo service td-agent start

### Client

The configuration below sends nginx logs from a service, such as
ATST, to the logz server.

### Installation

Installation is the same as above:
```
curl -L https://toolbelt.treasuredata.com/sh/install-ubuntu-bionic-td-agent3.sh | sh
# Ensure that td-agent can access log files, e.g.
usermod td-agent -G adm
```

### Configuration

1. Put the shared key on the server in the client configuration.
2. Put the same TLS cert that's on the server onto the client.
3. That's it!  You can start the daemon on the client.

Details:

1. Put the shared key on the server into the client configuration.

    KEY= ....the same value from step 3 above...
    sed -e "s/SHARED_KEY_HERE/$KEY/" client/td-agent.conf

2. Put the same TLS cert on the server onto the client.

    # scp fluentd.crt to the client machine, then
    sudo cp fluentd.crt /etc/td-agent/certs/fluentd.crt

3. That's it!  You can start the daemon on the client.  (read on)


### Starting the Daemon on the Client

    sudo service td-agent start


### Verifying that things are working.

This setup collects nginx logs and stores them on the server in
/var/log/td-agent/atat-nginx*.log.  To see what is going on
type this into a terminal window:

    sudo su -
    tail -f /var/log/td-agent/atat-nginx*.log

Then try:

    curl https://www.atat.logs/?test=12345

and watch as the log entry appears in the window.
