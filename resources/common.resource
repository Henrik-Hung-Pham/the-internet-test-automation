*** Settings ***
Documentation       Common imports shared by every suite and keyword resource.
...                 Centralizes the Browser library import (and its timeout) so the
...                 configuration lives in exactly one place instead of being repeated
...                 in each test and keyword file. Import this instead of declaring
...                 ``Library    Browser`` directly.

Resource            variables/global_variables.resource
Library             Browser    timeout=${BROWSER_TIMEOUT}
