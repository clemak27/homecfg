#!/bin/bash

function kj() { kubectl "$@" -o json | jq; }
function ky() { kubectl "$@" -o yaml | bat -p -P --language=yaml; }
function wk() { viddy --no-title kubecolor --force-colors "$@"; }
