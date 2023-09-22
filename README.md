# depthai-docker

Dockerized `depthai-ros` ROS package ([GitHub repo here](https://github.com/luxonis/depthai-ros))

## Quick start

1. Connect the camera with the USB cable.

2. Clone this repository:
```
git clone https://github.com/husarion/depthai-docker.git
cd depthai-docker/demo/oak-1
```

3. Pull necessary docker images:
```
docker copmose pull
```

4. Launch it with the RViz:
```
xhost +local:docker && docker compose up
```
