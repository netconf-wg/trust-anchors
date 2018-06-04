#!/bin/bash

echo "Testing ietf-trust-anchors.yang (pyang)..."
pyang --ietf --max-line-length=69 -p ../ ../ietf-trust-anchors\@*.yang
pyang --canonical -p ../ ../ietf-trust-anchors\@*.yang

echo "Testing ietf-trust-anchors.yang (yanglint)..."
yanglint ../ietf-trust-anchors\@*.yang

echo "Testing ex-trust-anchors.xml..."
yanglint -s ../ietf-trust-anchors\@*.yang ./ietf-origin.yang ex-trust-anchors.xml

echo "Testing ex-notification-ce.xml..."
echo -e 'setns a=urn:ietf:params:xml:ns:netconf:notification:1.0\nsetns b=urn:ietf:params:xml:ns:yang:ietf-trust-anchors\ncat //a:notification/b:trust-anchors' | xmllint --shell ex-notification-ce.xml | sed -e '/^\/.*/d' -e '/^ *$/d' > yanglint-notification.xml
yanglint -s -t notif -r ex-trust-anchors.xml ../ietf-*\@*.yang yanglint-notification.xml
rm yanglint-notification.xml

