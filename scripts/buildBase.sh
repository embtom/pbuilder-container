#!/bin/bash

pbuilder create --debootstrapopts --variant=buildd \
--distribution "bionic" \
--architecture "amd64" \
--othermirror "deb [trusted=yes] http://tomhp/reprepo bionic main"
