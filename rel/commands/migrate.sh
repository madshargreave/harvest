#!/bin/sh

release_ctl eval --mfa "HaCore.Task.migrate/0" -- "$@"
