#!/bin/bash


#shopt -s dotglob
mkdir src-copy
rm -r src-copy/*
cp -R ../.htaccess ../* src-copy/
tar --exclude "./build.tar" -cvf build.tar .