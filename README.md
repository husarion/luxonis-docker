# depthai-docker

Dockerized `depthai-ros` ROS package ([GitHub repo here](https://github.com/luxonis/depthai-ros))

## Quick start

Clone this repository:
```
git clone https://github.com/husarion/depthai-docker.git
cd depthai-docker/demo/oak-1
```

Pull necessary docker images:
```
docker copmose pull
```

Launch it with the RViz:
```
xhost +local:docker && docker compose up
```
