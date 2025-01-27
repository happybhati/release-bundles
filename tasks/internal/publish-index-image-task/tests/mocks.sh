#!/usr/bin/env bash
set -x

function skopeo() {
  echo Mock skopeo called with: "$*" >&2

  # Handle "skopeo inspect" for a failing case
  if [[ "$*" == *"inspect --tls-verify=false docker://registry-proxy.engineering.redhat.com/fail --format '{{.Digest}}'"* ]]; then
    echo "Mock failure: Image does not exist" >&2
    return 1

  # Handle "skopeo inspect" for a successful case
  elif [[ "$*" == *"inspect --tls-verify=false docker://registry-proxy.engineering.redhat.com/foo --format '{{.Digest}}'"* ]]; then
    echo "sha256:abcd1234"
    return 0

  # Handle "skopeo inspect" for target image check
  elif [[ "$*" == *"inspect --tls-verify=false docker://quay.io/target --format '{{.Digest}}'"* ]]; then
    echo "sha256:xyz9876"
    return 0

  # Handle "skopeo copy"
  elif [[ "$*" == *"skopeo copy"* ]]; then
    echo "Mock skopeo copy called with: $*"
    return 0  

  else
    echo "Error: Unexpected call"
    exit 1
  fi
}
