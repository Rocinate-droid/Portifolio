#!/bin/bash
Fruits=("hello" "world" "devops")
echo "${Fruits[@]}"
Fruits+=("grapes")
echo "${#Fruits[@]}"
