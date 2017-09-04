#!/bin/bash
terraform output -json "ocp_public_ips" | jq '.value|.[]' -r

