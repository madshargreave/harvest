#!/bin/sh

release_ctl eval --mfa "HAServer.Task.migrate/1" -- "$@"
