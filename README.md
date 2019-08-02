# Mikrotik RouterOS in Docker

Fork from [EvilFreelancer](https://github.com/EvilFreelancer/docker-routeros)
running the latest Mikrotik CHR image, with qemu VM having bridged network interface.

## How to use

### Create your own `Dockerfile`

List of all available tags is [here](https://hub.docker.com/r/techoutlooks/docker-routeros/tags/),
`latest` will be used by default.

```dockerfile
FROM techoutlooks/docker-routeros
ADD ["your-scripts.sh", "/"]
RUN /your-scripts.sh
```

### Use image from docker hub

```bash
docker pull techoutlooks/docker-routeros
docker run -d -p 2222:22 -p 8728:8728 -p 8729:8729 -p 5900:5900 -ti techoutlooks/docker-routeros
```

### Use in docker-compose.yml

Example is [here](docker-compose.yml).

```yml
version: "3"

services:

  routeros-6-42:
    image: techoutlooks/docker-routeros:6.42.12
    restart: unless-stopped
    ports:
      - "12222:22"
      - "12223:23"
      - "18728:8728"
      - "18729:8729"

  routeros-6-44:
    image: techoutlooks/docker-routeros:6.44
    restart: unless-stopped
    ports:
      - "22222:22"
      - "22223:23"
      - "28728:8728"
      - "28729:8729"

```

### Build from sources

For this you need download project and build everything from scratch:

```bash
git clone https://github.com/techoutlooks/docker-routeros.git
cd docker-routeros
sudo ip link add br0 type bridge
sudo ip link set eth0 master br0
cd docker-routeros && sudo docker build . --tag ceduth/ros:latest
docker run -d -ti --privileged --net host --name r002.sm ceduth/ros:latest 
```

Now you can connect to your RouterOS container via VNC protocol
(on localhost 5900 port) and via SSH (on localhost 2222 port).

## List of exposed ports

For access via VNC: 5900

Default ports of RouterOS: 21, 22, 23, 80, 443, 8291, 8728, 8729

IPSec: 50, 51, 500, 4500

OpenVPN: 1194

L2TP: 1701

PPTP: 1723
