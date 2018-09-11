#!/bin/bash


# run the service mesh visualization container

docker run -d -p 3000:3000 -p 9191:9191  dhp/servicemesh-telemetry:1.0.0 

