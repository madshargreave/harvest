#!/bin/sh

release_ctl eval --mfa "Harvest.Server.Task.migrate/1" -- "$@"
