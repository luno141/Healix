#!/bin/bash
echo "Building Healix Healthcare Management System..."
export JAVA_HOME=$HOME/.jdks/jdk-21
export PATH=$JAVA_HOME/bin:$PATH
/home/luno/.local/bin/gradle build -x test && /home/luno/.local/bin/gradle run
