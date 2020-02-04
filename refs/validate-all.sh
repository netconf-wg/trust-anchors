#!/bin/bash

echo "Testing ietf-truststore.yang (pyang)..."
pyang --ietf --max-line-length=69 -p ../ ../ietf-truststore\@*.yang
pyang --canonical -p ../ ../ietf-truststore\@*.yang

echo "Testing ietf-truststore.yang (yanglint)..."
yanglint ../ietf-truststore\@*.yang

echo "Testing ex-truststore.xml..."
yanglint -s ../ietf-truststore\@*.yang ../ietf-crypto-types\@*.yang ./ietf-origin.yang ex-truststore.xml

echo "Testing ex-notification-ce.xml..."
echo -e 'setns a=urn:ietf:params:xml:ns:netconf:notification:1.0\nsetns b=urn:ietf:params:xml:ns:yang:ietf-truststore\ncat //a:notification/b:truststore' | xmllint --shell ex-notification-ce.xml | sed -e '/^\/.*/d' -e '/^ *$/d' > yanglint-notification.xml
yanglint -s -t notif -r ex-truststore.xml ../ietf-*\@*.yang yanglint-notification.xml
rm yanglint-notification.xml

