# Dockerized Mikrotik RouterOS CHR image

Runs the latest Mikrotik RouterOS Cloud Hosted Router (CHR) image from within a 512m Qemu guest VM
containerized in Docker. RouterOS has the same physical interfaces as the host.

Forked from [EvilFreelancer](https://github.com/EvilFreelancer/docker-routeros).
Qemu networking as per [linux-kvm.org](http://www.linux-kvm.org/page/Networking).

## How to use


### Network setup

RouterOS, Qemu and Docker will share the same physical interfaces (eno1, etc.) as the host network.
Qemu and Docker to run in public bridge, and host networking modes respectively.
For so doing, setup merges physical interfaces eno1, etc. and tap altogether in bridge br0 (to be created)
RouterOS <--> QEMU  <--> Docker container <--> Host
              (tap)      (br0, eno1)

Create new `br0` bridge (exact string expected by quemu script).
And add physical interface eno1 (change to reflect current setup) to br0
IP address should rest on the brdige (move it from eno1 to br0 as needed)
```bash
sudo ip link add br0 type bridge      # create and
sudo ip link set dev eno1 master br0  # or `sudo brctl addif br0 eno1`
sudo ip address add 192.168.0.99/24 dev br0
sudo ip link set br0 up               # enable new bridge
```

Creating tap0 interface (for use by Qemu) and adding it to bridge 
is normally self taken care of. Guidelines for manual configuration though:
```bash
sudo ip tuntap add tap0 mode tap      # create and
sudo ip link set tap0 up              # enable tap interface
sudo ip link set dev tap0 master br0  # or `sudo brctl addif br0 tap0`
```

Check network config. should get as below.
```bash
# br0   8000.308d99179bb7 no    tap0
#                               eno1
brctl show
```

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
docker run -d -ti --privileged -net host --name my-name techoutlooks/docker-routeros
```

### Build from sources

For this you need download project and build everything from scratch:

```bash
git clone https://github.com/techoutlooks/docker-routeros.git
cd docker-routeros
sudo docker build . --tag ceduth/ros:latest
docker run -d -ti --privileged --net host --name my-name ceduth/ros:latest 
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


### TODO

Auto-dectect and configure network interfaces.