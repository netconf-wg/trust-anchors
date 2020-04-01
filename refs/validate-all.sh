#!/bin/bash

run_unix_cmd() {
  # $1 is the line number
  # $2 is the cmd to run
  # $3 is the expected exit code
  output=`$2 2>&1`
  exit_code=$?
  if [[ $exit_code -ne $3 ]]; then
    printf "failed (incorrect exit status code) on line $1.\n"
    printf "  - exit code: $exit_code (expected $3)\n"
    printf "  - command: $2\n"
    if [[ -z $output ]]; then
      printf "  - output: <none>\n\n"
    else
      printf "  - output: <starts on next line>\n$output\n\n"
    fi
    exit 1
  fi
}

printf "Testing ietf-truststore.yang (pyang)..."
command="pyang -Werror --ietf --max-line-length=69 -p ../ ../ietf-truststore\@*.yang"
run_unix_cmd $LINENO "$command" 0
command="pyang --canonical -p ../ ../ietf-truststore\@*.yang"
run_unix_cmd $LINENO "$command" 0
printf "okay.\n"

printf "Testing ietf-truststore.yang (yanglint)..."
command="yanglint ../ietf-truststore\@*.yang"
run_unix_cmd $LINENO "$command" 0
printf "okay.\n"

printf "Testing ex-truststore.xml..."
command="yanglint -s ../ietf-truststore\@*.yang ../ietf-crypto-types\@*.yang ./ietf-origin.yang ex-truststore.xml"
run_unix_cmd $LINENO "$command" 0
printf "okay.\n"

printf "Testing ex-notification-ce.xml..."
echo -e 'setns a=urn:ietf:params:xml:ns:netconf:notification:1.0\nsetns b=urn:ietf:params:xml:ns:yang:ietf-truststore\ncat //a:notification/b:truststore' | xmllint --shell ex-notification-ce.xml | sed -e '/^\/.*/d' -e '/^ *$/d' > yanglint-notification.xml
command="yanglint -s -t notif -r ex-truststore.xml ../ietf-*\@*.yang yanglint-notification.xml"
run_unix_cmd $LINENO "$command" 0
printf "okay.\n"
rm yanglint-notification.xml

